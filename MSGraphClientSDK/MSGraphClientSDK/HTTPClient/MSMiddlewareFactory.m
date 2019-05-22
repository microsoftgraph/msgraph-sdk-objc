//
// Copyright (c) Microsoft Corporation. All Rights Reserved. Licensed under the MIT License. See License in the project root for license information.
//

#import "MSMiddlewareFactory.h"
#import "MSURLSessionManager.h"
#import "MSAuthenticationHandler.h"
#import "MSRedirectHandler.h"
#import "MSRetryHandler.h"
#import "MSTelemetryHandler.h"

@implementation MSMiddlewareFactory

+(id<MSGraphMiddleware>)createMiddleware:(MSMiddlewareType)middlewareType
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
            MSRedirectHandler *redirectHandler = [[MSRedirectHandler alloc] init];
            return redirectHandler;
        }
        case MSMiddlewareTypeAuthentication:
        {
            MSAuthenticationHandler *authenticationHandler = [[MSAuthenticationHandler alloc] init];
            return authenticationHandler;
        }
        case MSMiddlewareTypeRetry:
        {
            MSRetryHandler *retryHandler = [[MSRetryHandler alloc] init];
            return retryHandler;
        }
        case MSMiddlewareTypeTelemetry:
        {
            MSTelemetryHandler *telemetryHanlder = [[MSTelemetryHandler alloc] init];
            return telemetryHanlder;
        }
        default:
            break;
    }
    return nil;
}
@end
