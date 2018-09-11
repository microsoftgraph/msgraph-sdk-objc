//
// Copyright (c) Microsoft Corporation. All Rights Reserved. Licensed under the MIT License. See License in the project root for license information.
//

#import "MSClientFactory.h"
#import "MSAuthenticationMiddleware.h"
#import "MSURLSessionManager.h"
#import "MSMiddlewareFactory.h"
#import "MSRedirectHandler.h"

@implementation MSClientFactory

+(MSHTTPClient *)createHTTPClientWithAuthenticationProvider:(id<MSAuthenticationProvider>)authenticationProvider
{
    NSParameterAssert(authenticationProvider);

    //Creating a default chain of middlewares starting from Authentication

    //Initializing different default middlewares
    MSAuthenticationMiddleware *authenticationMiddleware = (MSAuthenticationMiddleware *)[MSMiddlewareFactory createMiddleware:MSMiddlewareTypeAuthentication];
    authenticationMiddleware.authProvider = authenticationProvider;
    MSRedirectHandler *redirectHandler = (MSRedirectHandler *)[MSMiddlewareFactory createMiddleware:MSMiddlewareTypeRedirect];
    MSURLSessionManager *sessionManager = (MSURLSessionManager *)[MSMiddlewareFactory createMiddleware:MSMiddlewareTypeHTTP];
    //Creating a default chain
    [authenticationMiddleware setNext:redirectHandler];
    [redirectHandler setNext:sessionManager];

    return [MSClientFactory createHTTPClientWithMiddleware:authenticationMiddleware];
}

+(MSHTTPClient *)createHTTPClientWithMiddleware:(id<MSGraphMiddleware>)middleware
{
    NSParameterAssert(middleware);
    
    MSHTTPClient *httpClient = [[MSHTTPClient alloc] init];
    [httpClient setMiddleware:middleware];
    return httpClient;
}

@end

