//
//  MSGraphCoreSDKTestss.m
//  MSGraphCoreSDKTests
//
//  Created by Vikas Dadheech on 23/08/18.
//  Copyright © 2018 Vikas Dadheech. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "MSGraphCoreSDK.h"
#import "OCMock.h"

@interface MSGraphCoreSDKTests : XCTestCase

@property (nonatomic,retain) id<MSAuthenticationProvider> mockAuthProvider;
@property (nonatomic,retain) id<MSHttpProvider> mockHttpProvider;
@property (nonatomic,retain) MSHTTPClient *mockClient;

@end
