//
//  MSGraphCoreSDKTests.m
// Copyright (c) Microsoft Corporation.  All Rights Reserved.  Licensed under the MIT License.  See License in the project root for license information.
//

#import "MSGraphCoreSDKTests.h"

@implementation MSGraphCoreSDKTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.

    self.mockAuthProvider = OCMProtocolMock(@protocol(MSAuthenticationProvider));
    self.mockClient = OCMPartialMock([MSClientFactory creatHTTPClientWithAuthenticationProvider:self.mockAuthProvider]);
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    self.mockAuthProvider = nil;
    self.mockClient = nil;
    [super tearDown];
}


@end
