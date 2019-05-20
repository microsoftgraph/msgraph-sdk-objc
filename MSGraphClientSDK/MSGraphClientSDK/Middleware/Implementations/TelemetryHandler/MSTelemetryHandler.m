//
// Copyright (c) Microsoft Corporation. All Rights Reserved. Licensed under the MIT License. See License in the project root for license information.
//


#import "MSTelemetryHandler.h"
#import "MSURLSessionTask.h"
#import "MSURLSessionManager.h"

@interface MSURLSessionTask()

-(void)setRequest:(NSMutableURLRequest *)request;
-(void)setFeatureUsage:(int)featureFlag;
-(NSString *)getFeatureUsage;

@end

@interface MSTelemetryHandler()

@property (nonatomic, strong) id<MSGraphMiddleware> nextMiddleware;

@end

@implementation MSTelemetryHandler

- (void)execute:(MSURLSessionTask *)task withCompletionHandler:(HTTPRequestCompletionHandler)completionHandler
{
    [self setVersionHeader:task];
    [self setHTTPProviderFlag:task];
    [self setFeatureUsageHeader:task];
    [self setUUIDRequestHeader:task];
    [self.nextMiddleware execute:task withCompletionHandler:completionHandler];
}

- (void)setHTTPProviderFlag:(MSURLSessionTask *)task
{
    if([self.nextMiddleware isKindOfClass:[MSURLSessionManager class]])
    {
        [task setFeatureUsage:DEFAULT_HTTPPROVIDER_ENABLED_FLAG];
    }
}

- (void)setVersionHeader:(MSURLSessionTask *)task
{
    NSMutableURLRequest *request = [task request];
    NSDictionary *info = [[NSBundle bundleForClass:[self class]] infoDictionary];
    NSString *version = [info objectForKey:@"CFBundleShortVersionString"];
    if (TARGET_OS_OSX)
    {
        [request setValue:[NSString stringWithFormat:@"%@%@", MSGraphMacSdkVersionHeaderPrefix, version] forHTTPHeaderField:MSHeaderSdkVersion];
    }else
    {
        [request setValue:[NSString stringWithFormat:@"%@%@", MSGraphiOSSdkVersionHeaderPrefix, version] forHTTPHeaderField:MSHeaderSdkVersion];
    }
    [task setRequest:request];
}

- (void)setFeatureUsageHeader:(MSURLSessionTask *)task
{
    NSMutableURLRequest *request = [task request];
    NSString *featureUsage = [NSString stringWithFormat:@" (featureUsage=%@)",[task getFeatureUsage]];
    NSString *sdkVersion = [[request allHTTPHeaderFields] objectForKey:MSHeaderSdkVersion];
    sdkVersion = [sdkVersion stringByAppendingString:featureUsage];
    [request setValue:sdkVersion forHTTPHeaderField:MSHeaderSdkVersion];
    [task setRequest:request];
}

- (void)setUUIDRequestHeader:(MSURLSessionTask *)task
{
    NSMutableURLRequest *request = [task request];
    if(![request.allHTTPHeaderFields objectForKey:MSClientRequestIdHeaderString])
    {
        [request setValue:[[NSUUID UUID] UUIDString] forHTTPHeaderField:MSClientRequestIdHeaderString];
    }
    [task setRequest:request];
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
