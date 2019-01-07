// Copyright (c) Microsoft Corporation.  All Rights Reserved.  Licensed under the MIT License.  See License in the project root for license information.






#import <MSGraphCoreSDK/MSObject.h>

@interface MSGraphDeviceGeoLocation : MSObject

@property (nonnull, nonatomic, setter=setLastCollectedDateTime:, getter=lastCollectedDateTime) NSDate* lastCollectedDateTime;
@property (nonatomic, setter=setLongitude:, getter=longitude) CGFloat longitude;
@property (nonatomic, setter=setLatitude:, getter=latitude) CGFloat latitude;
@property (nonatomic, setter=setAltitude:, getter=altitude) CGFloat altitude;
@property (nonatomic, setter=setHorizontalAccuracy:, getter=horizontalAccuracy) CGFloat horizontalAccuracy;
@property (nonatomic, setter=setVerticalAccuracy:, getter=verticalAccuracy) CGFloat verticalAccuracy;
@property (nonatomic, setter=setHeading:, getter=heading) CGFloat heading;
@property (nonatomic, setter=setSpeed:, getter=speed) CGFloat speed;

@end
