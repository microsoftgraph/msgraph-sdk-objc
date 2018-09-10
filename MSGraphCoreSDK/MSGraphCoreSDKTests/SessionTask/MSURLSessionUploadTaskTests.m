//
// Copyright (c) Microsoft Corporation. All Rights Reserved. Licensed under the MIT License. See License in the project root for license information.
//

#import <XCTest/XCTest.h>
#import "MSGraphCoreSDKTests.h"

@interface MSURLSessionUploadTask()

- (NSProgress *)createProgress;
- (void)taskCompletedWithData:(id)data response:(NSURLResponse *)response andError:(NSError *)error;

@end

@interface MSURLSessionUploadTaskTests : MSGraphCoreSDKTests
@property NSData * demoData;
@property NSURL *demoFileLocation;


@end

@implementation MSURLSessionUploadTaskTests

- (void)setUp {
    [super setUp];
    self.demoData = [NSJSONSerialization dataWithJSONObject:@{@"initKey":@"initData"} options:0 error:nil];
    self.demoFileLocation = [NSURL URLWithString:@"foo/bar/baz"];
}

- (void)tearDown {
    [super tearDown];
}
/**
 ** Test  [MSURLSessionUploadTask init]
 **
 */
- (void)testMSURLSessionUploadTaskInit{
    
    XCTAssertThrows([[MSURLSessionUploadTask alloc] initWithRequest:nil data:_demoData client:self.mockClient completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
    }]);
    XCTAssertThrows([[MSURLSessionUploadTask alloc] initWithRequest:self.requestForMock data:nil client:self.mockClient completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
    }]);
    XCTAssertThrows([[MSURLSessionUploadTask alloc] initWithRequest:self.requestForMock data:_demoData client:nil completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
    }]);
    

    XCTAssertThrows([[MSURLSessionUploadTask alloc] initWithRequest:nil fromFile:_demoFileLocation client:self.mockClient completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
    }]);
    XCTAssertThrows([[MSURLSessionUploadTask alloc] initWithRequest:self.requestForMock fromFile:nil client:self.mockClient completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
    }]);
    XCTAssertThrows([[MSURLSessionUploadTask alloc] initWithRequest:self.requestForMock fromFile:_demoFileLocation client:nil completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
    }]);
    
    
    MSURLSessionUploadTask *uploadTaskFromData  = [[MSURLSessionUploadTask alloc] initWithRequest:self.requestForMock data:_demoData client:self.mockClient completionHandler:nil];
    MSURLSessionUploadTask *uploadTaskFromFile  = [[MSURLSessionUploadTask alloc] initWithRequest:self.requestForMock fromFile:_demoFileLocation client:self.mockClient completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
    }];
    XCTAssertNotNil(uploadTaskFromData);
    XCTAssertNotNil(uploadTaskFromFile);
}

- (void)testCreateProgress{
    MSURLSessionUploadTask *uploadTask = [[MSURLSessionUploadTask alloc] initWithRequest:self.requestForMock data:_demoData client:self.mockClient completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
    }  ];
    NSProgress *progress = [uploadTask createProgress];

    XCTAssertEqual(progress, uploadTask.progress);

}

- (void)testUploadTaskCompletion{
    MSUploadCompletionHandler requestCompletion = ^(NSData *data, NSURLResponse * _Nullable response, NSError * _Nullable error){

        [self completionBlockCodeInvoked];
        XCTAssertNil(error);
        XCTAssertNotNil(response);
        XCTAssertNotNil(data);
    };

    MSURLSessionUploadTask *uploadTask = [[MSURLSessionUploadTask alloc] initWithRequest:self.requestForMock data:_demoData client:self.mockClient completionHandler:requestCompletion];
    id<MSGraphMiddleware> middleware = OCMPartialMock(uploadTask.client.middleware);
    OCMStub([middleware execute:[OCMArg any] withCompletionHandler:[OCMArg any]]).andDo(^(NSInvocation *invocation){

        NSHTTPURLResponse *response = [[NSHTTPURLResponse alloc] initWithURL:[NSURL URLWithString:MSGraphBaseURL] statusCode:MSExpectedResponseCodesOK HTTPVersion:@"foo" headerFields:nil];
        [uploadTask taskCompletedWithData:[NSData new] response:response andError:nil];
    });

    [uploadTask execute];
    [self checkCompletionBlockCodeInvoked];

}


@end
