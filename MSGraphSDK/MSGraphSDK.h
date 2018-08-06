// Copyright (c) Microsoft Corporation.  All Rights Reserved.  Licensed under the MIT License.  See License in the project root for license information.

#import <Foundation/Foundation.h>

//! Project version number for MSGraphSDK.
FOUNDATION_EXPORT double MSGraphSDKVersionNumber;

//! Project version string for MSGraphSDK.
FOUNDATION_EXPORT const unsigned char MSGraphSDKVersionString[];

// In this header, you should import all the public headers of your framework using statements like #import <MSGraphSDK/PublicHeader.h>



#ifndef MSSDK_h
#define MSSDK_h

#define GraphBaseUrl @"https://graph.microsoft.com/v1.0"

#import "MSGraphSDK/MSAuthenticationProvider.h"
#import "MSGraphSDK/MSHttpProvider.h"
#import "MSGraphSDK/MSGraphMiddlewareProtocol.h"

#import "MSGraphSDK/MSURLSessionManager.h"
#import "MSGraphSDK/MSClientFactory.h"

#endif



