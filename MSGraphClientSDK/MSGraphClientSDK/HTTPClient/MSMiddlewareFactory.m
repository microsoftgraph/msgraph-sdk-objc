//
// Copyright (c) Microsoft Corporation. All Rights Reserved. Licensed under the MIT License. See License in the project root for license information.
//

#import "MSMiddlewareFactory.h"
#import "MSURLSessionManager.h"
#import "MSAuthenticationHandler.h"
#import "MSRedirectHandler.h"
#import "MSRetryHandler.h"

@implementation MSMiddlewareFactory

+(id<MSGraphMiddleware>)createMiddleware:(MSMiddlewareType)middlewareType withOptions:(id<MSMiddlewareOptions>)middlewareOptions
{
    switch (middlewareType)
    {
        case MSMiddlewareTypeHTTP:
        {
             MSURLSessionManager *sessionManager = [[MSURLSessionManager alloc] init];
            return sessionManager;
        }
        case MSMiddlewareTypeRedirect:
        {
            MSRedirectHandler *redirectHandler;
            if(middlewareOptions)
            {
                redirectHandler = [[MSRedirectHandler alloc] initWithOptions:(MSRedirectHandlerOptions *)middlewareOptions];
            }else{
                redirectHandler = [[MSRedirectHandler alloc] init];
            }
            return redirectHandler;
        }
        case MSMiddlewareTypeRetry:
        {
            MSRetryHandler *retryHandler;
            if(middlewareOptions)
            {
                retryHandler = [[MSRetryHandler alloc] initWithOptions:(MSRetryHandlerOptions *)middlewareOptions];
            }else{
                retryHandler = [[MSRetryHandler alloc] init];
            }
            return retryHandler;
        }
        case MSMiddlewareTypeAuthentication:
        {
            MSAuthenticationHandler *authenticationHandler;
            if(middlewareOptions)
            {
                authenticationHandler = [[MSAuthenticationHandler alloc] initWithOptions:(MSAuthenticationHandlerOptions *)middlewareOptions];
            }else{
                authenticationHandler = [[MSAuthenticationHandler alloc] init];
            }
            return authenticationHandler;
        }
        default:
            break;
    }
    return nil;
}
@end
