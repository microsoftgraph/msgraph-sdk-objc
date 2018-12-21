// Copyright (c) Microsoft Corporation.  All Rights Reserved.  Licensed under the MIT License.  See License in the project root for license information.

#import <Foundation/Foundation.h>

@interface MSTimeOfDay : NSObject

+ (instancetype) timeWithSeconds:(NSInteger)hour minute:(NSInteger)minute second:(NSInteger)second;

- (id) initWithSeconds:(NSInteger)hour minute:(NSInteger)minute second:(NSInteger)second;

@property (nonatomic, readonly) NSInteger hour;
@property (nonatomic, readonly) NSInteger minute;
@property (nonatomic, readonly) NSInteger second;

- (NSString *)ms_toString;
+ (instancetype)ms_timeFromString:(NSString *)timeString;

@end
