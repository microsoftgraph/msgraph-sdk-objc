//
// Copyright (c) Microsoft Corporation. All Rights Reserved. Licensed under the MIT License. See License in the project root for license information.
//

#import <XCTest/XCTest.h>
#import "MSGraphCoreSDKTests.h"

@interface MSAuthenticationMiddleware()

@property (nonatomic, strong) id<MSGraphMiddleware> nextMiddleware;


@end

@interface MSURLSessionTask()

- (void)taskCompletedWithData:(id)data response:(NSURLResponse *)response andError:(NSError *)error;

@end

@interface MSGraphWorkloadsTests : MSGraphCoreSDKTests

@property (nonatomic, retain) NSData *responseData;
@property (nonatomic)  NSHTTPURLResponse *OKresponse;
@property (nonatomic)  id mockMiddleware;
@end

@implementation MSGraphWorkloadsTests

- (void)setUp {
    [super setUp];
    OCMStub([self.mockAuthProvider appendAuthenticationHeaders:[OCMArg any] completion:[OCMArg any]])
    .andDo(^(NSInvocation *invocation){
        void (^completionHandler)(NSMutableURLRequest *request, NSError *error);
        [invocation getArgument:&completionHandler atIndex:3];
        completionHandler(self.requestForMock,nil);
    });
     _OKresponse = [[NSHTTPURLResponse alloc] initWithURL:[NSURL URLWithString:MSGraphBaseURL] statusCode:MSExpectedResponseCodesOK HTTPVersion:@"foo" headerFields:nil];
    MSAuthenticationMiddleware *authMiddleware = self.mockClient.middleware;
    id middleware = authMiddleware.nextMiddleware;

    _mockMiddleware = OCMPartialMock(middleware);
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testDriveItemSearchRequest{


    NSDictionary *expectedResponseDict = @{
                                  @"@odata.context": @"https://graph.microsoft.com/v1.0/$metadata#Collection(driveItem)",
                                  @"@odata.nextLink": @"https://graph.microsoft.com/v1.0/me/drive/root/microsoft.graph.search(q='test')",
                                  @"value": @[@{@"entityId":@"testId1",@"name":@"testName1"}, @{@"entityId":@"testId2",@"name":@"testName2"}]
                                  };
    self.responseData = [NSJSONSerialization dataWithJSONObject:expectedResponseDict options:0 error:nil];

    XCTestExpectation *testExpectation = [[XCTestExpectation alloc] initWithDescription:@"Waiting for completion of 'resume' of data task"];

    NSMutableURLRequest *requestForDriveItemSearch = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[MSGraphBaseURL stringByAppendingString:@"/me/drive/root/microsoft.graph.search(q='test')"]]];
    MSURLSessionDataTask *dataTask = [self.mockClient dataTaskWithRequest:requestForDriveItemSearch completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        [self completionBlockCodeInvoked];
        NSDictionary *actualResponseDictionary = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
        XCTAssertEqual([(NSArray *)[actualResponseDictionary objectForKey:@"value"] count], [(NSArray *)[expectedResponseDict objectForKey:@"value"] count]);
        NSDictionary * driveItem1 = [(NSArray *)[actualResponseDictionary objectForKey:@"value"] objectAtIndex:0];
        XCTAssertEqualObjects([driveItem1 objectForKey:@"entityId"], [(NSArray *)[expectedResponseDict objectForKey:@"value"] objectAtIndex:0][@"entityId"]);
        XCTAssertEqualObjects([driveItem1 objectForKey:@"name"], [(NSArray *)[expectedResponseDict objectForKey:@"value"] objectAtIndex:0][@"name"]);

        NSDictionary * driveItem2 = [(NSArray *)[actualResponseDictionary objectForKey:@"value"] objectAtIndex:1];
        XCTAssertEqualObjects([driveItem2 objectForKey:@"entityId"], [(NSArray *)[expectedResponseDict objectForKey:@"value"] objectAtIndex:1][@"entityId"]);
        XCTAssertEqualObjects([driveItem2 objectForKey:@"name"], [(NSArray *)[expectedResponseDict objectForKey:@"value"] objectAtIndex:1][@"name"]);

        XCTAssertEqualObjects([actualResponseDictionary objectForKey:@"@odata.nextLink"], [expectedResponseDict objectForKey:@"@odata.nextLink"]);

        XCTAssertEqual(((NSHTTPURLResponse*)response).statusCode, MSExpectedResponseCodesOK);
        XCTAssertNil(error);

        [testExpectation fulfill];

    }];

    id mockNSTask = OCMClassMock([NSURLSessionDataTask class]);
    OCMStub([_mockMiddleware dataTaskWithRequest:[OCMArg any] completionHandler:[OCMArg any]]).andReturn(mockNSTask);
    
    OCMStub([mockNSTask resume])
    .andDo(^(NSInvocation *invocation){
        [dataTask taskCompletedWithData:self.responseData response:self->_OKresponse andError:nil];
    });

    [dataTask execute];
    [self waitForExpectations:@[testExpectation] timeout:5.0];
    [self checkCompletionBlockCodeInvoked];

}

