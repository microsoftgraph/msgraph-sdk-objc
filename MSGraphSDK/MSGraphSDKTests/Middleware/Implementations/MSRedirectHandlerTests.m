//
// Copyright (c) Microsoft Corporation. All Rights Reserved. Licensed under the MIT License. See License in the project root for license information.
//

#import <XCTest/XCTest.h>
#import "MSGraphSDKTests.h"

#define SharepointUrl @"https://microsoft.sharepoint.com"

@interface MSRedirectHandler()
@property (nonatomic, strong) id<MSGraphMiddleware> nextMiddleware;
@end

@interface MSRedirectHandlerTests : MSGraphSDKTests

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
//    id dataTask = OCMClassMock([MSURLSessionDataTask class]);
//    OCMStub([dataTask alloc]).andReturn(dataTask);
//    OCMStub([dataTask init]).andReturn(dataTask);
    _mockDataTask = [[MSURLSessionDataTask alloc] initWithRequest:self.requestForMock client:self.mockClient];

    // Put setup code here. This method is called before the invocation of each test method in the class.
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

@end
