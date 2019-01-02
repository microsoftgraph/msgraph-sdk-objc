//
// Copyright (c) Microsoft Corporation. All Rights Reserved. Licensed under the MIT License. See License in the project root for license information.
//

#import <XCTest/XCTest.h>
#import "MSObject.h"
#import "NSDate+MSSerialization.h"
#import "OCMock.h"


@interface MSObjectTests : XCTestCase

@end

@interface MSObjectTests(){
    NSDictionary *userItemDic;
}
@end

@implementation MSObjectTests

- (void)setUp {
    [super setUp];
    userItemDic = @{
        @"@odata.context": @"https://graph.microsoft.com/v1.0/$metadata#users/$entity",
        @"displayName": @"Tester",
        @"mail": @"tester@graphsdk.onmicrosoft.com"};
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}
-(void)testInit {
    MSObject *object = [[MSObject alloc] init];
    XCTAssertNotNil(object);
    XCTAssertNotNil([object getDictionary]);
}
- (void)testInitWithNilDictionary {
    XCTAssertNil([[MSObject alloc] initWithDictionary:nil]);
}
- (void)testInitDictionary {
    MSObject *msObject= [[MSObject alloc] initWithDictionary:userItemDic];
    XCTAssertNotNil(msObject);
    NSDictionary *outDic = [msObject getDictionary];
    XCTAssertTrue([[outDic objectForKey:@"mail"] isEqualToString:[userItemDic objectForKey:@"mail"]]);
    NSString * dec = [outDic description];
    XCTAssertNotNil(dec);
    XCTAssertTrue([dec isEqualToString:[userItemDic description]]);
}

- (void)testInitWithNilData {
   XCTAssertNil([[MSObject alloc] initWithData:nil error:nil]);
}

- (void)testInitWithData {
    NSError *error;
    NSData *objectData = [NSJSONSerialization dataWithJSONObject:userItemDic options:kNilOptions error:&error];
    XCTAssertNil(error);

    MSObject *msObject = [[MSObject alloc] initWithData:objectData error:&error];
    XCTAssertNil(error);

    NSDictionary *outDic = [msObject getDictionary];
    XCTAssertTrue([[outDic objectForKey:@"mail"] isEqualToString:[userItemDic objectForKey:@"mail"]]);
    NSString * dec = [outDic description];
    XCTAssertNotNil(dec);
    XCTAssertTrue([dec isEqualToString:[userItemDic description]]);

}

- (void)testGetSerializedData {
    NSError *error;
    NSData *objectData = [NSJSONSerialization dataWithJSONObject:userItemDic options:kNilOptions error:&error];
    XCTAssertNil(error);

    MSObject *msObject = [[MSObject alloc] initWithData:objectData error:&error];
    XCTAssertNil(error);

    NSData *serializedData = [msObject getSerializedDataWithError:&error];
    XCTAssertNil(error);
    XCTAssertEqualObjects(objectData, serializedData);
}

@end
