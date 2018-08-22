//
//  MSGraphMiddleware.h
// Copyright (c) Microsoft Corporation.  All Rights Reserved.  Licensed under the MIT License.  See License in the project root for license information.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class MSURLSessionTask;

/*
 This protocol defined the required set of methods to be implemented by the Classes which will become the part of middleware chain.
 */

//Completion handler to be called when request finishes
typedef void (^HTTPRequestCompletionHandler)(id data, NSURLResponse * _Nullable response, NSError * _Nullable error);

@protocol MSGraphMiddleware <NSObject>

-(void)execute:(MSURLSessionTask *)task withCompletionHandler:(HTTPRequestCompletionHandler)completionHandler;

-(void)setNext:(id<MSGraphMiddleware>)nextMiddleware;

@end
