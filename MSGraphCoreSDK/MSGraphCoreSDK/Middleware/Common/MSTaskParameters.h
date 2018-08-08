//
//  MSTaskParameters.h
//  TestMiddleware
//
//  Created by Vikas Dadheech on 02/08/18.
//  Copyright © 2018 Vikas Dadheech. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MSTaskParameters : NSObject

@property (nonatomic) NSData *fileData;
@property (nonatomic) NSURL *fileUrl;
@property (nonatomic) NSProgress * __autoreleasing *progress;
@property (nonatomic) NSMutableURLRequest *request;

-(instancetype)initWithRequest:(NSMutableURLRequest *)request;

@end
