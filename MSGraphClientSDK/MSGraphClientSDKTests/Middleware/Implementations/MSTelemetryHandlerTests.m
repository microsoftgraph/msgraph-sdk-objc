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

@interface MSTelemetryHandler()

- (void)setVersionHeader:(MSURLSessionTask *)task;
- (void)setFeatureUsageHeader:(MSURLSessionTask *)task;
- (void)setUUIDRequestHeader:(MSURLSessionTask *)task;

@end

@interface MSTelemetryHandlerTests : MSGraphClientSDKTests

@end

@implementation MSTelemetryHandlerTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    [super tearDown];
    // Put teardown code here. This method is called after the invocation of each test method in the class.
}

- (void)testSetVersionAsRequestHeader{
     MSURLSessionDataTask *dataTask = [[MSURLSessionDataTask alloc] initWithRequest:self.requestForMock client:self.mockClient completion: nil];
    MSTelemetryHandler *telemetryHandler = [[MSTelemetryHandler alloc] init];
    [telemetryHandler setVersionHeader:dataTask];
    NSDictionary *info = [[NSBundle bundleForClass:[MSURLSessionTask class]] infoDictionary];
    NSString *version = [info objectForKey:@"CFBundleShortVersionString"];
    NSString *headerVersionString ;
    if (TARGET_OS_OSX){
        headerVersionString = [NSString stringWithFormat:@"%@%@", MSGraphMacSdkVersionHeaderPrefix, version];
    }else{
        headerVersionString = [NSString stringWithFormat:@"%@%@", MSGraphiOSSdkVersionHeaderPrefix, version];
    }
    XCTAssertEqualObjects([dataTask.request valueForHTTPHeaderField:MSHeaderSdkVersion],headerVersionString);
}

@end
