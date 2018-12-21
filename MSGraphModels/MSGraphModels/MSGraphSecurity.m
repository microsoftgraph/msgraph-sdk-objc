// Copyright (c) Microsoft Corporation.  All Rights Reserved.  Licensed under the MIT License.  See License in the project root for license information.



#import "NSDate+MSSerialization.h"

#import "MSGraphModels.h"

@interface MSObject()

@property (strong, nonatomic) NSMutableDictionary *dictionary;

@end

@interface MSGraphSecurity()
{
    NSArray* _alerts;
}
@end

@implementation MSGraphSecurity

- (id) init
{
    if (self = [super init]) {
        self.oDataType = @"#microsoft.graph.security";
    }
    return self;
}
- (NSArray*) alerts
{
    if(!_alerts){
        
    NSMutableArray *alertsResult = [NSMutableArray array];
    NSArray *alerts = self.dictionary[@"alerts"];

    if ([alerts isKindOfClass:[NSArray class]]){
        for (id tempAlert in alerts){
            [alertsResult addObject:tempAlert];
        }
    }

    _alerts = alertsResult;
        
    }
    return _alerts;
}

- (void) setAlerts: (NSArray*) val
{
    _alerts = val;
    self.dictionary[@"alerts"] = val;
}


@end
