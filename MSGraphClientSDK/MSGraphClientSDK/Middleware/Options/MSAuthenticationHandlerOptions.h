//
// Copyright (c) Microsoft Corporation. All Rights Reserved. Licensed under the MIT License. See License in the project root for license information.
//

#import <Foundation/Foundation.h>
#import "MSMiddlewareOptions.h"
#import "MSAuthenticationProvider.h"

/*
 This class provides options to control the behaviour of Authentication Handler.
 */

@interface MSAuthenticationHandlerOptions : NSObject <MSMiddlewareOptions>

/*
  Authentication Provider instance which will be used to authenticate the ongoing requests.
 */
@property (nonatomic, readonly) id<MSAuthenticationProvider> authenticationProvider;

/*
 This method initializes an instance of MSAuthenticationHandlerOptions with the provided parameter.
 @param authProvider The authentication provider instance which will be used to authenticate the ongoing requests.
 @return The MSAuthenticationHandlerOptions instance with the provided value.
 */
- (instancetype)initWithAuthenticationProvider:(nonnull id<MSAuthenticationProvider>)authProvider;

@end
