//
//  MSAuthenticationHandlerOptionsTests.m
//  MSGraphClientSDKTests
//
//  Created by Vikas Dadheech on 26/04/19.
//  Copyright © 2019 Vikas Dadheech. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "MSGraphClientSDKTests.h"

@interface MSAuthenticationHandlerOptionsTests : MSGraphClientSDKTests

@end

@implementation MSAuthenticationHandlerOptionsTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testInitWithNilAuthProvider {
    XCTAssertThrows([[MSAuthenticationHandlerOptions alloc] initWithAuthenticationProvider:nil]);
}

- (void)testSuccfullInit {
    MSAuthenticationHandlerOptions *authHandlerOptions = [[MSAuthenticationHandlerOptions alloc] initWithAuthenticationProvider:self.mockAuthProvider];

    XCTAssertEqual(authHandlerOptions.authenticationProvider, self.mockAuthProvider);
    XCTAssertEqual(authHandlerOptions.middlewareOptionsType, MSMiddlewareOptionsTypeAuth);
}

@end
