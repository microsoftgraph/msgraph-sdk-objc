//
// Copyright (c) Microsoft Corporation. All Rights Reserved. Licensed under the MIT License. See License in the project root for license information.
//

#import <XCTest/XCTest.h>
#import "MSTimeOfDay.h"

@interface MSTimeOfDay()

@property (nonatomic, strong) NSDate *date;
- (id) initWithNSDate:(NSDate*)date;

@end

@interface MSTimeOfDayTests : XCTestCase
@property NSInteger testHour;
@property NSInteger testMinute;
@property NSInteger testSecond;
@property NSDateComponents *dateComponents;
@end

@implementation MSTimeOfDayTests

- (void)setUp {
    // Put setup code here. This method is called before the invocation of each test method in the class.
    [super setUp];
    self.testHour = 10;
    self.testMinute = 10;
    self.testSecond = 37;
    self.dateComponents = [[NSDateComponents alloc] init];
    self.dateComponents.hour = _testHour;
    self.dateComponents.minute = _testMinute;
    self.dateComponents.second = _testSecond;
    self.dateComponents.calendar = [NSCalendar currentCalendar];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

-(void)testInit{
    MSTimeOfDay *msTimeOfDay = [[MSTimeOfDay alloc] initWithHour:_testHour minute:_testMinute second:_testSecond];
    XCTAssertNotNil(msTimeOfDay);

    msTimeOfDay = [MSTimeOfDay timeWithHour:_testHour minute:_testMinute second:_testSecond];
    XCTAssertNotNil(msTimeOfDay);

    XCTAssertNoThrow([MSTimeOfDay timeWithHour:0 minute:0 second:0]);
}

-(void)testInitWithNSDate{
    NSDate *nowData = [NSDate date];
    MSTimeOfDay *msTimeOfDay = [[MSTimeOfDay alloc] initWithNSDate: nowData];
    XCTAssertNotNil(msTimeOfDay);
    XCTAssertEqualObjects(msTimeOfDay.date, nowData);
}

-(void)testMSTimeOfDayProertiesFromInstanceInitializer{

    NSDate *nowData = [NSDate date];
    MSTimeOfDay *msTimeOfDay = [[MSTimeOfDay alloc] initWithHour:_testHour minute:_testMinute second:_testSecond];
    NSDateComponents *components = _dateComponents;//[[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:nowData];
    XCTAssertEqual(msTimeOfDay.hour, components.hour);
    XCTAssertEqual(msTimeOfDay.minute, components.minute);
    XCTAssertEqual(msTimeOfDay.second, components.second);

}

-(void)testMS_toString{
    MSTimeOfDay *msTimeOfDay = [[MSTimeOfDay alloc] initWithHour:_testHour minute:_testMinute second:_testSecond];
    NSString *dateString = [msTimeOfDay ms_toString];
    NSString *expectedString =[NSString stringWithFormat:@"%@:%@:%@",[@(_testHour) stringValue],[@(_testMinute) stringValue],[@(_testSecond) stringValue]];
    XCTAssertEqualObjects(dateString, expectedString);
}

-(void)testMS_timeFromString{
    MSTimeOfDay *msTimeOfDay = [MSTimeOfDay ms_timeFromString:[NSString stringWithFormat:@"%@-0%@-%@",[@(_testHour) stringValue],[@(_testMinute) stringValue],[@(_testSecond) stringValue]]];

    XCTAssertNotNil(msTimeOfDay);
    XCTAssertEqual(msTimeOfDay.hour, [_dateComponents hour]);
}
-(void)testMS_timeFromNilString{
    MSTimeOfDay *msdate = [MSTimeOfDay ms_timeFromString:nil];
    XCTAssertNotNil(msdate);
    XCTAssertNil(msdate.date);
}
-(void)testMS_timeFromInvalidFormatterString{
     MSTimeOfDay *msdate = [MSTimeOfDay ms_timeFromString:@"test"];
    XCTAssertNotNil(msdate);
    XCTAssertNil(msdate.date);
}

@end
