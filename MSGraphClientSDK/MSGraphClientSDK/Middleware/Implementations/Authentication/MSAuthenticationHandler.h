//
// Copyright (c) Microsoft Corporation. All Rights Reserved. Licensed under the MIT License. See License in the project root for license information.
//

#import <Foundation/Foundation.h>
#import "MSAuthenticationProvider.h"
#import "MSGraphMiddleware.h"

@class MSAuthenticationHandlerOptions;

@interface MSAuthenticationHandler : NSObject<MSGraphMiddleware>

@property (nonatomic, strong, readonly) MSAuthenticationHandlerOptions *authHandlerOptions;

- (instancetype)initWithOptions:(MSAuthenticationHandlerOptions *)authHandlerOptions;

@end
