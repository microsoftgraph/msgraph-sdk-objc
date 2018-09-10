//
// Copyright (c) Microsoft Corporation. All Rights Reserved. Licensed under the MIT License. See License in the project root for license information.
//

#import <Foundation/Foundation.h>
#import "MSAuthenticationProvider.h"
#import "MSGraphMiddleware.h"

@interface MSAuthenticationMiddleware : NSObject<MSGraphMiddleware>

@property (nonatomic, strong) id<MSAuthenticationProvider> authProvider;

@end
