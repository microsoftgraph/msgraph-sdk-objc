//
// Copyright (c) Microsoft Corporation. All Rights Reserved. Licensed under the MIT License. See License in the project root for license information.
//

#import <Foundation/Foundation.h>
#import "MSGraphMiddleware.h"

/*
 This class provides the mechanism to handle retry response codes from Graph server. It is implmented as a middleware so it will be called during the execution of network calls.
 */

@interface MSRetryHandler : NSObject<MSGraphMiddleware>

@end
