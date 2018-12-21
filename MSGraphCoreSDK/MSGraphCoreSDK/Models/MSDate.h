// Copyright (c) Microsoft Corporation.  All Rights Reserved.  Licensed under the MIT License.  See License in the project root for license information.

#import <Foundation/Foundation.h>

@interface MSDate : NSObject

+ (instancetype) date;
+ (instancetype) dateWithYear:(NSInteger)year month:(NSInteger)month day:(NSInteger)day;

- (id) initWithYear:(NSInteger)year month:(NSInteger)month day:(NSInteger)day;
- (id) initWithNSDate:(NSDate*)date;

@property (nonatomic, readonly) NSInteger year;
@property (nonatomic, readonly) NSInteger month;
@property (nonatomic, readonly) NSInteger day;

- (NSString *)ms_toString;
+ (instancetype)ms_dateFromString:(NSString *)dateString;

@end
