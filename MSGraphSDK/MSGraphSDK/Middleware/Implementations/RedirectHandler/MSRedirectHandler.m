//
// Copyright (c) Microsoft Corporation. All Rights Reserved. Licensed under the MIT License. See License in the project root for license information.
//

#import "MSRedirectHandler.h"
#import "MSURLSessionTask.h"
#import "MSConstants.h"

@interface MSURLSessionTask()

-(void)setRequest:(NSMutableURLRequest *)request;

@end


@interface MSRedirectHandler()
@property (nonatomic, strong) id<MSGraphMiddleware> nextMiddleware;
@end

@implementation MSRedirectHandler
{
    NSInteger maximumRedirectAllowed;
}

- (instancetype)init
{
    self = [super init];
    if(self)
    {
        maximumRedirectAllowed = 5;
    }
    return self;
}

#pragma mark - MSGraphMiddleware method implmentation
- (void)execute:(MSURLSessionTask *)task withCompletionHandler:(HTTPRequestCompletionHandler)completionHandler
{
    [self execute:task redirectsAttempted:0 withCompletionHandler:completionHandler];
}

- (void)setNext:(id<MSGraphMiddleware>)nextMiddleware
{
    if(_nextMiddleware)
    {
        [nextMiddleware setNext:_nextMiddleware];
    }
    _nextMiddleware = nextMiddleware;
}

#pragma mark - Redirect handler methods
- (void)execute:(MSURLSessionTask *)task redirectsAttempted:(NSInteger)redirectsAttempted withCompletionHandler:(HTTPRequestCompletionHandler)completionHandler
{
    __block NSInteger localRedirectsAttempted = redirectsAttempted;
     NSInteger localMaxRedirectsAllowed = maximumRedirectAllowed;
    __block MSURLSessionTask *blockTask = task;
    [self.nextMiddleware execute:blockTask withCompletionHandler:^(id data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if(response && [response isKindOfClass:[NSHTTPURLResponse class]])
        {
            if([self isRedirect:[(NSHTTPURLResponse *)response statusCode]])
            {
                if(localRedirectsAttempted==localMaxRedirectsAllowed)
                {
                    NSDictionary *userInfo = @{
                                               NSLocalizedDescriptionKey: MSErrorOperationUnsuccessfulString,
                                               NSLocalizedFailureReasonErrorKey: [NSString stringWithFormat:MSErrorTooManyRedirectsFormatString,localRedirectsAttempted]
                                               };
                    completionHandler(data, response, [NSError errorWithDomain:MSErrorDomain code:[(NSHTTPURLResponse *)response statusCode] userInfo:userInfo]);
                    return ;
                }
                NSMutableURLRequest *originalRequest = blockTask.request;
                NSDictionary *headerDictionary =[(NSHTTPURLResponse *)response allHeaderFields];

                NSString *newUrlString =[headerDictionary valueForKey:@"Location"];
                if(!newUrlString)
                {
                    NSDictionary *userInfo = @{
                                               NSLocalizedDescriptionKey: MSErrorOperationUnsuccessfulString,
                                               NSLocalizedFailureReasonErrorKey: MSErrorLocationHeaderNotFoundString
                                               };
                    completionHandler(data, response, [NSError errorWithDomain:MSErrorDomain code:[(NSHTTPURLResponse *)response statusCode] userInfo:userInfo]);
                    return ;
                }

                NSMutableURLRequest *newRequest = [originalRequest mutableCopy];
                [newRequest setURL:[NSURL URLWithString:newUrlString]];

                //If the authority of request has changed then we need to remove access token from request headers.
                BOOL shouldRemoveAccessToken =  [self shouldRemoveAccessTokenOfRequest:newRequest withRespectToOriginalRequest:originalRequest];
                if (shouldRemoveAccessToken)
                {
                    [newRequest setValue:nil forHTTPHeaderField:@"Authorization"];
                }
                // status code == 303: change request method from post to get and content to be null
                if([(NSHTTPURLResponse *)response statusCode]==MSExpectedResponseCodesSeeOther)
                {
                    [newRequest setHTTPBody:nil];
                    [newRequest setHTTPMethod:@"GET"];
                }
                [blockTask setRequest:newRequest];
                localRedirectsAttempted++;
                [self execute:blockTask redirectsAttempted:localRedirectsAttempted withCompletionHandler:completionHandler];
            }
            else
            {
                completionHandler(data, response, error);
            }

        }
        else{
            completionHandler(data, response, error);
        }
    }];
}

- (BOOL)isRedirect:(NSInteger)statusCode
{
    if (statusCode == MSExpectedResponseCodesMovedPermanantly ||
        statusCode == MSExpectedResponseCodesFound ||
        statusCode == MSExpectedResponseCodesSeeOther ||
        statusCode == MSExpectedResponseCodesTemporaryRedirect ||
        statusCode == 308)
    {
        return true;
    }
    return false;
}

- (BOOL)shouldRemoveAccessTokenOfRequest:(NSMutableURLRequest *)newRequest withRespectToOriginalRequest:(NSURLRequest *)originalRequest
{
    if( [newRequest.URL.host caseInsensitiveCompare:originalRequest.URL.host] != NSOrderedSame ||
       ![newRequest.URL.scheme isEqualToString:originalRequest.URL.scheme])
    {
        return YES;
    }
    return NO;
}

@end

