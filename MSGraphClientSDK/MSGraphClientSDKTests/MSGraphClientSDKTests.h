//
// Copyright (c) Microsoft Corporation. All Rights Reserved. Licensed under the MIT License. See License in the project root for license information.
//

#import <XCTest/XCTest.h>
#import "MSGraphClientSDK.h"
#import "OCMock.h"

@interface MSGraphClientSDKTests : XCTestCase

@property (nonatomic,retain) NSMutableURLRequest *requestForMock;
@property (nonatomic,retain) NSURL *testBaseURL;
@property (nonatomic,retain) id<MSAuthenticationProvider> mockAuthProvider;
@property (nonatomic,retain) id<MSHttpProvider> mockHttpProvider;
@property (nonatomic,retain) MSHTTPClient *mockClient;
@property (nonatomic) __block BOOL bCompletionBlockInvoked;

-(void)completionBlockCodeInvoked;
-(void)checkCompletionBlockCodeInvoked;

@end
