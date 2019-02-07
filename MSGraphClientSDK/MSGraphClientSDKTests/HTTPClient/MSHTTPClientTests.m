//
// Copyright (c) Microsoft Corporation. All Rights Reserved. Licensed under the MIT License. See License in the project root for license information.
//

#import <XCTest/XCTest.h>
#import "MSGraphClientSDKTests.h"

@interface MSURLSessionTask()

- (void)taskCompletedWithData:(id)data response:(NSURLResponse *)response andError:(NSError *)error;

@end


@interface MSHTTPClientTests : MSGraphClientSDKTests
@property NSData * demoData;
@property NSURL *demoFileLocation;
@end

@implementation MSHTTPClientTests

- (void)setUp {
    [super setUp];
    self.demoData = [NSJSONSerialization dataWithJSONObject:@{@"initKey":@"initData"} options:0 error:nil];
    self.demoFileLocation = [NSURL URLWithString:@"foo/bar/baz"];

}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}


- (void)testDataTaskCreationAndExecution{

    MSDataCompletionHandler dataCompletion = ^(NSData *data, NSURLResponse *response, NSError *error){

        [self completionBlockCodeInvoked];
        XCTAssertNil(error);
        XCTAssertNotNil(response);
        XCTAssertEqual(((NSHTTPURLResponse *)response).statusCode, MSExpectedResponseCodesOK);
        XCTAssertNotNil(data);

    };

    XCTAssertThrows([self.mockClient dataTaskWithRequest:nil completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {

    }]);
    MSURLSessionDataTask *dataTask = [self.mockClient dataTaskWithRequest:self.requestForMock completionHandler:dataCompletion];
    XCTAssertNotNil(dataTask);


    MSURLSessionDataTask *partialTask = OCMPartialMock(dataTask);
    OCMStub([partialTask execute]).andDo(^(NSInvocation *invocation){
        NSHTTPURLResponse *response = [[NSHTTPURLResponse alloc] initWithURL:[NSURL URLWithString:MSGraphBaseURL] statusCode:MSExpectedResponseCodesOK HTTPVersion:@"foo" headerFields:nil];
        [dataTask taskCompletedWithData:self->_demoData response:response andError:nil];
    });
    [dataTask execute];
    [self checkCompletionBlockCodeInvoked];
}

- (void)testDownloadTaskCreationAndExecution{

    MSRawDownloadCompletionHandler downloadCompletion = ^(NSURL *fileUrl, NSURLResponse *response, NSError *error){

        [self completionBlockCodeInvoked];
        XCTAssertNil(error);
        XCTAssertNotNil(response);
        XCTAssertEqual(((NSHTTPURLResponse *)response).statusCode, MSExpectedResponseCodesOK);
        XCTAssertNotNil(fileUrl);

    };

    XCTAssertThrows([self.mockClient downloadTaskWithRequest:nil completionHandler:^(NSURL *location, NSURLResponse *response, NSError *error) {

    }]);
    MSURLSessionDownloadTask *downloadTask = [self.mockClient downloadTaskWithRequest:self.requestForMock completionHandler:downloadCompletion];
    XCTAssertNotNil(downloadTask);

    MSURLSessionDownloadTask *partialTask = OCMPartialMock(downloadTask);
    OCMStub([partialTask execute]).andDo(^(NSInvocation *invocation){
        NSHTTPURLResponse *response = [[NSHTTPURLResponse alloc] initWithURL:[NSURL URLWithString:MSGraphBaseURL] statusCode:MSExpectedResponseCodesOK HTTPVersion:@"foo" headerFields:nil];
        [downloadTask taskCompletedWithData:self->_demoFileLocation response:response andError:nil];
    });
    [downloadTask execute];
    [self checkCompletionBlockCodeInvoked];
}

- (void)testUploadTaskCreationFromDataAndExecution{
    MSRawUploadCompletionHandler uploadCompletion = ^(NSData *data, NSURLResponse *response, NSError *error){

        [self completionBlockCodeInvoked];
        XCTAssertNil(error);
        XCTAssertNotNil(response);
        XCTAssertEqual(((NSHTTPURLResponse *)response).statusCode, MSExpectedResponseCodesOK);
        XCTAssertNotNil(data);

    };

    XCTAssertThrows([self.mockClient uploadTaskWithRequest:nil fromData:_demoData completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {

    }]);
    XCTAssertThrows([self.mockClient uploadTaskWithRequest:self.requestForMock fromData:nil completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {

    }]);

    MSURLSessionUploadTask *uploadTaskFromData = [self.mockClient uploadTaskWithRequest:self.requestForMock fromData:_demoData completionHandler:uploadCompletion];

    XCTAssertNotNil(uploadTaskFromData);

    MSURLSessionUploadTask *partialTask = OCMPartialMock(uploadTaskFromData);
    OCMStub([partialTask execute]).andDo(^(NSInvocation *invocation){
        NSHTTPURLResponse *response = [[NSHTTPURLResponse alloc] initWithURL:[NSURL URLWithString:MSGraphBaseURL] statusCode:MSExpectedResponseCodesOK HTTPVersion:@"foo" headerFields:nil];
        [uploadTaskFromData taskCompletedWithData:self->_demoData response:response andError:nil];
    });
    [uploadTaskFromData execute];
    [self checkCompletionBlockCodeInvoked];
}

- (void)testUploadTaskCreationFromFileAndExecution{
    MSRawUploadCompletionHandler uploadCompletion = ^(NSData *data, NSURLResponse *response, NSError *error){

        [self completionBlockCodeInvoked];
        XCTAssertNil(error);
        XCTAssertNotNil(response);
        XCTAssertEqual(((NSHTTPURLResponse *)response).statusCode, MSExpectedResponseCodesOK);
        XCTAssertNotNil(data);

    };


    XCTAssertThrows([self.mockClient uploadTaskWithRequest:nil fromFile:_demoFileLocation completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {

    }]);
    XCTAssertThrows([self.mockClient uploadTaskWithRequest:self.requestForMock fromFile:nil completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {

    }]);

    MSURLSessionUploadTask *uploadTaskFromFile = [self.mockClient uploadTaskWithRequest:self.requestForMock fromFile:_demoFileLocation completionHandler:uploadCompletion];
    XCTAssertNotNil(uploadTaskFromFile);

    MSURLSessionUploadTask *partialTask = OCMPartialMock(uploadTaskFromFile);
    OCMStub([partialTask execute]).andDo(^(NSInvocation *invocation){
        NSHTTPURLResponse *response = [[NSHTTPURLResponse alloc] initWithURL:[NSURL URLWithString:MSGraphBaseURL] statusCode:MSExpectedResponseCodesOK HTTPVersion:@"foo" headerFields:nil];
        [uploadTaskFromFile taskCompletedWithData:self->_demoData response:response andError:nil];
    });
    [uploadTaskFromFile execute];
    [self checkCompletionBlockCodeInvoked];
}
@end
