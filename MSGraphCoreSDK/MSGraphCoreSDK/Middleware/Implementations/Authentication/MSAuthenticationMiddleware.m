//
//  MSAuthenticationMiddleware.m
// Copyright (c) Microsoft Corporation.  All Rights Reserved.  Licensed under the MIT License.  See License in the project root for license information.
//

#import "MSAuthenticationMiddleware.h"

@interface MSAuthenticationMiddleware()

@property (nonatomic, strong) id<MSGraphMiddleware> nextMiddleware;

@end

@implementation MSAuthenticationMiddleware

- (void)execute:(MSTaskParameters *)taskParameters forRequestType:(MSGraphRequestType)requestType withCompletionHandler:(HTTPRequestCompletionHandler)completionHandler {
    NSLog(@"entering auth middleware");
    [self.authProvider appendAuthenticationHeaders:taskParameters.request completion:^(NSMutableURLRequest *request, NSError *error) {
        if(self.nextMiddleware){
        [self.nextMiddleware execute:taskParameters forRequestType:requestType withCompletionHandler:^(id data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            completionHandler(data,response,error);
            NSLog(@"exiting auth middleware");
        }];
        }else{
            completionHandler(nil,nil,[NSError new]);
        }
    }];
}

-(void)setNext:(id<MSGraphMiddleware>)nextMiddleware{
    id<MSGraphMiddleware> tempMiddleware;
    if(self.nextMiddleware){
        tempMiddleware = self.nextMiddleware;
    }
    _nextMiddleware = nextMiddleware;
    [nextMiddleware setNext:tempMiddleware];
}

@end
