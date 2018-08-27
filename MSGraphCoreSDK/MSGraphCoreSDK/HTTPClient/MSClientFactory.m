//
//  MSClientFactory.m
// Copyright (c) Microsoft Corporation.  All Rights Reserved.  Licensed under the MIT License.  See License in the project root for license information.
//

#import "MSClientFactory.h"
#import "MSAuthenticationMiddleware.h"
#import "MSURLSessionManager.h"

@implementation MSClientFactory

+(MSHTTPClient *)createHTTPClientWithAuthenticationProvider:(id<MSAuthenticationProvider>)authenticationProvider{
    NSParameterAssert(authenticationProvider);
    //TODO: Put the middlware creation in a middleware facotry
    MSAuthenticationMiddleware *authenticationMiddleware = [MSAuthenticationMiddleware new];
    authenticationMiddleware.authProvider = authenticationProvider;
    MSURLSessionManager *sessionManager = [[MSURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    [authenticationMiddleware setNext:sessionManager];
    
    return [MSClientFactory createHTTPClientWithMiddleware:authenticationMiddleware];

}



+(MSHTTPClient *)createHTTPClientWithMiddleware:(id<MSGraphMiddleware>)middleware{
    NSParameterAssert(middleware);
    MSHTTPClient *httpClient = [[MSHTTPClient alloc] init];
    [httpClient setMiddleware:middleware];
    return httpClient;
}

@end

