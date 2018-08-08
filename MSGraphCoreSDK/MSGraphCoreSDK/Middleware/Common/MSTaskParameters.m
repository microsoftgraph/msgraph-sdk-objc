//
//  MSTaskParameters.m
//  TestMiddleware
//
//  Created by Vikas Dadheech on 02/08/18.
//  Copyright © 2018 Vikas Dadheech. All rights reserved.
//

#import "MSTaskParameters.h"

@implementation MSTaskParameters

-(instancetype)initWithRequest:(NSMutableURLRequest *)request{
    self = [super init];
    if(self){
        _request = request;
    }
    return self;
}

@end
