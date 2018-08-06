//
//  MSAuthenticationMiddleware.h
// Copyright (c) Microsoft Corporation.  All Rights Reserved.  Licensed under the MIT License.  See License in the project root for license information.
//

#import <Foundation/Foundation.h>
#import "MSAuthenticationProvider.h"
#import "MSGraphMiddlewareProtocol.h"

@interface MSAuthenticationMiddleware : NSObject<MSGraphMiddlewareProtocol>

@property (nonatomic, strong) id<MSAuthenticationProvider> authProvider;

@end