- (void)testUserPhotoDownload{

    NSMutableURLRequest *requestForUserPhotoDownload = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[MSGraphBaseURL stringByAppendingString:@"/me/photo/$value"]]];
    NSString *downloadPath = [[NSBundle bundleForClass:[self class]] pathForResource:@"UserPhoto" ofType:@".jpg"];

    XCTestExpectation *testExpectation = [[XCTestExpectation alloc] initWithDescription:@"Waiting for completion of 'resume' of download task"];

    MSURLSessionDownloadTask *downloadTask = [self.mockClient downloadTaskWithRequest:requestForUserPhotoDownload completionHandler:^(NSURL *location, NSURLResponse *response, NSError *error) {
        [self completionBlockCodeInvoked];
        XCTAssertEqualObjects(downloadPath, [location absoluteString]);
        XCTAssertEqual(((NSHTTPURLResponse*)response).statusCode, MSExpectedResponseCodesOK);
        XCTAssertNil(error);
        [testExpectation fulfill];
    }];

    id mockNSTask = OCMClassMock([NSURLSessionDownloadTask class]);
    OCMStub([_mockMiddleware downloadTaskWithRequest:[OCMArg any] progress:[OCMArg anyObjectRef] completionHandler:[OCMArg any]]).andReturn(mockNSTask);

    OCMStub([mockNSTask resume]).andDo(^(NSInvocation *invocation){
        [downloadTask taskCompletedWithData:[NSURL URLWithString:downloadPath] response:self->_OKresponse andError:nil];
    });
    [downloadTask execute];
    [self waitForExpectations:@[testExpectation] timeout:5.0];
    [self checkCompletionBlockCodeInvoked];
}

- (void)testUserPhotoUploadFromFile{

    NSMutableURLRequest *requestForUserPhotoUpload = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[MSGraphBaseURL stringByAppendingString:@"/me/photo/$value"]]];
    NSString *filePath = [[NSBundle bundleForClass:[self class]] pathForResource:@"UserPhoto" ofType:@".jpg"];

    XCTestExpectation *testExpectation = [[XCTestExpectation alloc] initWithDescription:@"Waiting for completion of 'resume' of upload task"];

    MSURLSessionUploadTask *uploadTask = [self.mockClient uploadTaskWithRequest:requestForUserPhotoUpload fromFile:[NSURL URLWithString:filePath] completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        [self completionBlockCodeInvoked];
        XCTAssertNil(data);
        XCTAssertEqual(((NSHTTPURLResponse*)response).statusCode, MSExpectedResponseCodesOK);
        XCTAssertNil(error);
        [testExpectation fulfill];
    }];

    id mockNSTask = OCMClassMock([NSURLSessionUploadTask class]);
    OCMStub([_mockMiddleware uploadTaskWithRequest:[OCMArg any] fromFile:[OCMArg any] progress:[OCMArg anyObjectRef] completionHandler:[OCMArg any]]).andReturn(mockNSTask);

    OCMStub([mockNSTask resume]).andDo(^(NSInvocation *invocation){
        [uploadTask taskCompletedWithData:nil response:self->_OKresponse andError:nil];
    });
    [uploadTask execute];
    [self waitForExpectations:@[testExpectation] timeout:5.0];
    [self checkCompletionBlockCodeInvoked];
}

- (void)testUserPhotoUploadFromData{

    NSMutableURLRequest *requestForUserPhotoUpload = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[MSGraphBaseURL stringByAppendingString:@"/me/photo/$value"]]];
    NSString *filePath = [[NSBundle bundleForClass:[self class]] pathForResource:@"UserPhoto" ofType:@".jpg"];
    NSData *fileData = [NSData dataWithContentsOfFile:filePath];
    XCTestExpectation *testExpectation = [[XCTestExpectation alloc] initWithDescription:@"Waiting for completion of 'resume' of upload task"];

    MSURLSessionUploadTask *uploadTask = [self.mockClient uploadTaskWithRequest:requestForUserPhotoUpload fromData:fileData completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        [self completionBlockCodeInvoked];
        XCTAssertNil(data);
        XCTAssertEqual(((NSHTTPURLResponse*)response).statusCode, MSExpectedResponseCodesOK);
        XCTAssertNil(error);
        [testExpectation fulfill];
    }];

    id mockNSTask = OCMClassMock([NSURLSessionUploadTask class]);
    OCMStub([_mockMiddleware uploadTaskWithRequest:[OCMArg any] fromData:[OCMArg any] progress:[OCMArg anyObjectRef] completionHandler:[OCMArg any]]).andReturn(mockNSTask);

    OCMStub([mockNSTask resume]).andDo(^(NSInvocation *invocation){
        [uploadTask taskCompletedWithData:nil response:self->_OKresponse andError:nil];
    });
    [uploadTask execute];
    [self waitForExpectations:@[testExpectation] timeout:5.0];
    [self checkCompletionBlockCodeInvoked];
}

@end
