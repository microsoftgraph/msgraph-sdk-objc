//
// Copyright (c) Microsoft Corporation. All Rights Reserved. Licensed under the MIT License. See License in the project root for license information.
//

#import <XCTest/XCTest.h>
#import "MSGraphClientSDKTests.h"

#define SharepointUrl @"https://microsoft.sharepoint.com"

@interface MSRedirectHandler()
@property (nonatomic, strong) id<MSGraphMiddleware> nextMiddleware;
@property (nonatomic, strong) MSRedirectHandlerOptions *redirectHandlerOptions;
@end

@interface MSRedirectHandlerTests : MSGraphClientSDKTests<MSRedirectHandlerDelegate>

@property (nonatomic, strong) MSRedirectHandler *redirectHandler;
@property (nonatomic, strong) NSHTTPURLResponse *OKResponse;
@property (nonatomic, strong) NSHTTPURLResponse *redirectResponse;
@property (nonatomic, strong) MSURLSessionDataTask *mockDataTask;

@end

@implementation MSRedirectHandlerTests

- (void)setUp {
    [super setUp];

    self.redirectHandler = [[MSRedirectHandler alloc] init];
    [self.redirectHandler setNext:self.mockHttpProvider];
    self.OKResponse = [[NSHTTPURLResponse alloc] initWithURL:[NSURL URLWithString:MSGraphBaseURL] statusCode:MSExpectedResponseCodesOK HTTPVersion:@"foo" headerFields:nil];

    NSMutableDictionary *responseHeaderDictionary = [[NSMutableDictionary alloc] init];
    [responseHeaderDictionary setObject:SharepointUrl forKey:@"Location"];
    self.redirectResponse = [[NSHTTPURLResponse alloc] initWithURL:[NSURL URLWithString:MSGraphBaseURL] statusCode:MSExpectedResponseCodesSeeOther HTTPVersion:@"foo" headerFields:responseHeaderDictionary];
    _mockDataTask = [[MSURLSessionDataTask alloc] initWithRequest:self.requestForMock client:self.mockClient];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testInit {
    MSRedirectHandler *redirectHandler = [[MSRedirectHandler alloc] init];
    XCTAssertNotNil(redirectHandler);
    XCTAssertNotNil(redirectHandler.redirectHandlerOptions);
    XCTAssertEqual(redirectHandler.redirectHandlerOptions.maxRedirects, 5);
}

- (void)testInitWithOptions {
    NSError *error;
    MSRedirectHandlerOptions *redirectOptions = [[MSRedirectHandlerOptions alloc] initWithMaxRedirects:10 andError:&error];

    MSRedirectHandler *redirectHandler = [[MSRedirectHandler alloc] initWithOptions:redirectOptions];
    XCTAssertNotNil(redirectHandler);
    XCTAssertNotNil(redirectHandler.redirectHandlerOptions);
    XCTAssertEqual(redirectHandler.redirectHandlerOptions.maxRedirects, 10);
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
    [self.redirectHandler execute:_mockDataTask withCompletionHandler:requestCompletion];
    [self checkCompletionBlockCodeInvoked];
}

- (void)testExecuteWithRedirectResopnseAndSuccessfullRedirect {
    HTTPRequestCompletionHandler requestCompletion = ^(id data, NSURLResponse * _Nullable response, NSError * _Nullable error){
        [self completionBlockCodeInvoked];
        XCTAssertNil(error);
        XCTAssertNotNil(response);
        XCTAssertEqual(((NSHTTPURLResponse *)response).statusCode, MSExpectedResponseCodesOK);
        XCTAssertNotNil(data);
    };

    OCMStub([self.mockHttpProvider execute:[OCMArg any] withCompletionHandler:[OCMArg any]]).andDo(^(NSInvocation *invocation){
        MSURLSessionDataTask *dataTask;
        [invocation getArgument:&dataTask atIndex:2];
        HTTPRequestCompletionHandler completionHandler;
        [invocation getArgument:&completionHandler atIndex:3];
        if(dataTask && dataTask.request && [[dataTask.request.URL absoluteString] isEqualToString:SharepointUrl]){
            completionHandler([NSData new], self->_OKResponse, nil);
        }else{
            completionHandler([NSData new], self->_redirectResponse, nil);
        }
    });
    [self.redirectHandler execute:_mockDataTask withCompletionHandler:requestCompletion];
    [self checkCompletionBlockCodeInvoked];
}

- (void)testExecuteWithRedirectResopnseAndMaxRedirect {
    HTTPRequestCompletionHandler requestCompletion = ^(id data, NSURLResponse * _Nullable response, NSError * _Nullable error){
        [self completionBlockCodeInvoked];
        XCTAssertNotNil(error);
        XCTAssertEqual(error.code, MSExpectedResponseCodesSeeOther);
        XCTAssertNotNil(response);
        XCTAssertEqual(((NSHTTPURLResponse *)response).statusCode, MSExpectedResponseCodesSeeOther);
        XCTAssertNotNil(data);
    };

    OCMStub([self.mockHttpProvider execute:[OCMArg any] withCompletionHandler:[OCMArg any]]).andDo(^(NSInvocation *invocation){
        HTTPRequestCompletionHandler completionHandler;
        [invocation getArgument:&completionHandler atIndex:3];
        completionHandler([NSData new], self->_redirectResponse, nil);
    });
    [self.redirectHandler execute:_mockDataTask withCompletionHandler:requestCompletion];
    [self checkCompletionBlockCodeInvoked];
}

- (void)testExecuteWithRedirectResopnseAndLocationNotPresent {
    HTTPRequestCompletionHandler requestCompletion = ^(id data, NSURLResponse * _Nullable response, NSError * _Nullable error){
        [self completionBlockCodeInvoked];
        XCTAssertNotNil(error);
        XCTAssertEqual(error.code, MSExpectedResponseCodesTemporaryRedirect);
        XCTAssertNotNil(response);
        XCTAssertEqual(((NSHTTPURLResponse *)response).statusCode, MSExpectedResponseCodesTemporaryRedirect);
        XCTAssertNil(data);
    };

    OCMStub([self.mockHttpProvider execute:[OCMArg any] withCompletionHandler:[OCMArg any]]).andDo(^(NSInvocation *invocation){
        HTTPRequestCompletionHandler completionHandler;
        [invocation getArgument:&completionHandler atIndex:3];
        NSHTTPURLResponse *redirectResponseWithOutLocationHeader = [[NSHTTPURLResponse alloc] initWithURL:[NSURL URLWithString:MSGraphBaseURL] statusCode:MSExpectedResponseCodesTemporaryRedirect HTTPVersion:@"foo" headerFields:nil];
        completionHandler(nil, redirectResponseWithOutLocationHeader, nil);
    });
    [self.redirectHandler execute:_mockDataTask withCompletionHandler:requestCompletion];
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
    [self.redirectHandler execute:_mockDataTask withCompletionHandler:requestCompletion];
    [self checkCompletionBlockCodeInvoked];
}

- (void)testSetNext {
    id<MSGraphMiddleware> tempMiddleware = OCMProtocolMock(@protocol(MSGraphMiddleware));
    [_redirectHandler setNext:tempMiddleware];
    XCTAssertEqualObjects(tempMiddleware, _redirectHandler.nextMiddleware);
    id<MSGraphMiddleware> tempMiddleware1 = OCMProtocolMock(@protocol(MSGraphMiddleware));
    [_redirectHandler setNext:tempMiddleware1];
    XCTAssertEqualObjects(_redirectHandler.nextMiddleware, tempMiddleware1);
}

- (void)testRedirectHandlerWithDisableOption {
    HTTPRequestCompletionHandler requestCompletion = ^(id data, NSURLResponse * _Nullable response, NSError * _Nullable error){
        [self completionBlockCodeInvoked];
        XCTAssertNil(error);
        XCTAssertNotNil(response);
        XCTAssertEqual(((NSHTTPURLResponse *)response).statusCode, self->_redirectResponse.statusCode);
        XCTAssertNotNil(data);
    };

    OCMStub([self.mockHttpProvider execute:[OCMArg any] withCompletionHandler:[OCMArg any]]).andDo(^(NSInvocation *invocation){
        MSURLSessionDataTask *dataTask;
        [invocation getArgument:&dataTask atIndex:2];
        HTTPRequestCompletionHandler completionHandler;
        [invocation getArgument:&completionHandler atIndex:3];
            completionHandler([NSData new], self->_redirectResponse, nil);
    });
    NSError *error;
    MSRedirectHandlerOptions *redirectOptions = [[MSRedirectHandlerOptions alloc] initWithMaxRedirects:0 andError:&error];

    MSRedirectHandler *redirectHandler = [[MSRedirectHandler alloc] initWithOptions:redirectOptions];
    [redirectHandler setNextMiddleware:self.mockHttpProvider];
    [redirectHandler execute:_mockDataTask withCompletionHandler:requestCompletion];
    [self checkCompletionBlockCodeInvoked];
}

#pragma mark - Test Options Delegate

- (void)testRedirectDelegate {
    HTTPRequestCompletionHandler requestCompletion = ^(id data, NSURLResponse * _Nullable response, NSError * _Nullable error){
        [self completionBlockCodeInvoked];
        XCTAssertNil(error);
        XCTAssertNotNil(response);
        XCTAssertEqual(((NSHTTPURLResponse *)response).statusCode, self->_redirectResponse.statusCode);
        XCTAssertNotNil(data);
    };

    OCMStub([self.mockHttpProvider execute:[OCMArg any] withCompletionHandler:[OCMArg any]]).andDo(^(NSInvocation *invocation){
        MSURLSessionDataTask *dataTask;
        [invocation getArgument:&dataTask atIndex:2];
        HTTPRequestCompletionHandler completionHandler;
        [invocation getArgument:&completionHandler atIndex:3];
        completionHandler([NSData new], self->_redirectResponse, nil);
    });
    NSError *error;
    MSRedirectHandlerOptions *redirectOptions = [[MSRedirectHandlerOptions alloc] initWithMaxRedirects:2 andError:&error];
    redirectOptions.redirectHandlerDelegate = self;
    MSRedirectHandler *redirectHandler = [[MSRedirectHandler alloc] initWithOptions:redirectOptions];
    [redirectHandler setNextMiddleware:self.mockHttpProvider];
    [redirectHandler execute:_mockDataTask withCompletionHandler:requestCompletion];
    [self checkCompletionBlockCodeInvoked];

}

- (BOOL)task:(MSURLSessionTask *)task shouldRedirectForResponse:(NSURLResponse *)response {
    return false;
}
@end
