//
// Copyright (c) Microsoft Corporation. All Rights Reserved. Licensed under the MIT License. See License in the project root for license information.
//

#import <XCTest/XCTest.h>
#import "MSGraphSDKTests.h"

@interface MSBatchRequestContent()

- (NSMutableDictionary *)getBatchRequestDictionaryFromRequestStep:(MSBatchRequestStep *)batchRequestStep;

@end

@interface MSBatchRequestContentTests : MSGraphSDKTests

@end

@implementation MSBatchRequestContentTests

- (void)setUp {
    // Put setup code here. This method is called before the invocation of each test method in the class.
    [super setUp];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
}

- (void)testInitWithNilRequestStepArray {
    NSError *error;
    [[MSBatchRequestContent alloc] initWithRequests:nil error:&error];
    XCTAssertNil(error);
}

- (void)testInitWithRequestStepArray {
    MSBatchRequestStep *mockBatchStep = [[MSBatchRequestStep alloc] initWithId:@"1" request:self.requestForMock andDependsOn:nil];
    NSError *error;
    MSBatchRequestContent *requestContent  = [[MSBatchRequestContent alloc] initWithRequests:@[mockBatchStep] error:&error];
    XCTAssertNil(error);
}

- (void)testInitWithMoreRequestStepsThanLimit {
    NSMutableArray *batchStepArray = [NSMutableArray new];
    //Testing whether intitalizing the MSBatchRequestContent with more than max limit [currently 20], produces a client side error.
    for(int i=0;i<21;i++) {
        MSBatchRequestStep *batchStep = [[MSBatchRequestStep alloc] initWithId:[NSString stringWithFormat:@"%d",i] request:self.requestForMock andDependsOn:nil];
        [batchStepArray addObject:batchStep];
    }
    NSError *error;
    MSBatchRequestContent *requestContent  = [[MSBatchRequestContent alloc] initWithRequests:batchStepArray error:&error];
    XCTAssertNotNil(error);
    XCTAssertEqual(error.code, MSErrorCodeMaximumLimitReached);

}

- (MSBatchRequestContent *)createBatchRequestContentWithCoupleOfSteps {
    NSError *error;
    MSBatchRequestContent *requestContent = [[MSBatchRequestContent alloc] initWithRequests:nil error:&error];
    XCTAssertNil(error);

    NSMutableURLRequest *meRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"/me"]];
    MSBatchRequestStep *meBatchStep = [[MSBatchRequestStep alloc] initWithId:@"1" request:meRequest andDependsOn:nil];
    [requestContent addBatchRequestStep:meBatchStep error:&error];
    XCTAssertNil(error);

    NSMutableURLRequest *driveRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"/me/drive"]];
    MSBatchRequestStep *driveBatchStep = [[MSBatchRequestStep alloc] initWithId:@"2" request:driveRequest andDependsOn:@[@"1"]];
    [requestContent addBatchRequestStep:driveBatchStep error:&error];
    XCTAssertNil(error);

    return requestContent;
}

- (void)testAddBatchRequestStepSuccessful {
    MSBatchRequestContent *requestContent = [self createBatchRequestContentWithCoupleOfSteps];
    NSMutableDictionary *batchRequestContent = [requestContent getBatchRequestContent];
    XCTAssertNotNil([batchRequestContent objectForKey:@"requests"]);

    //Test for number of request step content
    NSArray *batchContentArray = [batchRequestContent objectForKey:@"requests"];
    XCTAssertNotNil(batchContentArray);
    XCTAssertEqual(batchContentArray.count, 2);
}

- (void)testAddBatchRequestWithDuplicateRequest {
    MSBatchRequestContent *requestContent = [self createBatchRequestContentWithCoupleOfSteps];
    NSMutableURLRequest *driveRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"/me/drive"]];
    MSBatchRequestStep *driveBatchStep = [[MSBatchRequestStep alloc] initWithId:@"2" request:driveRequest andDependsOn:@[@"1"]];
    //Test for duplicate request id
    NSError *error;
    [requestContent addBatchRequestStep:driveBatchStep error:&error];
    XCTAssertNotNil(error);
    XCTAssertEqual(error.code, MSErrorCodeNonUniqueRequestId);
}

