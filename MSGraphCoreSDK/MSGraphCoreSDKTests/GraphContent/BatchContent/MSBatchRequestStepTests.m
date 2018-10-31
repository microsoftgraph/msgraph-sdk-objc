//
// Copyright (c) Microsoft Corporation. All Rights Reserved. Licensed under the MIT License. See License in the project root for license information.
//

#import <XCTest/XCTest.h>
#import "MSGraphCoreSDKTests.h"

@interface MSBatchRequestStepTests : MSGraphCoreSDKTests

@end

@implementation MSBatchRequestStepTests

- (void)setUp {
    // Put setup code here. This method is called before the invocation of each test method in the class.
    [super setUp];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
}

- (void)testInitWithDifferentCases {

    XCTAssertThrows([[MSBatchRequestStep alloc] initWithId:nil request:self.requestForMock andDependsOn:nil]);
    XCTAssertThrows([[MSBatchRequestStep alloc] initWithId:@"1" request:nil andDependsOn:nil]);

    MSBatchRequestStep *batchRequestStep = [[MSBatchRequestStep alloc] initWithId:@"1" request:self.requestForMock andDependsOn:nil];
    XCTAssertEqual(batchRequestStep.requestId, @"1");
    XCTAssertEqual(batchRequestStep.request.URL.absoluteString, self.requestForMock.URL.absoluteString);
    XCTAssertNil(batchRequestStep.arrayOfDependsOnIds);

}

@end
