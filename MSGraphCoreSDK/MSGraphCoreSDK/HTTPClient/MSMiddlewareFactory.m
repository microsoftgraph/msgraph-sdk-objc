//
// Copyright (c) Microsoft Corporation. All Rights Reserved. Licensed under the MIT License. See License in the project root for license information.
//

#import "MSMiddlewareFactory.h"
#import "MSURLSessionManager.h"
#import "MSAuthenticationMiddleware.h"
#import "MSRedirectHandler.h"

@implementation MSMiddlewareFactory

+(id<MSGraphMiddleware>)createMiddleware:(MSMiddlewareType)middlewareType
{
    switch (middlewareType)
    {
        case MSMiddlewareTypeHTTP:
        {
             MSURLSessionManager *sessionManager = [[MSURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
            return sessionManager;
        }
        case MSMiddlewareTypeRedirect:
        {
            MSRedirectHandler *redirectHandler = [[MSRedirectHandler alloc] init];
            return redirectHandler;
        }
        case MSMiddlewareTypeAuthentication:
        {
            MSAuthenticationMiddleware *authenticationMiddleware = [[MSAuthenticationMiddleware alloc] init];
            return authenticationMiddleware;
        }
        default:
            break;
    }
    return nil;
}
@end
