//
// Copyright (c) Microsoft Corporation. All Rights Reserved. Licensed under the MIT License. See License in the project root for license information.
//

#import <XCTest/XCTest.h>
#import "MSGraphClientSDKTests.h"
#import "MSMiddlewareFactory.h"

@interface MSMiddlewareFactoryTests : MSGraphClientSDKTests

@end

@implementation MSMiddlewareFactoryTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testCreateMiddlewareMethod {
    id<MSGraphMiddleware>authHandler = [MSMiddlewareFactory createMiddleware:MSMiddlewareTypeAuthentication withOptions:nil];
    id<MSGraphMiddleware>httpMiddleware = [MSMiddlewareFactory createMiddleware:MSMiddlewareTypeHTTP withOptions:nil];
    id<MSGraphMiddleware>retryMiddleware = [MSMiddlewareFactory createMiddleware:MSMiddlewareTypeRetry withOptions:nil];
    id<MSGraphMiddleware>redirectMiddleware = [MSMiddlewareFactory createMiddleware:MSMiddlewareTypeRedirect withOptions:nil];
    id<MSGraphMiddleware>randomMiddleware = [MSMiddlewareFactory createMiddleware:4 withOptions:nil];
    XCTAssertTrue([authHandler isKindOfClass:[MSAuthenticationHandler class]]);
    XCTAssertTrue([httpMiddleware isKindOfClass:[MSURLSessionManager class]]);
    XCTAssertTrue([retryMiddleware isKindOfClass:[MSRetryHandler class]]);
    XCTAssertTrue([redirectMiddleware isKindOfClass:[MSRedirectHandler class]]);
    XCTAssertNil(randomMiddleware);
}


@end
