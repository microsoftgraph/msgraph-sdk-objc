//
// Copyright (c) Microsoft Corporation. All Rights Reserved. Licensed under the MIT License. See License in the project root for license information.
//

#import <XCTest/XCTest.h>
#import "NSDate+MSSerialization.h"

static NSString *dateFormatWithMillis = @"yyyy-MM-dd'T'HH:mm:ss.SSSSSSZ";

@interface NSDate_MSSerializationTests : XCTestCase
@property NSDateComponents *dateComponents;
@end

@implementation NSDate_MSSerializationTests

- (void)setUp {
    // Put setup code here. This method is called before the invocation of each test method in the class.
    [super setUp];
    self.dateComponents = [[NSDateComponents alloc] init];
    self.dateComponents.year = 1996;
    self.dateComponents.month = 12;
    self.dateComponents.day = 19;
    self.dateComponents.hour = 16;
    self.dateComponents.minute = 39;
    self.dateComponents.second = 57;
    self.dateComponents.timeZone = [NSTimeZone systemTimeZone];
    self.dateComponents.calendar = [NSCalendar currentCalendar];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
}

- (void)testMS_toString {
    NSDate *nowDate = [NSDate date];

    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:dateFormatWithMillis];
    NSLocale *posix = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
    [dateFormatter setLocale:posix];
    XCTAssertEqualObjects([dateFormatter stringFromDate:nowDate],[nowDate ms_toString]);
}

-(void)testMS_dateFromString{
    NSDate *date = [NSDate ms_dateFromString:@"1996-12-19T16:39:57+05:30"];
    XCTAssertNotNil(date);
    XCTAssertEqualObjects(date, [_dateComponents date]);
}
-(void)testMS_dateFromNilString{
    NSDate *date = [NSDate ms_dateFromString:nil];
    XCTAssertNil(date);
}
-(void)testMS_dateFromInvalidFormatterString{
    NSDate *date = [NSDate ms_dateFromString:@"test"];
    XCTAssertNil(date);
}

@end