- (void)testAddBatchReuqestWithEmptyRequestId {
    MSBatchRequestContent *requestContent = [self createBatchRequestContentWithCoupleOfSteps];
    //Test for empty request id
    MSBatchRequestStep *empty = [[MSBatchRequestStep alloc] initWithId:@"" request:self.requestForMock andDependsOn:nil];
    NSError *error;
    [requestContent addBatchRequestStep:empty error:&error];
    XCTAssertNotNil(error);
    XCTAssertEqual(error.code, MSErrorCodeEmptyRequestId);
}

- (void)testAddBatchRequestWithMoreStepsThanLimit {
    NSError *error;
    MSBatchRequestContent *requestContent = [[MSBatchRequestContent alloc] initWithRequests:nil error:&error];
    XCTAssertNil(error);
    //Add request steps to reach the limit
    for(int i=1;i<=20;i++) {
        MSBatchRequestStep *batchStep = [[MSBatchRequestStep alloc] initWithId:[NSString stringWithFormat:@"%d",i] request:self.requestForMock andDependsOn:nil];
        [requestContent addBatchRequestStep:batchStep error:&error];
        XCTAssertNil(error);
    }
    //Add one more to tip over the threshold value
    MSBatchRequestStep *batchStep = [[MSBatchRequestStep alloc] initWithId:@"21" request:self.requestForMock andDependsOn:nil];
    [requestContent addBatchRequestStep:batchStep error:&error];
    XCTAssertNotNil(error);
    XCTAssertEqual(error.code, MSErrorCodeMaximumLimitReached);
}

- (void)testRemoveBatchStep {
    NSMutableURLRequest *meRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"/me"]];
    MSBatchRequestStep *meBatchStep = [[MSBatchRequestStep alloc] initWithId:@"1" request:meRequest andDependsOn:nil];

    NSMutableURLRequest *driveRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"/me/drive"]];
    MSBatchRequestStep *driveBatchStep = [[MSBatchRequestStep alloc] initWithId:@"2" request:driveRequest andDependsOn:@[@"1"]];

    NSError *error;
    MSBatchRequestContent *requestContent = [[MSBatchRequestContent alloc] initWithRequests:@[meBatchStep, driveBatchStep] error:&error];
    XCTAssertNil(error);
    NSMutableDictionary *batchRequestContent = [requestContent getBatchRequestContent];
    XCTAssertNotNil([batchRequestContent objectForKey:@"requests"]);

    NSArray *batchContentArray = [batchRequestContent objectForKey:@"requests"];
    XCTAssertNotNil(batchContentArray);
    XCTAssertEqual(batchContentArray.count, 2);
    if(!error) {
        [requestContent removeBatchRequesStepWithId:@"4" error:&error];
        XCTAssertNotNil(error);
        XCTAssertEqual(error.domain, MSErrorDomain);
        XCTAssertEqual(error.code, MSErrorCodeRequestIdNotAvailable);

        error = nil;
        [requestContent removeBatchRequesStepWithId:@"1" error:&error];
        XCTAssertNil(error);
        batchRequestContent = [requestContent getBatchRequestContent];
        XCTAssertNotNil([batchRequestContent objectForKey:@"requests"]);

        batchContentArray = [batchRequestContent objectForKey:@"requests"];
        XCTAssertNotNil(batchContentArray);
        XCTAssertEqual(batchContentArray.count, 1);

        NSMutableDictionary *requestDictionary = [batchContentArray objectAtIndex:0];

        XCTAssertEqual([requestDictionary objectForKey:@"id"], driveBatchStep.requestId);
        XCTAssertEqual([requestDictionary objectForKey:@"url"], driveBatchStep.request.URL.absoluteString);
        XCTAssertEqual([requestDictionary objectForKey:@"method"], driveBatchStep.request.HTTPMethod);
        XCTAssertTrue([(NSMutableArray *)[requestDictionary objectForKey:@"dependsOn"] count]==0);
    }
}

