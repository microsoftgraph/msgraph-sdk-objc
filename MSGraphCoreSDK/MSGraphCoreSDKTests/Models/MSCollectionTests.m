//
// Copyright (c) Microsoft Corporation. All Rights Reserved. Licensed under the MIT License. See License in the project root for license information.
//

#import <XCTest/XCTest.h>
#import "MSCollection.h"
#import "MSConstants.h"

@interface MSCollectionTests : XCTestCase
@end

@implementation MSCollectionTests {
    NSDictionary *collectionDictionary;
    NSArray *valueArray;
    NSURL *nextLink;
}

- (void)setUp {
    [super setUp];
   NSDictionary *userItemDict1 = @{
                     @"@odata.context": @"https://graph.microsoft.com/v1.0/$metadata#users/$entity",
                     @"displayName": @"Tester 1",
                     @"mail": @"tester1@graphsdk.onmicrosoft.com"};
    NSDictionary *userItemDict2 = @{
                                    @"@odata.context": @"https://graph.microsoft.com/v1.0/$metadata#users/$entity",
                                    @"displayName": @"Tester 2",
                                    @"mail": @"tester2@graphsdk.onmicrosoft.com"};
    nextLink = [NSURL URLWithString:MSGraphBaseURL];
    valueArray = @[userItemDict1, userItemDict2];
    collectionDictionary = @{
                             @"@odata.context": @"https://graph.microsoft.com/v1.0/$metadata#users",
                             @"@odata.nextLink": [nextLink absoluteString],
                             @"value": valueArray
                             };
}

- (void)tearDown {
    [super tearDown];
}

- (void)testInitWithArray {
    NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:@"testDict",@"dictKey1", nil];
    
    MSCollection *msCollection = [[MSCollection alloc] initWithArray:valueArray nextLink:[nextLink absoluteString] additionalData:dic];
    XCTAssertNotNil(msCollection);
    XCTAssertEqualObjects(msCollection.value, valueArray);
    XCTAssertTrue([msCollection.nextLink.absoluteString isEqualToString:[nextLink absoluteString]]);
    XCTAssertEqualObjects(msCollection.additionalData, dic);
    
}

- (void)testInitWithData {
    NSError *error;
    NSData *collectionData = [NSJSONSerialization dataWithJSONObject:collectionDictionary options:kNilOptions error:&error];
    XCTAssertNil(error);

    MSCollection *msCollection = [[MSCollection alloc] initWithData:collectionData error:&error];
    XCTAssertNil(error);
    XCTAssertNotNil(msCollection);
    XCTAssertEqualObjects(msCollection.value, valueArray);
    XCTAssertTrue([msCollection.nextLink.absoluteString isEqualToString:[nextLink absoluteString]]);
    XCTAssertEqualObjects(msCollection.additionalData, collectionDictionary);

}

- (void)testInitWithDictionary {
    NSError *error;
    MSCollection *msCollection = [[MSCollection alloc] initWithDictionary:collectionDictionary];
    XCTAssertNil(error);
    XCTAssertNotNil(msCollection);
    XCTAssertEqualObjects(msCollection.value, valueArray);
    XCTAssertTrue([msCollection.nextLink.absoluteString isEqualToString:[nextLink absoluteString]]);
    XCTAssertEqualObjects(msCollection.additionalData, collectionDictionary);
}


@end
