//
//  MSURLSessionManagerTests.m
// Copyright (c) Microsoft Corporation.  All Rights Reserved.  Licensed under the MIT License.  See License in the project root for license information.
//

#import <XCTest/XCTest.h>
#import "MSGraphCoreSDK.h"
#import "MSURLSessionTaskDelegate.h"
#import "OCMock.h"


@interface MSURLSessionManager()
@property (strong, nonatomic) NSURLSessionConfiguration *urlSessionConfiguration;
@property (strong, nonatomic) NSURLSession *urlSession;
@property (strong, nonatomic) NSMutableDictionary *taskDelegates;
@end

@interface MSURLSessionTaskDelegate()
@property (strong, nonatomic) NSProgress *progress;
@property (strong, nonatomic) NSMutableData *mutableData;
@property (strong, nonatomic) NSURL *downloadPath;
@property (strong, nonatomic) MSURLSessionTaskCompletion completion;
@end

@interface MSURLSessionManagerTests : XCTestCase
@property (nonatomic,retain) MSURLSessionManager * sessionManager;

@property (nonatomic,retain) id<MSHttpProvider> httpProviderDelegate;

@property (nonatomic,retain) NSURL * requestURL;
@property (nonatomic,retain) NSURLRequest *request;
@property (nonatomic) __block BOOL bComoletionBlockInvoked;
@end

@implementation MSURLSessionManagerTests

- (void)setUp {
    [super setUp];
    self.requestURL = [NSURL URLWithString:MSGraphBaseURL];
    self.request = [[NSURLRequest alloc] initWithURL:_requestURL];
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    self.sessionManager = [[MSURLSessionManager alloc] initWithSessionConfiguration:config];

    self.httpProviderDelegate = _sessionManager;
    self.bComoletionBlockInvoked = NO;
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    self.requestURL = nil;
    self.request = nil;
    self.sessionManager = nil;

    [super tearDown];

}

- (void)testMSURLSessionManagerInitWithNilconfig{
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    MSURLSessionManager * initSessionManager = [[MSURLSessionManager alloc] initWithSessionConfiguration:nil];
    XCTAssertNotNil(initSessionManager);
    XCTAssertEqualObjects(initSessionManager.urlSession.configuration, config);
    XCTAssertEqualObjects(initSessionManager.urlSession.delegate, initSessionManager);
}
- (void)testMSURLSessionManagerInit{
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    MSURLSessionManager * initSessionManager = [[MSURLSessionManager alloc] initWithSessionConfiguration:config];
    XCTAssertNotNil(initSessionManager);
    XCTAssertNotNil(initSessionManager.urlSessionConfiguration);
    XCTAssertEqualObjects(initSessionManager.urlSessionConfiguration, config);

    XCTAssertNotNil(initSessionManager.urlSessionConfiguration);
    XCTAssertEqualObjects(initSessionManager.urlSession.configuration, config);
    XCTAssertEqualObjects(initSessionManager.urlSession.delegate, initSessionManager);
}

#pragma mark - dataTaskWithRequest success
-(void)testMSURLSessionManagerInitAndMSHttpProviderDelegateDataTaskWithRequestWithOk{

    //Creating a demo response dictionary and data
    NSDictionary *returnDic = @{@"testkey":@"testvalue"};
    NSData *returnData = [NSJSONSerialization dataWithJSONObject:returnDic options:0 error:nil];

    id<NSURLSessionDataDelegate> nsURLSessionDataDelegate = _sessionManager;

    __weak typeof(self) weakSelf = self;

    MSDataCompletionHandler msdataCompletion =^(NSData *data, NSURLResponse *response, NSError *error) {
        weakSelf.bComoletionBlockInvoked = YES;
        XCTAssertNil(error);
        XCTAssertNotNil(response);
        XCTAssertEqual(((NSHTTPURLResponse *)response).statusCode, MSExpectedResponseCodesOK);
        XCTAssertNotNil(data);
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        XCTAssertNotNil(dict);
        XCTAssertTrue([dict isEqualToDictionary:returnDic]);
    };

    //Creating data task
    NSURLSessionDataTask *datatask = [_httpProviderDelegate dataTaskWithRequest:_request completionHandler:msdataCompletion];
    XCTAssertNotNil(datatask);

    //Creating task delegate
    MSURLSessionTaskDelegate * msUrlsessionTaskDelegate = [_sessionManager.taskDelegates objectForKey:@(datatask.taskIdentifier)];
    XCTAssertNotNil(msUrlsessionTaskDelegate);
    XCTAssertEqualObjects(msUrlsessionTaskDelegate.completion, msdataCompletion);

    //Mocking did receive data
    [nsURLSessionDataDelegate URLSession:_sessionManager.urlSession dataTask:datatask didReceiveData:returnData];

    [self mockMSURLSessionTaskDelegateDidCompleteWithError:msUrlsessionTaskDelegate task:datatask statusCode:MSExpectedResponseCodesOK bpath:NO];
    //Mocking did complete
    [nsURLSessionDataDelegate URLSession:_sessionManager.urlSession task:datatask didCompleteWithError:nil];
    XCTAssertTrue(_bComoletionBlockInvoked,@"MSDataCompletionHandler was not invoked");
}


#pragma mark - Mock HTTP URL Response
-(void)mockMSURLSessionTaskDelegateDidCompleteWithError:(MSURLSessionTaskDelegate *)msUrlsessionTaskDelegate task:(NSURLSessionTask *)task statusCode:(NSInteger)statusCode bpath:(BOOL)bpath{
    MSURLSessionTaskDelegate *mockMSURLSessionTaskDelegate = OCMPartialMock(msUrlsessionTaskDelegate);

    OCMStub([mockMSURLSessionTaskDelegate task:task didCompleteWithError:[OCMArg any]])
    .andDo(^(NSInvocation *invocation){
        NSHTTPURLResponse *response = [[NSHTTPURLResponse alloc] initWithURL:self->_requestURL statusCode:statusCode HTTPVersion:@"foo" headerFields:nil];
        if(bpath){
            mockMSURLSessionTaskDelegate.completion(mockMSURLSessionTaskDelegate.downloadPath, response, nil);
        }
        else{
            mockMSURLSessionTaskDelegate.completion(mockMSURLSessionTaskDelegate.mutableData, response, nil);
        }
      }
    );
}
@end