- (void)testGetBatchRequestContent
{
    NSMutableURLRequest *meRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"/me"]];
    MSBatchRequestStep *meBatchStep = [[MSBatchRequestStep alloc] initWithId:@"1" request:meRequest andDependsOn:nil];

    NSError *error;
    MSBatchRequestContent *requestContent = [[MSBatchRequestContent alloc] initWithRequests:@[meBatchStep] error:&error];

    NSMutableDictionary *batchRequestContent = [requestContent getBatchRequestContent];
    XCTAssertNotNil([batchRequestContent objectForKey:@"requests"]);

    NSArray *batchContentArray = [batchRequestContent objectForKey:@"requests"];
    XCTAssertNotNil(batchContentArray);
    XCTAssertEqual(batchContentArray.count, 1);

    NSMutableDictionary *meDictionary = [batchContentArray objectAtIndex:0];

    XCTAssertEqual([meDictionary objectForKey:@"id"], meBatchStep.requestId);
    XCTAssertEqual([meDictionary objectForKey:@"url"], meBatchStep.request.URL.absoluteString);
    XCTAssertEqual([meDictionary objectForKey:@"method"], meBatchStep.request.HTTPMethod);
    XCTAssertNil([meDictionary objectForKey:@"dependsOn"]);
}

- (void)testGetBatchRequestDictionaryFromStep {
    MSBatchRequestContent *requestContent = [[MSBatchRequestContent alloc] initWithRequests:nil error:nil];

    NSMutableURLRequest *meRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"/me"]];
    [meRequest setValue:@"test" forHTTPHeaderField:@"custom-header"];
    NSString *imagePath = [[NSBundle bundleForClass:[self class]] pathForResource:@"UserPhoto" ofType:@".jpg"];
    NSData *data = [NSData dataWithContentsOfFile:imagePath];
    NSString *base64encodedString = [data base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    [meRequest setHTTPBody:data];
    MSBatchRequestStep *meBatchStep = [[MSBatchRequestStep alloc] initWithId:@"2" request:meRequest andDependsOn:@[@"1"]];
    NSMutableDictionary *batchRequestDictionary = [requestContent getBatchRequestDictionaryFromRequestStep:meBatchStep];

    XCTAssertEqualObjects([batchRequestDictionary objectForKey:@"id"], meBatchStep.requestId);
    XCTAssertEqualObjects([batchRequestDictionary objectForKey:@"url"], meBatchStep.request.URL.absoluteString);
    XCTAssertEqualObjects([batchRequestDictionary objectForKey:@"method"], meBatchStep.request.HTTPMethod);
    XCTAssertEqualObjects([[batchRequestDictionary objectForKey:@"headers"] objectForKey:@"custom-header"], [meRequest.allHTTPHeaderFields objectForKey:@"custom-header"]);
    XCTAssertEqual([[batchRequestDictionary objectForKey:@"headers"] objectForKey:@"custom-header"], @"test");
    XCTAssertEqualObjects([batchRequestDictionary objectForKey:@"body"], base64encodedString);
    XCTAssertEqualObjects([batchRequestDictionary objectForKey:@"dependsOn"], meBatchStep.arrayOfDependsOnIds);

    NSDictionary *jsonDictionary = [NSDictionary dictionaryWithObject:@"Banglore" forKey:@"city"];
    data = [NSJSONSerialization dataWithJSONObject:jsonDictionary options:kNilOptions error:nil];
    [meRequest setHTTPBody:data];
    meBatchStep = [[MSBatchRequestStep alloc] initWithId:@"2" request:meRequest andDependsOn:@[@"1"]];
    batchRequestDictionary = [requestContent getBatchRequestDictionaryFromRequestStep:meBatchStep];
    XCTAssertEqualObjects([batchRequestDictionary objectForKey:@"body"], jsonDictionary);
}

@end
