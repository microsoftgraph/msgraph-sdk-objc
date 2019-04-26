//
// Copyright (c) Microsoft Corporation. All Rights Reserved. Licensed under the MIT License. See License in the project root for license information.
//


#import "MSAuthenticationHandlerOptions.h"

@implementation MSAuthenticationHandlerOptions

@synthesize middlewareOptionsType;

- (instancetype)initWithAuthenticationProvider:(id<MSAuthenticationProvider>)authProvider
{
    self = [super init];
    if(self)
    {
        NSAssert(authProvider, @"Authentication Provider is requried to authenticate the requests.");
        _authenticationProvider = authProvider;
        middlewareOptionsType = MSMiddlewareOptionsTypeAuth;
    }
    return self;
}


@end
