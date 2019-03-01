//
// Copyright (c) Microsoft Corporation. All Rights Reserved. Licensed under the MIT License. See License in the project root for license information.
///

#import <XCTest/XCTest.h>
#import "MSGraphClientSDKTests.h"

@interface MSRetryHandlerOptionsTests : MSGraphClientSDKTests

@end

@implementation MSRetryHandlerOptionsTests

- (void)setUp {
    // Put setup code here. This method is called before the invocation of each test method in the class.
    [super setUp];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testInit {
    MSRetryHandlerOptions *retryOptions = [[MSRetryHandlerOptions alloc] init];

    XCTAssertNotNil(retryOptions);
    XCTAssertEqual(retryOptions.delay, 3);
    XCTAssertEqual(retryOptions.maxRetries, 3);
    XCTAssertEqual(retryOptions.middlewareOptionsType, MSMiddlewareTypeRetry);
}

- (void)testInitWithDelayAndRetries {
    NSError *error;
    MSRetryHandlerOptions *retryOptions = [[MSRetryHandlerOptions alloc] initWithDelay:5 maxRetries:5 andError:&error];

    XCTAssertNil(error);
    XCTAssertNotNil(retryOptions);
    XCTAssertEqual(retryOptions.delay, 5);
    XCTAssertEqual(retryOptions.maxRetries, 5);
    XCTAssertEqual(retryOptions.middlewareOptionsType, MSMiddlewareTypeRetry);
}

- (void)testInitWithDelayLimitCrossed {
    NSError *error;
    MSRetryHandlerOptions *retryOptions = [[MSRetryHandlerOptions alloc] initWithDelay:200 maxRetries:5 andError:&error];

    XCTAssertNotNil(error);
    XCTAssertNil(retryOptions);
    XCTAssertEqual(error.domain, MSErrorDomain);
    XCTAssertEqual(error.code, MSCLientErrorCodeSDKUpperLimitReached);
}

- (void)testInitWithRetryLimitCrossed {
    NSError *error;
    MSRetryHandlerOptions *retryOptions = [[MSRetryHandlerOptions alloc] initWithDelay:5 maxRetries:12 andError:&error];

    XCTAssertNotNil(error);
    XCTAssertNil(retryOptions);
    XCTAssertEqual(error.domain, MSErrorDomain);
    XCTAssertEqual(error.code, MSCLientErrorCodeSDKUpperLimitReached);
}


@end
