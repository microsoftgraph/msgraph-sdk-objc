//
// Copyright (c) Microsoft Corporation. All Rights Reserved. Licensed under the MIT License. See License in the project root for license information.
//

#import <XCTest/XCTest.h>
#import "MSGraphClientSDKTests.h"
#import "MSLargeFileUploadTask.h"

@interface MSLargeFileUploadTask()

@property (nonatomic, strong) MSHTTPClient *httpClient;
@property (nonatomic, strong) NSData *fileData;
@property (nonatomic, strong) NSDictionary *uploadSessionDictionary;
@property (nonatomic) NSInteger chunkSize;
@property (nonatomic) NSRange currentRange;

- (void)uploadNextSegmentWithCompletion:(MSRawUploadCompletionHandler)completionHandler;

@end


@interface MSLargeFileUploadTaskTests : MSGraphClientSDKTests

@property (nonatomic, strong) NSHTTPURLResponse *OKResponse;
@property (nonatomic, strong) NSHTTPURLResponse *acceptedResponse;

@end

@implementation MSLargeFileUploadTaskTests{
    NSData *fileData;
    NSDictionary *uploadSessionDictionary;
    MSLargeFileUploadTask *chunkedUploadTask;
    NSData *successData;
}

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    self.OKResponse = [[NSHTTPURLResponse alloc] initWithURL:[NSURL URLWithString:MSGraphBaseURL] statusCode:MSExpectedResponseCodesOK HTTPVersion:@"foo" headerFields:nil];
    self.acceptedResponse = [[NSHTTPURLResponse alloc] initWithURL:[NSURL URLWithString:MSGraphBaseURL] statusCode:MSExpectedResponseCodesAccepted HTTPVersion:@"foo" headerFields:nil];

    NSString *imagePath = [[NSBundle bundleForClass:[self class]] pathForResource:@"LargeFileUploadResource" ofType:@".bmp"];
    fileData = [NSData dataWithContentsOfFile:imagePath];
    uploadSessionDictionary = [NSDictionary dictionaryWithObjectsAndKeys:MSGraphBaseURL,@"uploadUrl", nil];
    chunkedUploadTask = [[MSLargeFileUploadTask alloc] initWithClient:self.mockClient fileData:fileData uploadSessionDictionary:uploadSessionDictionary andChunkSize:0];

    NSDictionary *successDictionary = [NSDictionary dictionaryWithObjectsAndKeys:@"aasd123aad123",@"id", nil];
    successData = [NSJSONSerialization dataWithJSONObject:successDictionary options:kNilOptions error:nil];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testInitWithMalformedInputs {
    XCTAssertThrows([[MSLargeFileUploadTask alloc] initWithClient:nil fileData:fileData uploadSessionDictionary:uploadSessionDictionary andChunkSize:0]);

    XCTAssertThrows([[MSLargeFileUploadTask alloc] initWithClient:self.mockClient fileData:nil uploadSessionDictionary:uploadSessionDictionary andChunkSize:0]);

    XCTAssertThrows([[MSLargeFileUploadTask alloc] initWithClient:self.mockClient fileData:fileData uploadSessionDictionary:nil andChunkSize:0]);

    XCTAssertThrows([[MSLargeFileUploadTask alloc] initWithClient:self.mockClient fileData:fileData uploadSessionDictionary:[NSDictionary new] andChunkSize:0]);
}

- (void)testSuccessfullInit {
    MSLargeFileUploadTask *largeFileUploadTask = [[MSLargeFileUploadTask alloc] initWithClient:self.mockClient fileData:fileData uploadSessionDictionary:uploadSessionDictionary andChunkSize:0];

    XCTAssertEqual(largeFileUploadTask.httpClient, self.mockClient);
    XCTAssertEqual(largeFileUploadTask.fileData, fileData);
    XCTAssertEqual(largeFileUploadTask.uploadSessionDictionary, uploadSessionDictionary);
    XCTAssertEqual(largeFileUploadTask.chunkSize, 5*1024*1024);
}

- (void)testSetNextRange {
    [chunkedUploadTask performSelector:@selector(setNextRange)];

    XCTAssertEqual(chunkedUploadTask.currentRange.location, DefaultChunkSize);
    XCTAssertEqual(chunkedUploadTask.currentRange.length, DefaultChunkSize);
}

