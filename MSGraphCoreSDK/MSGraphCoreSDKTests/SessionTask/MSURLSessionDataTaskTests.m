//
//  MSURLSessionDataTask.m
// Copyright (c) Microsoft Corporation.  All Rights Reserved.  Licensed under the MIT License.  See License in the project root for license information.
//


#import <XCTest/XCTest.h>
#import "MSGraphCoreSDKTests.h"

@interface MSURLSessionTask()

-(void)taskCompletedWithData:(id)data response:(NSURLResponse *)response andError:(NSError *)error;

@end

@interface MSURLSessionDataTaskTests : MSGraphCoreSDKTests
@property (nonatomic) __block BOOL bCompletionBlockInvoked;
@end

@implementation MSURLSessionDataTaskTests

- (void)setUp {
    [super setUp];
}

- (void)tearDown {
    [super tearDown];
}
- (void)testMSURLSessionDataTaskInit{
    XCTAssertThrows([[MSURLSessionDataTask alloc] initWithRequest:nil client:self.mockClient completion:^(NSData *data, NSURLResponse *response, NSError *error) {
    }]);
    XCTAssertThrows([[MSURLSessionDataTask alloc] initWithRequest:self.requestForMock client:nil completion:^(NSData *data, NSURLResponse *response, NSError *error) {
    }]);
    MSURLSessionDataTask *dataTask = [[MSURLSessionDataTask alloc] initWithRequest:self.requestForMock client:self.mockClient completion: nil];
    XCTAssertNotNil(dataTask);
}

-(void)testDataTaskCompletion{
    MSDataCompletionHandler requestCompletion = ^(NSData *data, NSURLResponse * _Nullable response, NSError * _Nullable error){

        self->_bCompletionBlockInvoked = YES;
        XCTAssertNil(error);
        XCTAssertNotNil(response);
        XCTAssertNotNil(data);
    };

    MSURLSessionDataTask *dataTask = [[MSURLSessionDataTask alloc] initWithRequest:self.requestForMock client:self.mockClient completion:requestCompletion];
    id<MSGraphMiddleware> middleware = OCMPartialMock(dataTask.client.middleware);
    OCMStub([middleware execute:[OCMArg any] withCompletionHandler:[OCMArg any]]).andDo(^(NSInvocation *invocation){

        NSHTTPURLResponse *response = [[NSHTTPURLResponse alloc] initWithURL:[NSURL URLWithString:MSGraphBaseURL] statusCode:MSExpectedResponseCodesOK HTTPVersion:@"foo" headerFields:nil];
        [dataTask taskCompletedWithData:[NSData new] response:response andError:nil];
    });

    [dataTask execute];
    XCTAssertTrue(_bCompletionBlockInvoked);

}


@end
