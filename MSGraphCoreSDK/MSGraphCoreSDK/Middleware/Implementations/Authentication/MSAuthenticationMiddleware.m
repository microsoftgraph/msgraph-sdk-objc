//
// Copyright (c) Microsoft Corporation. All Rights Reserved. Licensed under the MIT License. See License in the project root for license information.
//

#import "MSAuthenticationMiddleware.h"
#import "MSURLSessionTask.h"

@interface MSURLSessionTask()

- (void)setRequest:(NSMutableURLRequest *)request;

@end


@interface MSAuthenticationMiddleware()

@property (nonatomic, strong) id<MSGraphMiddleware> nextMiddleware;

@end

@implementation MSAuthenticationMiddleware

- (void)execute:(MSURLSessionTask *)task withCompletionHandler:(HTTPRequestCompletionHandler)completionHandler
{
    [self.authProvider getAccessTokenWithCompletion:^(NSString *accessToken, NSError *error) {
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
    id<MSGraphMiddleware> tempMiddleware;
    if(self.nextMiddleware)
    {
        tempMiddleware = self.nextMiddleware;
    }
    _nextMiddleware = nextMiddleware;
    if(tempMiddleware)
    {
        [nextMiddleware setNext:tempMiddleware];
    }
}

@end
