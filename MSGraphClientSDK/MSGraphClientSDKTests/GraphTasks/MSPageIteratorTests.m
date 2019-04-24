//
// Copyright (c) Microsoft Corporation. All Rights Reserved. Licensed under the MIT License. See License in the project root for license information.
//

#import <XCTest/XCTest.h>
#import "MSGraphClientSDKTests.h"
#import "MSPageIterator.h"

@interface MSPageIterator()

@property (nonatomic, strong) NSDictionary *dataDictionary;
@property (nonatomic, strong) MSURLSessionDataTask *dataTask;

- (void)fetchNextPage;

@end

@interface MSURLSessionTask()

- (void)taskCompletedWithData:(id)data response:(NSURLResponse *)response andError:(NSError *)error;

@end


@interface MSPageIteratorTests : MSGraphClientSDKTests

@end

@implementation MSPageIteratorTests {
    NSData *demoBatchResponseData;
    NSDictionary *demoResponseDictionary;
}

- (void)setUp {
    [super setUp];
    NSString *jsonPath = [[NSBundle bundleForClass:[self class]] pathForResource:@"PagedResponse" ofType:@".json"];
    XCTAssertNotNil(jsonPath);
    demoBatchResponseData = [NSData dataWithContentsOfFile:jsonPath];
    demoResponseDictionary = [NSJSONSerialization JSONObjectWithData:demoBatchResponseData options:kNilOptions error:nil];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testInit {
    XCTAssertThrows([[MSPageIterator alloc] initWithData:nil client:self.mockClient andIteratorBlock:^(NSDictionary *itemDictionary, BOOL *stop) {
    }]);

    XCTAssertThrows([[MSPageIterator alloc] initWithData:[NSData new] client:nil andIteratorBlock:^(NSDictionary *itemDictionary, BOOL *stop) {
    }]);

    XCTAssertThrows([[MSPageIterator alloc] initWithData:[NSData new] client:self.mockClient andIteratorBlock:nil]);

    XCTAssertNotNil([[MSPageIterator alloc] initWithData:[NSData new] client:self.mockClient andIteratorBlock:^(NSDictionary *itemDictionary, BOOL *stop) {
    }]);
}

- (void)testIntraPageIterateAndStop {
    __block int i=0;
    __block NSArray *valueArray = [demoResponseDictionary objectForKey:@"value"];

    XCTestExpectation *iterationWaitExpectation = [[XCTestExpectation alloc] initWithDescription:@"Waiting for iteration to complete"];

   MSPageIterator *pageIterator = [[MSPageIterator alloc] initWithData:demoBatchResponseData client:self.mockClient andIteratorBlock:^(NSDictionary *itemDictionary, BOOL *stop) {
        XCTAssertEqualObjects(itemDictionary, [valueArray objectAtIndex:i]);
        i++;
        if(i==10){
            *stop = true;
            [iterationWaitExpectation fulfill];
        }
    }];
    [pageIterator iterate];
    [self waitForExpectations:@[iterationWaitExpectation] timeout:2.0];

    XCTAssertFalse(pageIterator.isComplete);
}

- (void)testInterPageIterateAndIsComplete {
    XCTestExpectation *iterationWaitExpectation = [[XCTestExpectation alloc] initWithDescription:@"Waiting for iteration to complete"];

    __block MSPageIterator *pageIterator = [[MSPageIterator alloc] initWithData:demoBatchResponseData client:self.mockClient andIteratorBlock:^(NSDictionary *itemDictionary, BOOL *stop) {
        if([pageIterator isComplete]){
            [iterationWaitExpectation fulfill];
        }
    }];

    MSPageIterator *partialMock = OCMPartialMock(pageIterator);
    OCMStub([partialMock fetchNextPage]).andDo(^(NSInvocation *invocation){
        MSURLSessionDataTask *partialTask = OCMPartialMock(pageIterator.dataTask);
        OCMStub([partialTask execute]).andDo(^(NSInvocation *invocation){
            NSHTTPURLResponse *response = [[NSHTTPURLResponse alloc] initWithURL:[NSURL URLWithString:MSGraphBaseURL] statusCode:MSExpectedResponseCodesOK HTTPVersion:@"foo" headerFields:nil];
            NSMutableDictionary *nextPageDictionary = [self->demoResponseDictionary mutableCopy];
            [nextPageDictionary setObject:@"" forKey:@"@odata.nextLink"];
            NSData *nextPageData = [NSJSONSerialization dataWithJSONObject:nextPageDictionary options:kNilOptions error:nil];
            [pageIterator.dataTask taskCompletedWithData:nextPageData response:response andError:nil];
        });
        [partialTask execute];

    });
    [pageIterator iterate];
    [self waitForExpectations:@[iterationWaitExpectation] timeout:12.0];

    XCTAssertTrue(pageIterator.isComplete);
}
@end
