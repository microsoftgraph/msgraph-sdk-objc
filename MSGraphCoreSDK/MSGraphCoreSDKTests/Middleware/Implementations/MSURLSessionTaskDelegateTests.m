//
//  MSURLSessionTaskDelegateTests.m
// Copyright (c) Microsoft Corporation.  All Rights Reserved.  Licensed under the MIT License.  See License in the project root for license information.
//


#import <XCTest/XCTest.h>
#import "MSGraphCoreSDKTests.h"

@interface MSURLSessionTaskDelegate()

@property (strong, nonatomic) NSProgress *progress;

@property (strong, nonatomic) NSMutableData *mutableData;

@property (strong, nonatomic) NSURL *downloadPath;

@property (strong, nonatomic) MSURLSessionTaskCompletion completion;

@end

@interface MSURLSessionTaskDelegateTests : MSGraphCoreSDKTests

@property MSURLSessionTaskDelegate *taskDelegate;


@end

@implementation MSURLSessionTaskDelegateTests

- (void)setUp {
    [super setUp];
    MSURLSessionTaskCompletion taskCompletion = ^(id responseObject, NSURLResponse *response, NSError *error){

    };
    NSProgress *progress = [[NSProgress alloc] init];
    self.taskDelegate = [[MSURLSessionTaskDelegate alloc] initWithProgressRef:&progress completion:taskCompletion];
}

- (void)tearDown {
    self.taskDelegate = nil;
    [super tearDown];
}

- (void)testInitWithNilProgressAndCompletion{
    MSURLSessionTaskDelegate *taskDelegate = [[MSURLSessionTaskDelegate alloc] initWithProgressRef:nil completion:nil];
    XCTAssertNil(taskDelegate.completion);
    XCTAssertNil(taskDelegate.progress);

}

- (void)testInitWithProgress{
    MSURLSessionTaskCompletion taskCompletion = ^(id responseObject, NSURLResponse *response, NSError *error){

    };
    NSProgress *progress = [[NSProgress alloc] init];
    MSURLSessionTaskDelegate *taskDelegate = [[MSURLSessionTaskDelegate alloc] initWithProgressRef:&progress completion:taskCompletion];
    XCTAssertEqual(taskCompletion, taskDelegate.completion);
    XCTAssertEqual(progress, taskDelegate.progress);
}

- (void)testInitWithProgressPointingToNilProgress{
    MSURLSessionTaskCompletion taskCompletion = ^(id responseObject, NSURLResponse *response, NSError *error){

    };
    NSProgress *progress = [[NSProgress alloc] init];
    NSProgress *nilProgress = nil;
    progress = nilProgress;
    MSURLSessionTaskDelegate *taskDelegate = [[MSURLSessionTaskDelegate alloc] initWithProgressRef:&progress completion:taskCompletion];
    XCTAssertEqual(taskCompletion, taskDelegate.completion);
    XCTAssertEqual(progress, taskDelegate.progress);
}

- (void)testUpdateProgress{
    [self.taskDelegate updateProgressWithBytesSent:2300 expectedBytes:9200];
    XCTAssertEqual(2300, self.taskDelegate.progress.completedUnitCount);
    XCTAssertEqual(9200, self.taskDelegate.progress.totalUnitCount);
}

- (void)testDidReceiveData{
    [self.taskDelegate didReceiveData:[NSJSONSerialization dataWithJSONObject:@{@"initKey":@"initData"} options:0 error:nil]];
    NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:self.taskDelegate.mutableData options:0 error:nil];
    XCTAssertTrue([dictionary isEqualToDictionary:@{@"initKey":@"initData"}]);
}

- (void)testTaskDidCompleteWithError{
    MSURLSessionTaskCompletion taskCompletion = ^(id responseObject, NSURLResponse *response, NSError *error){
        [self completionBlockCodeInvoked];
        XCTAssertNotNil(responseObject);
        XCTAssertTrue([responseObject isKindOfClass:[NSData class]]);
        XCTAssertNil(response);
        XCTAssertNil(error);

    };

    MSURLSessionTaskDelegate *taskDelegate = [[MSURLSessionTaskDelegate alloc] initWithProgressRef:nil completion:taskCompletion];

    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    NSURLSessionTask *sessionTask = [session dataTaskWithRequest:self.requestForMock];
    [taskDelegate didReceiveData:[NSJSONSerialization dataWithJSONObject:@{@"initKey":@"initData"} options:0 error:nil]];

    [taskDelegate task:sessionTask didCompleteWithError:nil];

    [self checkCompletionBlockCodeInvoked];
}

- (void)testTaskDidCompleteWithErrorForFileDownload{
    MSURLSessionTaskCompletion taskCompletion = ^(id responseObject, NSURLResponse *response, NSError *error){
        [self completionBlockCodeInvoked];
        XCTAssertNotNil(responseObject);
        XCTAssertTrue([responseObject isKindOfClass:[NSURL class]]);
        XCTAssertNil(response);
        XCTAssertNil(error);

    };

    MSURLSessionTaskDelegate *taskDelegate = [[MSURLSessionTaskDelegate alloc] initWithProgressRef:nil completion:taskCompletion];

    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    NSURLSessionTask *sessionTask = [session dataTaskWithRequest:self.requestForMock];
    [taskDelegate task:sessionTask didCompleteDownload:[NSURL URLWithString:@"file://var/dld.tmp"]];

    [taskDelegate task:sessionTask didCompleteWithError:nil];

    [self checkCompletionBlockCodeInvoked];
}

- (void)testTaskDidCompleteDownload{
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    NSURLSessionTask *sessionTask = [session dataTaskWithRequest:self.requestForMock];
    [self.taskDelegate task:sessionTask didCompleteDownload:[NSURL URLWithString:@"file://var/dld.tmp"]];
    XCTAssertTrue([self.taskDelegate.downloadPath.absoluteString isEqualToString:@"file://var/dld.tmp"]);
}

@end
