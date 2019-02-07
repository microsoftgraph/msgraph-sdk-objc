//
// Copyright (c) Microsoft Corporation. All Rights Reserved. Licensed under the MIT License. See License in the project root for license information.
//

#import <XCTest/XCTest.h>
#import "MSGraphClientSDKTests.h"

@interface MSBatchResponseContent()
@property (strong, nonatomic) NSDictionary *batchResponseDictionary;
@end

@interface MSBatchResponseContentTests : MSGraphClientSDKTests

@end

@implementation MSBatchResponseContentTests
{
    NSData *demoBatchResponseData;
}

- (void)setUp {
    // Put setup code here. This method is called before the invocation of each test method in the class.
    [super setUp];
    NSString *jsonPath = [[NSBundle bundleForClass:[self class]] pathForResource:@"BatchResponse" ofType:@".json"];
    XCTAssertNotNil(jsonPath);
    demoBatchResponseData = [NSData dataWithContentsOfFile:jsonPath];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
}

- (void)testInit {
    XCTAssertThrows([[MSBatchResponseContent alloc] initWithBatchResponseData:nil options:kNilOptions error:nil]);
    NSError *error;
    MSBatchResponseContent *batchResponseContent = [[MSBatchResponseContent alloc] initWithBatchResponseData:demoBatchResponseData options:kNilOptions error:&error];
    XCTAssertNil(error);
    XCTAssertNotNil(batchResponseContent.batchResponseDictionary);
}

- (void)testGetResponseById {
    NSError *error;
    MSBatchResponseContent *batchResponseContent = [[MSBatchResponseContent alloc] initWithBatchResponseData:demoBatchResponseData options:kNilOptions error:&error];
    XCTAssertNil(error);
    XCTAssertNil([batchResponseContent getResponseById:@"100"]);
    NSDictionary *responseDictioanry = [batchResponseContent getResponseById:@"1"];

    NSDictionary *originalJsonDictionary = [NSJSONSerialization JSONObjectWithData:demoBatchResponseData options:kNilOptions error:&error];
    XCTAssertNil(error);
    NSDictionary *originalResponseDictionary;
    for(NSDictionary *responseDict in [originalJsonDictionary objectForKey:@"responses"]) {
        if([[responseDict objectForKey:@"id"] isEqualToString:@"1"]) {
            originalResponseDictionary = responseDict;
            break;
        }
    }
    XCTAssertEqualObjects([responseDictioanry objectForKey:@"id"],[originalResponseDictionary objectForKey:@"id"]);
    XCTAssertEqualObjects([responseDictioanry objectForKey:@"status"],[originalResponseDictionary objectForKey:@"status"]);
    XCTAssertEqualObjects([[responseDictioanry objectForKey:@"headers"] objectForKey:@"location"],[[originalResponseDictionary objectForKey:@"headers"] objectForKey:@"location"]);
}

- (void)testGetResponses {
    NSError *error;
    MSBatchResponseContent *batchResponseContent = [[MSBatchResponseContent alloc] initWithBatchResponseData:demoBatchResponseData options:kNilOptions error:&error];
    XCTAssertNil(error);

    NSDictionary *originalJsonDictionary = [NSJSONSerialization JSONObjectWithData:demoBatchResponseData options:kNilOptions error:&error];
    XCTAssertNil(error);
    XCTAssertEqualObjects([batchResponseContent getResponses], originalJsonDictionary);
}

@end
