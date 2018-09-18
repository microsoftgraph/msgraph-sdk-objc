//
// Copyright (c) Microsoft Corporation. All Rights Reserved. Licensed under the MIT License. See License in the project root for license information.
//

#import "MSGraphCoreSDKTests.h"

@implementation MSGraphCoreSDKTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.

    self.testBaseURL = [NSURL URLWithString:@"https://foo.com/bar/baz"];
    self.requestForMock = [[NSMutableURLRequest alloc] initWithURL:self.testBaseURL];
    self.mockAuthProvider = OCMProtocolMock(@protocol(MSAuthenticationProvider));
    self.mockHttpProvider = OCMProtocolMock(@protocol(MSHttpProvider));
    self.mockClient = OCMPartialMock([MSClientFactory createHTTPClientWithAuthenticationProvider:self.mockAuthProvider]);
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    self.mockAuthProvider = nil;
    self.mockClient = nil;
    [super tearDown];
}

-(void)completionBlockCodeInvoked{
    _bCompletionBlockInvoked = YES;
}
-(void)checkCompletionBlockCodeInvoked{
    XCTAssertTrue(_bCompletionBlockInvoked);
}




@end
