// Copyright (c) Microsoft Corporation.  All Rights Reserved.  Licensed under the MIT License.  See License in the project root for license information.



#import <UIKit/UiKit.h>


#import "MSObject.h"

@interface MSGraphOutlookGeoCoordinates : MSObject

@property (nonatomic, setter=setAltitude:, getter=altitude) CGFloat altitude;
@property (nonatomic, setter=setLatitude:, getter=latitude) CGFloat latitude;
@property (nonatomic, setter=setLongitude:, getter=longitude) CGFloat longitude;
@property (nonatomic, setter=setAccuracy:, getter=accuracy) CGFloat accuracy;
@property (nonatomic, setter=setAltitudeAccuracy:, getter=altitudeAccuracy) CGFloat altitudeAccuracy;

@end
