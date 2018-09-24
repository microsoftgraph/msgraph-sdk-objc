//
// Copyright (c) Microsoft Corporation. All Rights Reserved. Licensed under the MIT License. See License in the project root for license information.
//


#import <XCTest/XCTest.h>
#import "MSGraphCoreSDKTests.h"

@interface MSAuthenticationHandler()
@property (nonatomic, strong) id<MSGraphMiddleware> nextMiddleware;
@end

#define TestToken @"a1b2c3d4"

@interface MSAuthenticationHandlerTests : MSGraphCoreSDKTests

@property (nonatomic, strong) MSAuthenticationHandler *authenticationHandler;
@property (nonatomic, strong) MSURLSessionDataTask *mockDataTask;

@end

@implementation MSAuthenticationHandlerTests

- (void)setUp {
    [super setUp];
    self.authenticationHandler = [[MSAuthenticationHandler alloc] init];
    self.authenticationHandler.authProvider = self.mockAuthProvider;
    [self.authenticationHandler setNextMiddleware:self.mockHttpProvider];

    _mockDataTask = [[MSURLSessionDataTask alloc] initWithRequest:self.requestForMock client:self.mockClient];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExecuteWithSuccessInGettingToken {
    HTTPRequestCompletionHandler requestCompletion = ^(id data, NSURLResponse * _Nullable response, NSError * _Nullable error){
        [self completionBlockCodeInvoked];
        XCTAssertNil(error);
        XCTAssertNotNil(response);
        XCTAssertEqual(((NSHTTPURLResponse *)response).statusCode, MSExpectedResponseCodesOK);
        XCTAssertNotNil(data);
    };
    //Mocking auth to provide a test token
    OCMStub([self.mockAuthProvider getAccessTokenWithCompletion:[OCMArg any]])
    .andDo(^(NSInvocation *invocation){
        void (^completionHandler)(NSString *accessToken, NSError *error);
        [invocation getArgument:&completionHandler atIndex:2];
        completionHandler(TestToken,nil);
    });

    OCMStub([self.mockHttpProvider execute:[OCMArg any] withCompletionHandler:[OCMArg any]]).andDo((^(NSInvocation *invocation){
        MSURLSessionDataTask *dataTask;
        [invocation getArgument:&dataTask atIndex:2];
        NSString *authrizationValue = [NSString stringWithFormat:@"Bearer %@",TestToken];
        XCTAssertEqualObjects([dataTask.request valueForHTTPHeaderField:@"Authorization"], authrizationValue);

        HTTPRequestCompletionHandler completionHandler;
        [invocation getArgument:&completionHandler atIndex:3];
        NSHTTPURLResponse *OKResponse = [[NSHTTPURLResponse alloc] initWithURL:[NSURL URLWithString:MSGraphBaseURL] statusCode:MSExpectedResponseCodesOK HTTPVersion:@"foo" headerFields:nil];
        completionHandler([NSData new],OKResponse,nil);
    }));
    [self.authenticationHandler execute:_mockDataTask withCompletionHandler:requestCompletion];
    [self checkCompletionBlockCodeInvoked];
}

- (void)testExecuteWithErrorInGettingToken {
    HTTPRequestCompletionHandler requestCompletion = ^(id data, NSURLResponse * _Nullable response, NSError * _Nullable error){
        [self completionBlockCodeInvoked];
        XCTAssertNotNil(error);
        XCTAssertNil(response);
        XCTAssertEqual(error.code, 0);
        XCTAssertEqualObjects(error.domain, @"TestDomain");
        XCTAssertNil(data);
    };
    //Mocking auth to provide an error
    OCMStub([self.mockAuthProvider getAccessTokenWithCompletion:[OCMArg any]])
    .andDo(^(NSInvocation *invocation){
        void (^completionHandler)(NSString *accessToken, NSError *error);
        [invocation getArgument:&completionHandler atIndex:2];
        completionHandler(nil,[NSError errorWithDomain:@"TestDomain" code:0 userInfo:nil]);
    });

    [self.authenticationHandler execute:_mockDataTask withCompletionHandler:requestCompletion];
    [self checkCompletionBlockCodeInvoked];
}


- (void)testSetNext {
    id<MSGraphMiddleware> tempMiddleware = OCMProtocolMock(@protocol(MSGraphMiddleware));
    [self.authenticationHandler setNext:tempMiddleware];
    XCTAssertEqualObjects(tempMiddleware, self.authenticationHandler.nextMiddleware);
    id<MSGraphMiddleware> tempMiddleware1 = OCMProtocolMock(@protocol(MSGraphMiddleware));
    [self.authenticationHandler setNext:tempMiddleware1];
    XCTAssertEqualObjects(self.authenticationHandler.nextMiddleware, tempMiddleware1);
}

@end
