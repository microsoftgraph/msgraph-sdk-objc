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

#import "MSGraphSDK/MSAuthenticationProvider.h"
#import "MSGraphSDK/MSHttpProvider.h"
#import "MSGraphSDK/MSGraphMiddleware.h"

#import "MSGraphSDK/MSURLSessionManager.h"
#import "MSGraphSDK/MSClientFactory.h"
#import "MSGraphSDK/MSMiddlewareFactory.h"
#import "MSGraphSDK/MSConstants.h"
#import "MSGraphSDK/MSURLSessionTaskDelegate.h"
#import "MSGraphSDK/MSAuthenticationHandler.h"
#import "MSGraphSDK/MSRedirectHandler.h"
#import "MSGraphSDK/MSRetryHandler.h"

#import "MSGraphSDK/MSURLSessionTask.h"
#import "MSGraphSDK/MSURLSessionDataTask.h"
#import "MSGraphSDK/MSURLSessionDownloadTask.h"
#import "MSGraphSDK/MSURLSessionUploadTask.h"

#import "MSGraphSDK/MSErrorCodes.h"
#import "MSGraphSDK/MSBatchRequestStep.h"
#import "MSGraphSDK/MSBatchRequestContent.h"
#import "MSGraphSDK/MSBatchResponseContent.h"


#endif



