//
//  MSHTTPClient.m
// Copyright (c) Microsoft Corporation.  All Rights Reserved.  Licensed under the MIT License.  See License in the project root for license information.
//

#import "MSHTTPClient.h"
#import "MSAuthenticationProvider.h"
#import "MSTaskParameters.h"

@implementation MSHTTPClient


-(void)executeDataTaskWithRequest:(NSMutableURLRequest *)request completionHandler:(MSDataCompletionHandler)completionHandler{
    MSTaskParameters *tasksParameters = [[MSTaskParameters alloc] initWithRequest:request];
    [self.middleware execute:tasksParameters forRequestType:MSGraphRequestTypeData withCompletionHandler:^(id data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        completionHandler((NSData *)data, response,error);
    }];

}

-(void)executeDownloadTaskWithRequest:(NSMutableURLRequest *)request progress:(NSProgress *__autoreleasing *)progress completionHandler:(MSRawDownloadCompletionHandler)completionHandler{
    MSTaskParameters *taskParameters = [[MSTaskParameters alloc] initWithRequest:request];
    [taskParameters setProgress:progress];
    [self.middleware execute:taskParameters forRequestType:MSGraphRequestTypeDownload withCompletionHandler:^(id data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        completionHandler((NSURL *)data, response,error);
    }];

}

-(void)executeUploadTaskWithRequest:(NSMutableURLRequest *)request fromData:(NSData *)data progress:(NSProgress *__autoreleasing *)progress completionHandler:(MSRawUploadCompletionHandler)completionHandler{
    MSTaskParameters *taskParameters = [[MSTaskParameters alloc] initWithRequest:request];
    [taskParameters setProgress:progress];
    [taskParameters setFileData:data];
    [self.middleware execute:taskParameters forRequestType:MSGraphRequestTypeUploadFromData withCompletionHandler:^(id data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        completionHandler((NSData *)data, response,error);
    }];

}

-(void)executeUploadTaskWithRequest:(NSMutableURLRequest *)request fromFile:(NSURL *)fileURL progress:(NSProgress *__autoreleasing *)progress completionHandler:(MSRawUploadCompletionHandler)completionHandler{
    MSTaskParameters *taskParameters = [[MSTaskParameters alloc] initWithRequest:request];
    [taskParameters setProgress:progress];
    [taskParameters setFileUrl:fileURL];
    [self.middleware execute:taskParameters forRequestType:MSGraphRequestTypeUploadFromFile withCompletionHandler:^(id data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        completionHandler((NSData *)data, response,error);
    }];
    
}


//-(void)executeRequest:(NSMutableURLRequest *)request forRequestType:(MSGraphRequestType)requestType withCompletionHandler:(HTTPRequestCompletionHandler)handler{
//
//    [self.authenticationProvider executeMiddlewareWithtaskParameters: forRequestType:<#(MSGraphRequestType)#> withCompletionHandler:<#^(id data, NSURLResponse * _Nullable response, NSError * _Nullable error)completionHandler#>]
//
//    [self.authenticationProvider executeMiddlewareWithRequest:request forRequestType:requestType withCompletionHandler:^(id data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
//
//    }];
//
//    //    [self.authenticationProvider appendAuthenticationHeaders:request completion:^(NSMutableURLRequest *request, NSError *error){
//    //        NSURLSession *urlSession = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] ];
//    //
//    //        NSURLSessionDataTask *dataTask = [urlSession dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
//    //            handler(data,response,error);
//    //        }];
//    //
//    //        [dataTask resume];
//    //    }];
//}

@end