- (void)testUploadWithCompletion {
    MSLargeFileUploadTask *partialUploadTask = OCMPartialMock(chunkedUploadTask);

    OCMStub([partialUploadTask uploadNextSegmentWithCompletion:[OCMArg any]]).andDo(^(NSInvocation *invocation){
        HTTPRequestCompletionHandler completionHandler;
        [invocation getArgument:&completionHandler atIndex:2];
        completionHandler([NSData new], self.OKResponse, nil);
    });

    [partialUploadTask uploadWithCompletion:^(NSData *data, NSURLResponse *response, NSError *error) {
        [self completionBlockCodeInvoked];
        XCTAssertNil(error);
        XCTAssertNotNil(response);
        XCTAssertEqual(((NSHTTPURLResponse *)response).statusCode, MSExpectedResponseCodesOK);
        XCTAssertNotNil(data);
    }];
    [self checkCompletionBlockCodeInvoked];
}

- (void)testUploadSingleSegment {

    MSAuthenticationHandler *partialHandler = OCMPartialMock(self.mockClient.middleware);

    OCMStub([partialHandler execute:[OCMArg any] withCompletionHandler:[OCMArg any]]).andDo(^(NSInvocation *invocation){
        HTTPRequestCompletionHandler completionHandler;
        [invocation getArgument:&completionHandler atIndex:3];
        completionHandler(self->successData, self.OKResponse, nil);
    });
    [chunkedUploadTask uploadWithCompletion:^(NSData *data, NSURLResponse *response, NSError *error) {
        [self completionBlockCodeInvoked];
        XCTAssertNil(error);
        XCTAssertNotNil(response);
        XCTAssertEqual(((NSHTTPURLResponse *)response).statusCode, MSExpectedResponseCodesOK);
        XCTAssertNotNil(data);
    }];
    [self checkCompletionBlockCodeInvoked];
}

- (void)testFullIteration {

    MSAuthenticationHandler *partialHandler = OCMPartialMock(self.mockClient.middleware);

    __block int i=0;
    OCMStub([partialHandler execute:[OCMArg any] withCompletionHandler:[OCMArg any]]).andDo(^(NSInvocation *invocation){
        i++;
        NSLog(@"%d - i ki value",i);

         __unsafe_unretained HTTPRequestCompletionHandler completionHandler;
        [invocation getArgument:&completionHandler atIndex:3];

         __unsafe_unretained MSURLSessionDataTask *dataTask;
        [invocation getArgument:&dataTask atIndex:2];

        if(i==1) {
            completionHandler([NSData new], self->_acceptedResponse, nil);
        }else if( i==2){
        
            completionHandler ([NSData new], self->_OKResponse, nil);
        }else {
            completionHandler(self->successData, self.OKResponse, nil);
        }
    });

    [chunkedUploadTask uploadWithCompletion:^(NSData *data, NSURLResponse *response, NSError *error) {
        [self completionBlockCodeInvoked];
        XCTAssertNil(error);
        XCTAssertNotNil(response);
        XCTAssertEqual(((NSHTTPURLResponse *)response).statusCode, MSExpectedResponseCodesOK);
        XCTAssertNotNil(data);
    }];
    [self checkCompletionBlockCodeInvoked];
}

- (void)testCreateUploadSession {
    MSAuthenticationHandler *partialHandler = OCMPartialMock(self.mockClient.middleware);

    OCMStub([partialHandler execute:[OCMArg any] withCompletionHandler:[OCMArg any]]).andDo(^(NSInvocation *invocation){
        HTTPRequestCompletionHandler completionHandler;
        [invocation getArgument:&completionHandler atIndex:3];
        completionHandler(self->successData, self.OKResponse, nil);
    });

    [MSLargeFileUploadTask createUploadSessionFromRequest:self.requestForMock andHTTPClient:self.mockClient completionBlock:^(id data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        XCTAssertNil(error);
        XCTAssertNotNil(response);
        XCTAssertEqual(((NSHTTPURLResponse *)response).statusCode, MSExpectedResponseCodesOK);
        XCTAssertNotNil(data);
    }];
}

@end
