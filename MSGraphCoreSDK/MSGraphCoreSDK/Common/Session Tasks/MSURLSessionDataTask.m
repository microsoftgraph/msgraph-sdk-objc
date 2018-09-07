// Copyright (c) Microsoft Corporation.  All Rights Reserved.  Licensed under the MIT License.  See License in the project root for license information.

#import "MSURLSessionDataTask.h"
#import "MSHTTPClient.h"
//#import "NSJSONSerialization+ResponseHelper.h"
//#import "MSConstants.h"

@interface MSURLSessionDataTask()

@property (strong) void (^completionHandler)(NSData *data, NSURLResponse *response, NSError *error);

@end

@implementation MSURLSessionDataTask

- (instancetype)initWithRequest:(NSMutableURLRequest *)request
                         client:(MSHTTPClient *)client
                     completion:(void (^)(NSData *data, NSURLResponse *response, NSError *error))completionHandler
{
    self = [super initWithRequest:request client:client];
    if (self){
        _completionHandler = completionHandler;
    }
    return self;
}

- (void)taskCompletedWithData:(id)data response:(NSURLResponse *)response andError:(NSError *)error{
    _completionHandler(data,response,error);
}

@end
