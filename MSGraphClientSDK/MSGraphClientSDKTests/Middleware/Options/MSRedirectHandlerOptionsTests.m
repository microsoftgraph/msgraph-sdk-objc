//
// Copyright (c) Microsoft Corporation. All Rights Reserved. Licensed under the MIT License. See License in the project root for license information.
//

#import <XCTest/XCTest.h>
#import "MSGraphClientSDKTests.h"

@interface MSRedirectHandlerOptionsTests : MSGraphClientSDKTests

@end

@implementation MSRedirectHandlerOptionsTests

- (void)setUp {
    // Put setup code here. This method is called before the invocation of each test method in the class.
    [super setUp];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testInit {
    MSRedirectHandlerOptions *redirectOptions = [[MSRedirectHandlerOptions alloc] init];

    XCTAssertNotNil(redirectOptions);
    XCTAssertEqual(redirectOptions.maxRedirects, 5);
    XCTAssertEqual(redirectOptions.middlewareOptionsType, MSMiddlewareTypeRedirect);
}

- (void)testInitWithRedirects {
    NSError *error;
    MSRedirectHandlerOptions *redirectOptions = [[MSRedirectHandlerOptions alloc] initWithMaxRedirects:10 andError:&error];

    XCTAssertNil(error);
    XCTAssertNotNil(redirectOptions);
    XCTAssertEqual(redirectOptions.maxRedirects, 10);
    XCTAssertEqual(redirectOptions.middlewareOptionsType, MSMiddlewareTypeRedirect);
}

- (void)testInitWithRedirectsLimitCrossed {
    NSError *error;
    MSRedirectHandlerOptions *redirectOptions = [[MSRedirectHandlerOptions alloc] initWithMaxRedirects:21 andError:&error];

    XCTAssertNotNil(error);
    XCTAssertNil(redirectOptions);
    XCTAssertEqual(error.domain, MSErrorDomain);
    XCTAssertEqual(error.code, MSCLientErrorCodeSDKUpperLimitReached);
}

@end
