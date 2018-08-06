//
//  MSClientFactory.m
// Copyright (c) Microsoft Corporation.  All Rights Reserved.  Licensed under the MIT License.  See License in the project root for license information.
//

#import "MSClientFactory.h"
#import "MSAuthenticationMiddleware.h"
#import "MSURLSessionManager.h"

@implementation MSClientFactory

+(MSHTTPClient *)creatHTTPClientWithAuthenticationProvider:(id<MSAuthenticationProvider>)authenticationProvider{

    MSAuthenticationMiddleware *authenticationMiddleware = [MSAuthenticationMiddleware new];
    authenticationMiddleware.authProvider = authenticationProvider;
    MSURLSessionManager *sessionManager = [[MSURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    [authenticationMiddleware setNext:sessionManager];
    
    return [MSClientFactory createHTTPClientWithMiddleware:authenticationMiddleware];

}



+(MSHTTPClient *)createHTTPClientWithMiddleware:(id<MSGraphMiddlewareProtocol>)middleware{
    MSHTTPClient *httpClient = [[MSHTTPClient alloc] init];
    [httpClient setMiddleware:middleware];
    return httpClient;
}

@end

