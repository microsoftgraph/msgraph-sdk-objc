//
// Copyright (c) Microsoft Corporation. All Rights Reserved. Licensed under the MIT License. See License in the project root for license information.
//

#import "MSAuthenticationHandler.h"
#import "MSURLSessionTask.h"
#import "MSAuthenticationHandlerOptions.h"

@interface MSURLSessionTask()

- (void)setRequest:(NSMutableURLRequest *)request;

@end


@interface MSAuthenticationHandler()

@property (nonatomic, strong) id<MSGraphMiddleware> nextMiddleware;

@end

@implementation MSAuthenticationHandler

- (instancetype)initWithOptions:(MSAuthenticationHandlerOptions *)authHandlerOptions
{
    self = [super init];
    if(self)
    {
        _authHandlerOptions = authHandlerOptions;
    }
    return self;
}

- (void)execute:(MSURLSessionTask *)task withCompletionHandler:(HTTPRequestCompletionHandler)completionHandler
{
    MSAuthenticationHandlerOptions *authHandlerOptions = [task getMiddlewareOptionWithType:MSMiddlewareOptionsTypeAuth];
    if(!authHandlerOptions)
    {
        authHandlerOptions = _authHandlerOptions;
    }
    [authHandlerOptions.authenticationProvider getAccessTokenWithCompletion:^(NSString *accessToken, NSError *error) {
        if(!error)
        {
            NSMutableURLRequest *urlRequest = [task request];
            [urlRequest setValue:[NSString stringWithFormat:@"Bearer %@",accessToken] forHTTPHeaderField:@"Authorization"];
            [task setRequest:urlRequest];
            [self.nextMiddleware execute:task withCompletionHandler:^(id data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                completionHandler(data, response, error);
            }];
        }
        else
        {
            completionHandler(nil, nil, error);
        }
    }];
}

- (void)setNext:(id<MSGraphMiddleware>)nextMiddleware
{
    if(_nextMiddleware)
    {
        [nextMiddleware setNext:_nextMiddleware];
    }
    _nextMiddleware = nextMiddleware;
}

@end
