//
// Copyright (c) Microsoft Corporation. All Rights Reserved. Licensed under the MIT License. See License in the project root for license information.
//

#import <XCTest/XCTest.h>
#import "MSGraphClientSDKTests.h"
#import "MSGraphOneDriveLargeFileUploadTask.h"

@interface MSGraphOneDriveLargeFileUploadTask()

+ (NSMutableURLRequest *)createUploadSessionRequestWithFileName:(NSString *)fileName filePath:(NSString *)filePath;

@end

@interface MSGraphOneDriveLargeFileUploadTests : MSGraphClientSDKTests

@end

@implementation MSGraphOneDriveLargeFileUploadTests{
    NSData *fileData;
    NSHTTPURLResponse *OKResponse;
    NSHTTPURLResponse *failureResponse;
    NSData *successData;
}

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    NSString *imagePath = [[NSBundle bundleForClass:[self class]] pathForResource:@"LargeFileUploadResource" ofType:@".bmp"];
    fileData = [NSData dataWithContentsOfFile:imagePath];

    NSDictionary *successDictionary = [[NSDictionary alloc] initWithObjectsAndKeys:MSGraphBaseURL,@"uploadUrl", nil];
    successData = [NSJSONSerialization dataWithJSONObject:successDictionary options:kNilOptions error:nil];

    OKResponse = [[NSHTTPURLResponse alloc] initWithURL:[NSURL URLWithString:MSGraphBaseURL] statusCode:MSExpectedResponseCodesOK HTTPVersion:@"foo" headerFields:nil];
    failureResponse = [[NSHTTPURLResponse alloc] initWithURL:[NSURL URLWithString:MSGraphBaseURL] statusCode:501     HTTPVersion:@"foo" headerFields:nil];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}


- (void)testCreateUploadSessionRequest {
    NSMutableURLRequest *urlRequest = [MSGraphOneDriveLargeFileUploadTask createUploadSessionRequestWithFileName:@"testLargeFile" filePath:@"Documents"];
    XCTAssertEqualObjects(urlRequest.HTTPMethod, @"POST");
    XCTAssertTrue([[urlRequest.URL absoluteString] containsString:@"testLargeFile"]);
    XCTAssertTrue([[urlRequest.URL absoluteString] containsString:@"Documents"]);
    XCTAssertEqualObjects([urlRequest.URL absoluteString], @"https://graph.microsoft.com/v1.0/me/drive/root:/Documents/testLargeFile:/createUploadSession");

}

- (void)testCreateOneDriveLargeFileUploadTaskSuccessfull {
    MSAuthenticationHandler *partialHandler = OCMPartialMock(self.mockClient.middleware);

    OCMStub([partialHandler execute:[OCMArg any] withCompletionHandler:[OCMArg any]]).andDo(^(NSInvocation *invocation){
        HTTPRequestCompletionHandler completionHandler;
        [invocation getArgument:&completionHandler atIndex:3];
        completionHandler(self->successData, self->OKResponse, nil);
    });
    [MSGraphOneDriveLargeFileUploadTask createOneDriveLargeFileUploadTaskWithHTTPClient:self.mockClient fileData:fileData fileName:@"LargeFile" filePath:@"Documents" andChunkSize:5*1024*1024 withCompletion:^(MSGraphOneDriveLargeFileUploadTask *fileUploadTask, NSData *data, NSURLResponse *response, NSError *error) {
        XCTAssertNotNil(fileUploadTask);
        XCTAssertNil(error);
        XCTAssertNotNil(response);
        XCTAssertEqual(((NSHTTPURLResponse *)response).statusCode, MSExpectedResponseCodesOK);
        XCTAssertNotNil(data);
        XCTAssertEqualObjects([[NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil] objectForKey:@"uploadUrl"], [[NSJSONSerialization JSONObjectWithData:self->successData options:kNilOptions error:nil] objectForKey:@"uploadUrl"]);
    }];
}

- (void)testCreateOneDriveLargeFileWithNilUploadUrl {
    MSAuthenticationHandler *partialHandler = OCMPartialMock(self.mockClient.middleware);

    OCMStub([partialHandler execute:[OCMArg any] withCompletionHandler:[OCMArg any]]).andDo(^(NSInvocation *invocation){
        HTTPRequestCompletionHandler completionHandler;
        [invocation getArgument:&completionHandler atIndex:3];
        completionHandler([NSData new], self->OKResponse, nil);
    });
    [MSGraphOneDriveLargeFileUploadTask createOneDriveLargeFileUploadTaskWithHTTPClient:self.mockClient fileData:fileData fileName:@"LargeFile" filePath:@"Documents" andChunkSize:5*1024*1024 withCompletion:^(MSGraphOneDriveLargeFileUploadTask *fileUploadTask, NSData *data, NSURLResponse *response, NSError *error) {
        XCTAssertNil(fileUploadTask);
        XCTAssertNil(error);
        XCTAssertNotNil(response);
        XCTAssertEqual(((NSHTTPURLResponse *)response).statusCode, MSExpectedResponseCodesOK);
        XCTAssertNotNil(data);
        XCTAssertNil([[NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil] objectForKey:@"uploadUrl"]);
    }];
}

- (void)testCreateOneDriveLargeFileWithFailureResponse {
    MSAuthenticationHandler *partialHandler = OCMPartialMock(self.mockClient.middleware);

    OCMStub([partialHandler execute:[OCMArg any] withCompletionHandler:[OCMArg any]]).andDo(^(NSInvocation *invocation){
        HTTPRequestCompletionHandler completionHandler;
        [invocation getArgument:&completionHandler atIndex:3];
        completionHandler(nil, self->failureResponse, [NSError errorWithDomain:MSErrorDomain code:501 userInfo:nil]);
    });
    [MSGraphOneDriveLargeFileUploadTask createOneDriveLargeFileUploadTaskWithHTTPClient:self.mockClient fileData:fileData fileName:@"LargeFile" filePath:@"Documents" andChunkSize:5*1024*1024 withCompletion:^(MSGraphOneDriveLargeFileUploadTask *fileUploadTask, NSData *data, NSURLResponse *response, NSError *error) {
        XCTAssertNil(fileUploadTask);
        XCTAssertNotNil(error);
        XCTAssertNotNil(response);
        XCTAssertEqual(((NSHTTPURLResponse *)response).statusCode, 501);
        XCTAssertNil(data);
    }];
}

@end
