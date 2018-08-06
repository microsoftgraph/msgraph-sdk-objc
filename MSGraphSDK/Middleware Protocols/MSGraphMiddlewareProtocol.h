//
//  MSGraphMiddlewareProtocol.h
// Copyright (c) Microsoft Corporation.  All Rights Reserved.  Licensed under the MIT License.  See License in the project root for license information.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "MSTaskParameters.h"

typedef NS_ENUM(NSInteger, MSGraphRequestType){

    MSGraphRequestTypeData = 0,
    MSGraphRequestTypeDownload = 1,
    MSGraphRequestTypeUploadFromData = 2,
    MSGraphRequestTypeUploadFromFile = 3
};


//Completion handler to be called when request finishes
typedef void (^HTTPRequestCompletionHandler)(id data, NSURLResponse * _Nullable response, NSError * _Nullable error);

@protocol MSGraphMiddlewareProtocol <NSObject>

-(void)execute:(MSTaskParameters *)taskParameters forRequestType:(MSGraphRequestType)requestType withCompletionHandler:(HTTPRequestCompletionHandler)completionHandler;

-(void)setNext:(id<MSGraphMiddlewareProtocol>)nextMiddleware;


@end
