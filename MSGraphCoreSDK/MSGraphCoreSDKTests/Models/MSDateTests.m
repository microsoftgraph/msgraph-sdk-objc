//
// Copyright (c) Microsoft Corporation. All Rights Reserved. Licensed under the MIT License. See License in the project root for license information.
//

#import <XCTest/XCTest.h>
#import <Foundation/Foundation.h>
#import "MSDate.h"

@interface MSDate (Test)

@property (nonatomic, strong) NSDate *date;

@end

@interface MSDateTests : XCTestCase
@property NSInteger testYear;
@property NSInteger testMonth;
@property NSInteger testDay;
@property NSDateComponents *dateComponents;
@end

@implementation MSDateTests

- (void)setUp {
    [super setUp];
    self.testYear = 2016;
    self.testMonth = 6;
    self.testDay = 11;
    self.dateComponents = [[NSDateComponents alloc] init];
    self.dateComponents.year = _testYear;
    self.dateComponents.month = _testMonth;
    self.dateComponents.day = _testDay;
    self.dateComponents.calendar = [NSCalendar currentCalendar];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}
-(void)testInit{
    MSDate *msdate = [MSDate date];
    XCTAssertNotNil(msdate);
    
    msdate = [MSDate dateWithYear:_testYear month:_testMonth day:_testDay];
    XCTAssertNotNil(msdate);
    
    XCTAssertNoThrow([MSDate dateWithYear:0 month:0 day:0]);
}

-(void)testInitWithNSDate{
    NSDate *nowData = [NSDate date];
    MSDate *msdate = [[MSDate alloc] initWithNSDate: nowData];
    XCTAssertNotNil(msdate);
    XCTAssertEqualObjects(msdate.date, nowData);
}
-(void)testInitWithNilNSDate{
    MSDate *msdate = [[MSDate alloc] initWithNSDate: nil];
    XCTAssertNotNil(msdate);
    XCTAssertNil(msdate.date);
}
-(void)testInitWithYear{
    MSDate *msdate = [[MSDate alloc] initWithYear:_testYear month:_testMonth day:_testDay];
    XCTAssertEqualObjects(msdate.date, [_dateComponents date]);
}

-(void)testMSDatePropertiesFromInitWithYear{
    MSDate *msdate = [[MSDate alloc] initWithYear:_testYear month:_testMonth day:_testDay];
    XCTAssertEqual([msdate year], _testYear);
    XCTAssertEqual(msdate.month, _testMonth);
    XCTAssertEqual(msdate.day, _testDay);
}
-(void)testMSDateProertiesFromInitWithDate{
    
    NSDate *nowData = [NSDate date];
    MSDate *msdate = [[MSDate alloc] initWithNSDate: nowData];
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:[NSDate date]];
    XCTAssertEqual(msdate.year, components.year);
    XCTAssertEqual(msdate.month, components.month);
    XCTAssertEqual(msdate.day, components.day);
    
}

-(void)testMS_toString{
    MSDate *msdate = [[MSDate alloc] initWithYear:_testYear month:_testMonth day:_testDay];
    NSString *dateString = [msdate ms_toString];
    NSString *expectedString =[NSString stringWithFormat:@"%@-0%@-%@",[@(_testYear) stringValue],[@(_testMonth) stringValue],[@(_testDay) stringValue]];
    XCTAssertEqualObjects(dateString, expectedString);
}

-(void)testMS_dateFromString{
    MSDate *msdate = [MSDate ms_dateFromString:[NSString stringWithFormat:@"%@-0%@-%@",[@(_testYear) stringValue],[@(_testMonth) stringValue],[@(_testDay) stringValue]]];
    
    XCTAssertNotNil(msdate);
    XCTAssertEqualObjects(msdate.date, [_dateComponents date]);
}
-(void)testMS_dateFromNilString{
    MSDate *msdate = [MSDate ms_dateFromString:nil];
    XCTAssertNotNil(msdate);
    XCTAssertNil(msdate.date);
}
-(void)testMS_dateFromInvalidFormatterString{
    MSDate *msdate = [MSDate ms_dateFromString:@"test"];
    XCTAssertNotNil(msdate);
    XCTAssertNil(msdate.date);
}

@end
