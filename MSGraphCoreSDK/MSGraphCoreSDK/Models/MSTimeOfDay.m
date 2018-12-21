// Copyright (c) Microsoft Corporation.  All Rights Reserved.  Licensed under the MIT License.  See License in the project root for license information.

#import "MSTimeOfDay.h"

static NSString *dateFormat = @"HH:mm:SS";

@interface MSTimeOfDay ()

@property (nonatomic, strong) NSDate *date;

@end

@implementation MSTimeOfDay

#pragma mark - Initializers

+ (instancetype) timeWithSeconds:(NSInteger)hour minute:(NSInteger)minute second:(NSInteger)second {
    return [[MSTimeOfDay alloc] initWithSeconds:hour minute:minute second:second];
}

- (id) initWithNSDate:(NSDate*)date {
    if (self = [super init]) {
        self.date = date;
    }
    return self;
}

- (id) initWithSeconds:(NSInteger)hour minute:(NSInteger)minute second:(NSInteger)second {
    if (self = [super init]) {
        NSDateComponents *components = [[NSDateComponents alloc] init];
        components.hour = hour;
        components.minute = minute;
        components.second = second;
        components.calendar = [NSCalendar currentCalendar];
        self.date = [components date];
    }
    return self;
}


#pragma mark - Properties

- (NSInteger) hour {
    NSDateComponents *components = [[MSTimeOfDay gregorianCalendar] components:NSCalendarUnitYear fromDate:self.date];
    return components.hour;
}

- (NSInteger) minute {
    NSDateComponents *components = [[MSTimeOfDay gregorianCalendar] components:NSCalendarUnitMonth fromDate:self.date];
    return components.minute;
}

- (NSInteger) second {
    NSDateComponents *components = [[MSTimeOfDay gregorianCalendar] components:NSCalendarUnitDay fromDate:self.date];
    return components.second;
}


#pragma mark - Serialization

- (NSString *)ms_toString
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:dateFormat];
    NSLocale *posix = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
    [dateFormatter setLocale:posix];
    return [dateFormatter stringFromDate:self.date];
}

+ (instancetype)ms_timeFromString:(NSString *)dateString
{
    NSDate *date = nil;
    if (dateString){
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:dateFormat];
        NSLocale *posix = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
        [dateFormatter setLocale:posix];
        date = [dateFormatter dateFromString:dateString];
    }
    return [[MSTimeOfDay alloc] initWithNSDate:date];
}

#pragma mark - Helpers

+ (NSCalendar*) gregorianCalendar {
    static NSCalendar *calendar;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    });
    return calendar;
}

@end

