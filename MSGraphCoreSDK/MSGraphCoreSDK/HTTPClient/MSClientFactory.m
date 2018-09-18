//
// Copyright (c) Microsoft Corporation. All Rights Reserved. Licensed under the MIT License. See License in the project root for license information.
//

#import "MSClientFactory.h"
#import "MSAuthenticationHandler.h"
#import "MSURLSessionManager.h"
#import "MSMiddlewareFactory.h"
#import "MSRedirectHandler.h"

@implementation MSClientFactory

+(MSHTTPClient *)createHTTPClientWithAuthenticationProvider:(id<MSAuthenticationProvider>)authenticationProvider
{
    NSParameterAssert(authenticationProvider);

    //Creating a default chain of middlewares starting from Authentication

    //Initializing different default middlewares
    MSAuthenticationHandler *authenticationHandler = (MSAuthenticationHandler *)[MSMiddlewareFactory createMiddleware:MSMiddlewareTypeAuthentication];
    authenticationHandler.authProvider = authenticationProvider;
    MSRedirectHandler *redirectHandler = (MSRedirectHandler *)[MSMiddlewareFactory createMiddleware:MSMiddlewareTypeRedirect];
    MSURLSessionManager *sessionManager = (MSURLSessionManager *)[MSMiddlewareFactory createMiddleware:MSMiddlewareTypeHTTP];
    //Creating a default chain
    [authenticationHandler setNext:redirectHandler];
    [redirectHandler setNext:sessionManager];

    return [MSClientFactory createHTTPClientWithMiddleware:authenticationHandler];
}

+(MSHTTPClient *)createHTTPClientWithMiddleware:(id<MSGraphMiddleware>)middleware
{
    NSParameterAssert(middleware);
    
    MSHTTPClient *httpClient = [[MSHTTPClient alloc] init];
    [httpClient setMiddleware:middleware];
    return httpClient;
}

@end

