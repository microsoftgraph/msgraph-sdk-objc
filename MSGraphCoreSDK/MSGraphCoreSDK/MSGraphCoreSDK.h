//
// Copyright (c) Microsoft Corporation. All Rights Reserved. Licensed under the MIT License. See License in the project root for license information.
//

#import <Foundation/Foundation.h>

//! Project version number for MSGraphSDK.
FOUNDATION_EXPORT double MSGraphSDKVersionNumber;

//! Project version string for MSGraphSDK.
FOUNDATION_EXPORT const unsigned char MSGraphSDKVersionString[];

// In this header, you should import all the public headers of your framework using statements like #import <MSGraphSDK/PublicHeader.h>



#ifndef MSSDK_h
#define MSSDK_h

#import "MSGraphCoreSDK/MSAuthenticationProvider.h"
#import "MSGraphCoreSDK/MSHttpProvider.h"
#import "MSGraphCoreSDK/MSGraphMiddleware.h"

#import "MSGraphCoreSDK/MSURLSessionManager.h"
#import "MSGraphCoreSDK/MSClientFactory.h"
#import "MSGraphCoreSDK/MSMiddlewareFactory.h"
#import "MSGraphCoreSDK/MSConstants.h"
#import "MSGraphCoreSDK/MSURLSessionTaskDelegate.h"
#import "MSGraphCoreSDK/MSAuthenticationHandler.h"
#import "MSGraphCoreSDK/MSRedirectHandler.h"
#import "MSGraphCoreSDK/MSRetryHandler.h"

#import "MSGraphCoreSDK/MSURLSessionTask.h"
#import "MSGraphCoreSDK/MSURLSessionDataTask.h"
#import "MSGraphCoreSDK/MSURLSessionDownloadTask.h"
#import "MSGraphCoreSDK/MSURLSessionUploadTask.h"

#import "MSGraphCoreSDK/MSErrorCodes.h"
#import "MSGraphCoreSDK/MSBatchRequestStep.h"
#import "MSGraphCoreSDK/MSBatchRequestContent.h"
#import "MSGraphCoreSDK/MSBatchResponseContent.h"

#endif



