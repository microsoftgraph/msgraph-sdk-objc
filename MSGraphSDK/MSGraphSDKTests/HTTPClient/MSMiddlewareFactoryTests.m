//
// Copyright (c) Microsoft Corporation. All Rights Reserved. Licensed under the MIT License. See License in the project root for license information.
//

#import <XCTest/XCTest.h>
#import "MSGraphSDKTests.h"
#import "MSMiddlewareFactory.h"

@interface MSMiddlewareFactoryTests : MSGraphSDKTests

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
    id<MSGraphMiddleware>authHandler = [MSMiddlewareFactory createMiddleware:MSMiddlewareTypeAuthentication];
    id<MSGraphMiddleware>httpMiddleware = [MSMiddlewareFactory createMiddleware:MSMiddlewareTypeHTTP];
    id<MSGraphMiddleware>randomMiddleware = [MSMiddlewareFactory createMiddleware:4];
    XCTAssertTrue([authHandler isKindOfClass:[MSAuthenticationHandler class]]);
    XCTAssertTrue([httpMiddleware isKindOfClass:[MSURLSessionManager class]]);
    XCTAssertNil(randomMiddleware);
}


@end
