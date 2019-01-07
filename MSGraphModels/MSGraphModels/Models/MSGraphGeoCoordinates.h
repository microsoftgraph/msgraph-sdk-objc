// Copyright (c) Microsoft Corporation.  All Rights Reserved.  Licensed under the MIT License.  See License in the project root for license information.






#import <MSGraphCoreSDK/MSObject.h>

@interface MSGraphGeoCoordinates : MSObject

@property (nonatomic, setter=setAltitude:, getter=altitude) CGFloat altitude;
@property (nonatomic, setter=setLatitude:, getter=latitude) CGFloat latitude;
@property (nonatomic, setter=setLongitude:, getter=longitude) CGFloat longitude;

@end
