//
// Copyright (c) Microsoft Corporation. All Rights Reserved. Licensed under the MIT License. See License in the project root for license information.
//

#import "MSURLSessionTask.h"
#import "MSHTTPClient.h"
#import "MSConstants.h"

@interface MSURLSessionTask()

@property (atomic) BOOL isCancelled;

@end

@implementation MSURLSessionTask

- (instancetype)initWithRequest:(NSMutableURLRequest *)request
                         client:(MSHTTPClient *)client
{
    NSParameterAssert(request);
    NSParameterAssert(client);
    
    self = [super init];
    if (self)
    {
        _client = client;
        _request = [request mutableCopy];
    }
    return self;
}

- (void)execute
{
    [self.client.middleware execute:self withCompletionHandler:^(id data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        [self taskCompletedWithData:data response:response andError:error];
    }];
}

- (void)setRequest:(NSMutableURLRequest *)request
{
    _request = request;
}

- (void)setInnerTask:(NSURLSessionTask *)innerTask
{
    if(_isCancelled)
    {
        [innerTask cancel];
    }else
    {
        _innerTask = innerTask;
    }
}

- (void)cancel
{
    if(_innerTask)
    {
       [_innerTask cancel];

    }else
    {
        _isCancelled = YES;
    }

}

- (void)setSDKVersionRequestHeader
{
    NSDictionary *info = [[NSBundle bundleForClass:[self class]] infoDictionary];
    NSString *version = [info objectForKey:@"CFBundleShortVersionString"];
    [_request setValue:[NSString stringWithFormat:@"%@%@", MSGraphSdkVersionHeaderPrefix, version] forHTTPHeaderField:MSHeaderSdkVersion];
}

- (void)taskCompletedWithData:(id)data response:(NSURLResponse *)response andError:(NSError *)error
{
    NSAssert(NO, @"Not Implemented, must implement in sub class");
}

@end
