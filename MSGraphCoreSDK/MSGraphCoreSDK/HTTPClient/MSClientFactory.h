//
//  MSClientFactory.h
// Copyright (c) Microsoft Corporation.  All Rights Reserved.  Licensed under the MIT License.  See License in the project root for license information.
//

#import <Foundation/Foundation.h>
#import "MSHTTPClient.h"
#import "MSAuthenticationProvider.h"

@interface MSClientFactory : NSObject


/*
 Initializes and returns and instance of this class to handle the HTTP calls.

 @param authenticationProvider Instance of the class which implements the methods of MSAuthenticationProvider
 @param baseUrl Base URL of all the network calls which will be made my this client.
 */


+(MSHTTPClient *)creatHTTPClientWithAuthenticationProvider:(id<MSAuthenticationProvider>)authenticationProvider;

+(MSHTTPClient *)createHTTPClientWithMiddleware:(id<MSGraphMiddleware>)middleware;


@end
