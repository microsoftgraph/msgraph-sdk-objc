//
// Copyright (c) Microsoft Corporation. All Rights Reserved. Licensed under the MIT License. See License in the project root for license information.
//

#import <XCTest/XCTest.h>
#import "MSGraphSDKTests.h"

NSString *const retryAfterValue = @"10";

@interface MSRetryHandler()
@property (nonatomic, strong) id<MSGraphMiddleware> nextMiddleware;
- (BOOL)isBuffered:(NSURLRequest *)request forResponse:(NSHTTPURLResponse *)response;
@end

@interface MSRetryHandlerTests : MSGraphSDKTests

@property (nonatomic, strong) MSRetryHandler *retryHandler;
@property (nonatomic, strong) NSHTTPURLResponse *OKResponse;
@property (nonatomic, strong) NSHTTPURLResponse *retryResponse;
@property (nonatomic, strong) MSURLSessionDataTask *mockDataTask;

@end

@implementation MSRetryHandlerTests

- (void)setUp {
    // Put setup code here. This method is called before the invocation of each test method in the class.
    [super setUp];

    self.retryHandler = [[MSRetryHandler alloc] init];
    [self.retryHandler setNext:self.mockHttpProvider];
    self.OKResponse = [[NSHTTPURLResponse alloc] initWithURL:[NSURL URLWithString:MSGraphBaseURL] statusCode:MSExpectedResponseCodesOK HTTPVersion:@"foo" headerFields:nil];

    NSMutableDictionary *responseHeaderDictionary = [[NSMutableDictionary alloc] init];
    [responseHeaderDictionary setObject:@"chunked" forKey:@"Transfer-Encoding"];
    self.retryResponse = [[NSHTTPURLResponse alloc] initWithURL:[NSURL URLWithString:MSGraphBaseURL] statusCode:MSClientErrorCodeTooManyRequests HTTPVersion:@"foo" headerFields:responseHeaderDictionary];
    _mockDataTask = [[MSURLSessionDataTask alloc] initWithRequest:self.requestForMock client:self.mockClient];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExecute {
    HTTPRequestCompletionHandler requestCompletion = ^(id data, NSURLResponse * _Nullable response, NSError * _Nullable error){
        [self completionBlockCodeInvoked];
        XCTAssertNil(error);
        XCTAssertNotNil(response);
        XCTAssertEqual(((NSHTTPURLResponse *)response).statusCode, MSExpectedResponseCodesOK);
        XCTAssertNotNil(data);
    };

    OCMStub([self.mockHttpProvider execute:[OCMArg any] withCompletionHandler:[OCMArg any]]).andDo(^(NSInvocation *invocation){
        HTTPRequestCompletionHandler completionHandler;
        [invocation getArgument:&completionHandler atIndex:3];
        completionHandler([NSData new],self->_OKResponse,nil);
    });
    [self.retryHandler execute:_mockDataTask withCompletionHandler:requestCompletion];
    [self checkCompletionBlockCodeInvoked];
}

- (void)testExecuteWithRetryResopnseAndSuccessfullRetry {
    XCTestExpectation *retryWaitExpectation = [[XCTestExpectation alloc] initWithDescription:@"Waiting for retry attempt execution"];

    HTTPRequestCompletionHandler requestCompletion = ^(id data, NSURLResponse * _Nullable response, NSError * _Nullable error){
        [self completionBlockCodeInvoked];
        XCTAssertNil(error);
        XCTAssertNotNil(response);
        XCTAssertEqual(((NSHTTPURLResponse *)response).statusCode, MSExpectedResponseCodesOK);
        XCTAssertNotNil(data);
        [retryWaitExpectation fulfill];
    };

    OCMStub([self.mockHttpProvider execute:[OCMArg any] withCompletionHandler:[OCMArg any]]).andDo(^(NSInvocation *invocation){
        MSURLSessionDataTask *dataTask;
        [invocation getArgument:&dataTask atIndex:2];
        HTTPRequestCompletionHandler completionHandler;
        [invocation getArgument:&completionHandler atIndex:3];
        completionHandler([NSData new], self->_retryResponse, nil);
        self->_retryResponse = self->_OKResponse;
    });
    [self.retryHandler execute:_mockDataTask withCompletionHandler:requestCompletion];
    [self waitForExpectations:@[retryWaitExpectation] timeout:12.0];
    [self checkCompletionBlockCodeInvoked];
}

- (void)testExecuteWithRedirectResopnseAndMaxRetries {
    XCTestExpectation *retryWaitExpectation = [[XCTestExpectation alloc] initWithDescription:@"Waiting for retry attempt execution"];

    NSMutableDictionary *responseHeaderDictionary = [[NSMutableDictionary alloc] init];
    [responseHeaderDictionary setObject:@"2" forKey:@"Retry-After"];
    NSHTTPURLResponse *retryResponseWithLowRetryTime = [[NSHTTPURLResponse alloc] initWithURL:[NSURL URLWithString:MSGraphBaseURL] statusCode:MSClientErrorCodeTooManyRequests HTTPVersion:@"foo" headerFields:responseHeaderDictionary];
    HTTPRequestCompletionHandler requestCompletion = ^(id data, NSURLResponse * _Nullable response, NSError * _Nullable error){
        [self completionBlockCodeInvoked];
        XCTAssertNotNil(error);
        XCTAssertEqual(error.code, MSClientErrorCodeTooManyRequests);
        XCTAssertNotNil(response);
        XCTAssertEqual(((NSHTTPURLResponse *)response).statusCode, MSClientErrorCodeTooManyRequests);
        XCTAssertNotNil(data);
        [retryWaitExpectation fulfill];
    };

    OCMStub([self.mockHttpProvider execute:[OCMArg any] withCompletionHandler:[OCMArg any]]).andDo(^(NSInvocation *invocation){
        HTTPRequestCompletionHandler completionHandler;
        [invocation getArgument:&completionHandler atIndex:3];
        completionHandler([NSData new], retryResponseWithLowRetryTime, nil);
    });
    [self.retryHandler execute:_mockDataTask withCompletionHandler:requestCompletion];
    [self waitForExpectations:@[retryWaitExpectation] timeout:21.0];
    [self checkCompletionBlockCodeInvoked];
}

- (void)testExecuteWithRetryResopnse503AndSuccessfullRetry {
    XCTestExpectation *retryWaitExpectation = [[XCTestExpectation alloc] initWithDescription:@"Waiting for retry attempt execution"];

    HTTPRequestCompletionHandler requestCompletion = ^(id data, NSURLResponse * _Nullable response, NSError * _Nullable error){
        [self completionBlockCodeInvoked];
        XCTAssertNil(error);
        XCTAssertNotNil(response);
        XCTAssertEqual(((NSHTTPURLResponse *)response).statusCode, MSExpectedResponseCodesOK);
        XCTAssertNotNil(data);
        [retryWaitExpectation fulfill];
    };

   __block NSHTTPURLResponse *retryResponseWith503 = [[NSHTTPURLResponse alloc] initWithURL:[NSURL URLWithString:MSGraphBaseURL] statusCode:MSClientErrorCodeServiceUnavailable HTTPVersion:@"foo" headerFields:nil];
    OCMStub([self.mockHttpProvider execute:[OCMArg any] withCompletionHandler:[OCMArg any]]).andDo(^(NSInvocation *invocation){
        HTTPRequestCompletionHandler completionHandler;
        [invocation getArgument:&completionHandler atIndex:3];
        completionHandler([NSData new], retryResponseWith503, nil);
        retryResponseWith503 = self->_OKResponse;
    });
    [self.retryHandler execute:_mockDataTask withCompletionHandler:requestCompletion];
    [self waitForExpectations:@[retryWaitExpectation] timeout:12.0];
    [self checkCompletionBlockCodeInvoked];
}

- (void)testExecuteWithRetryResopnse504AndSuccessfullRetry {
    XCTestExpectation *retryWaitExpectation = [[XCTestExpectation alloc] initWithDescription:@"Waiting for retry attempt execution"];

    HTTPRequestCompletionHandler requestCompletion = ^(id data, NSURLResponse * _Nullable response, NSError * _Nullable error){
        [self completionBlockCodeInvoked];
        XCTAssertNil(error);
        XCTAssertNotNil(response);
        XCTAssertEqual(((NSHTTPURLResponse *)response).statusCode, MSExpectedResponseCodesOK);
        XCTAssertNotNil(data);
        [retryWaitExpectation fulfill];
    };

    __block NSHTTPURLResponse *retryResponseWith504 = [[NSHTTPURLResponse alloc] initWithURL:[NSURL URLWithString:MSGraphBaseURL] statusCode:MSClientErrorCodeGatewayTimeout HTTPVersion:@"foo" headerFields:nil];
    OCMStub([self.mockHttpProvider execute:[OCMArg any] withCompletionHandler:[OCMArg any]]).andDo(^(NSInvocation *invocation){
        HTTPRequestCompletionHandler completionHandler;
        [invocation getArgument:&completionHandler atIndex:3];
        completionHandler([NSData new], retryResponseWith504, nil);
        retryResponseWith504 = self->_OKResponse;
    });
    [self.retryHandler execute:_mockDataTask withCompletionHandler:requestCompletion];
    [self waitForExpectations:@[retryWaitExpectation] timeout:12.0];
    [self checkCompletionBlockCodeInvoked];
}

- (void)testExecuteWithNormalResponse {
    HTTPRequestCompletionHandler requestCompletion = ^(id data, NSURLResponse * _Nullable response, NSError * _Nullable error){
        [self completionBlockCodeInvoked];
        XCTAssertNil(error);
        XCTAssertNotNil(response);
        XCTAssertNil(data);
    };

    OCMStub([self.mockHttpProvider execute:[OCMArg any] withCompletionHandler:[OCMArg any]]).andDo(^(NSInvocation *invocation){
        HTTPRequestCompletionHandler completionHandler;
        [invocation getArgument:&completionHandler atIndex:3];
        NSURLResponse *urlRespone = [[NSURLResponse alloc] init];
        completionHandler(nil, urlRespone, nil);
    });
    [self.retryHandler execute:_mockDataTask withCompletionHandler:requestCompletion];
    [self checkCompletionBlockCodeInvoked];
}

- (void)testIsBuffered {
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:MSGraphBaseURL]];
    [urlRequest setHTTPBody:[NSData new]];
    [urlRequest setHTTPMethod:HTTPMethodPost];
    XCTAssertFalse([self.retryHandler isBuffered:urlRequest forResponse:self.retryResponse]);
    
}

- (void)testSetNext {
    id<MSGraphMiddleware> tempMiddleware = OCMProtocolMock(@protocol(MSGraphMiddleware));
    [self.retryHandler setNext:tempMiddleware];
    XCTAssertEqualObjects(tempMiddleware, self.retryHandler.nextMiddleware);
    id<MSGraphMiddleware> tempMiddleware1 = OCMProtocolMock(@protocol(MSGraphMiddleware));
    [self.retryHandler setNext:tempMiddleware1];
    XCTAssertEqualObjects(self.retryHandler.nextMiddleware, tempMiddleware1);
}

@end
