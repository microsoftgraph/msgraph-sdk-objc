//
//  MSTelemetryHandlerTests.m
//  MSGraphClientSDKTests
//
//  Created by Vikas Dadheech on 20/05/19.
//  Copyright © 2019 Vikas Dadheech. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "MSGraphClientSDKTests.h"
#import "MSTelemetryHandler.h"

@interface MSURLSessionTask()

-(void)setRequest:(NSMutableURLRequest *)request;
-(void)setFeatureUsage:(int)featureFlag;
-(NSString *)getFeatureUsage;

@end

@interface MSTelemetryHandler()

@property (nonatomic, strong) id<MSGraphMiddleware> nextMiddleware;
- (void)setHTTPProviderFlag:(MSURLSessionTask *)task;
- (void)setVersionHeader:(MSURLSessionTask *)task;
- (void)setFeatureUsageHeader:(MSURLSessionTask *)task;
- (void)setUUIDRequestHeader:(MSURLSessionTask *)task;

@end

@interface MSTelemetryHandlerTests : MSGraphClientSDKTests

@end

@implementation MSTelemetryHandlerTests{
    MSURLSessionDataTask *dataTask;
    MSTelemetryHandler *telemetryHandler;
    NSURLResponse *OKResponse;
}

- (void)setUp {
    [super setUp];
    dataTask = [[MSURLSessionDataTask alloc] initWithRequest:self.requestForMock client:self.mockClient completion: nil];
    telemetryHandler = [[MSTelemetryHandler alloc] init];
    OKResponse = [[NSHTTPURLResponse alloc] initWithURL:[NSURL URLWithString:MSGraphBaseURL] statusCode:MSExpectedResponseCodesOK HTTPVersion:@"foo" headerFields:nil];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    [super tearDown];
    // Put teardown code here. This method is called after the invocation of each test method in the class.
}

- (void)testExecute {
    [telemetryHandler setNext:self.mockHttpProvider];
    HTTPRequestCompletionHandler requestCompletion = ^(id data, NSURLResponse * _Nullable response, NSError * _Nullable error){
        [self completionBlockCodeInvoked];
        XCTAssertNil(error);
        XCTAssertNotNil(response);
        XCTAssertEqual(((NSHTTPURLResponse *)response).statusCode, MSExpectedResponseCodesOK);
        XCTAssertNotNil(data);
    };

    OCMStub([self.mockHttpProvider execute:[OCMArg any] withCompletionHandler:[OCMArg any]]).andDo(^(NSInvocation *invocation){
        HTTPRequestCompletionHandler completionHandler;
        [invocation getArgument:&completionHandler atIndex:3];
        completionHandler([NSData new],self->OKResponse,nil);
    });
    [telemetryHandler execute:dataTask withCompletionHandler:requestCompletion];
    [self checkCompletionBlockCodeInvoked];
    
}

- (void)testHTTPProviderFlagSetter{
    MSURLSessionManager *sessionManager = [[MSURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    [telemetryHandler setNext:sessionManager];
    [telemetryHandler setHTTPProviderFlag:dataTask];
    XCTAssertEqualObjects([dataTask getFeatureUsage], @"8");
}

- (void)testSetVersionAsRequestHeader{
    [telemetryHandler setVersionHeader:dataTask];
    XCTAssertEqualObjects([dataTask.request valueForHTTPHeaderField:MSHeaderSdkVersion],[self getSDKVersionString]);
}

- (void)testAddFeatureUsageAsRequestHeader{
    [telemetryHandler setVersionHeader:dataTask];
    [dataTask setFeatureUsage:REDIRECT_HANDLER_ENABLED_FLAG];
    [dataTask setFeatureUsage:DEFAULT_HTTPPROVIDER_ENABLED_FLAG];
    [telemetryHandler setFeatureUsageHeader:dataTask];

    NSString *headerStringWithFeatureUsage = [NSString stringWithFormat:@"%@ (featureUsage=%@)",[self getSDKVersionString],[dataTask getFeatureUsage]];
    XCTAssertEqualObjects([dataTask.request valueForHTTPHeaderField:MSHeaderSdkVersion],headerStringWithFeatureUsage);
}

- (void)testSetUUIDRequestHeader {
    [telemetryHandler setUUIDRequestHeader:dataTask];
    XCTAssertNotNil([dataTask.request.allHTTPHeaderFields objectForKey:MSClientRequestIdHeaderString]);
}

- (void)testNonSettingUUIDRequestHeader {
    NSString *uuidString = [[NSUUID UUID] UUIDString];
    [self.requestForMock setValue:uuidString forHTTPHeaderField:MSClientRequestIdHeaderString];
    [dataTask setRequest:self.requestForMock];
    XCTAssertEqualObjects([dataTask.request.allHTTPHeaderFields objectForKey:MSClientRequestIdHeaderString],uuidString);
}

- (void)testSetNext {
    id<MSGraphMiddleware> tempMiddleware = OCMProtocolMock(@protocol(MSGraphMiddleware));
    [telemetryHandler setNext:tempMiddleware];
    XCTAssertEqualObjects(tempMiddleware, telemetryHandler.nextMiddleware);
    id<MSGraphMiddleware> tempMiddleware1 = OCMProtocolMock(@protocol(MSGraphMiddleware));
    [telemetryHandler setNext:tempMiddleware1];
    XCTAssertEqualObjects(telemetryHandler.nextMiddleware, tempMiddleware1);
}


- (NSString *)getSDKVersionString{
    NSDictionary *info = [[NSBundle bundleForClass:[MSURLSessionTask class]] infoDictionary];
    NSString *version = [info objectForKey:@"CFBundleShortVersionString"];
    NSString *headerVersionString ;
    if (TARGET_OS_OSX){
        headerVersionString = [NSString stringWithFormat:@"%@%@", MSGraphMacSdkVersionHeaderPrefix, version];
    }else{
        headerVersionString = [NSString stringWithFormat:@"%@%@", MSGraphiOSSdkVersionHeaderPrefix, version];
    }
    return headerVersionString;
}

@end
