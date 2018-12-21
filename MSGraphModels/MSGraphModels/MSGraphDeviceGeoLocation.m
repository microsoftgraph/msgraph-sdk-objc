// Copyright (c) Microsoft Corporation.  All Rights Reserved.  Licensed under the MIT License.  See License in the project root for license information.



#import "NSDate+MSSerialization.h"

#import "MSGraphModels.h"

@interface MSObject()

@property (strong, nonatomic) NSMutableDictionary *dictionary;

@end

@interface MSGraphDeviceGeoLocation()
{
    NSDate* _lastCollectedDateTime;
    CGFloat _longitude;
    CGFloat _latitude;
    CGFloat _altitude;
    CGFloat _horizontalAccuracy;
    CGFloat _verticalAccuracy;
    CGFloat _heading;
    CGFloat _speed;
}
@end

@implementation MSGraphDeviceGeoLocation

- (NSDate*) lastCollectedDateTime
{
    if(!_lastCollectedDateTime){
        _lastCollectedDateTime = [NSDate ms_dateFromString: self.dictionary[@"lastCollectedDateTime"]];
    }
    return _lastCollectedDateTime;
}

- (void) setLastCollectedDateTime: (NSDate*) val
{
    _lastCollectedDateTime = val;
    self.dictionary[@"lastCollectedDateTime"] = val;
}

- (CGFloat) longitude
{
    _longitude = [self.dictionary[@"longitude"] floatValue];
    return _longitude;
}

- (void) setLongitude: (CGFloat) val
{
    _longitude = val;
    self.dictionary[@"longitude"] = @(val);
}

- (CGFloat) latitude
{
    _latitude = [self.dictionary[@"latitude"] floatValue];
    return _latitude;
}

- (void) setLatitude: (CGFloat) val
{
    _latitude = val;
    self.dictionary[@"latitude"] = @(val);
}

- (CGFloat) altitude
{
    _altitude = [self.dictionary[@"altitude"] floatValue];
    return _altitude;
}

- (void) setAltitude: (CGFloat) val
{
    _altitude = val;
    self.dictionary[@"altitude"] = @(val);
}

- (CGFloat) horizontalAccuracy
{
    _horizontalAccuracy = [self.dictionary[@"horizontalAccuracy"] floatValue];
    return _horizontalAccuracy;
}

- (void) setHorizontalAccuracy: (CGFloat) val
{
    _horizontalAccuracy = val;
    self.dictionary[@"horizontalAccuracy"] = @(val);
}

- (CGFloat) verticalAccuracy
{
    _verticalAccuracy = [self.dictionary[@"verticalAccuracy"] floatValue];
    return _verticalAccuracy;
}

- (void) setVerticalAccuracy: (CGFloat) val
{
    _verticalAccuracy = val;
    self.dictionary[@"verticalAccuracy"] = @(val);
}

- (CGFloat) heading
{
    _heading = [self.dictionary[@"heading"] floatValue];
    return _heading;
}

- (void) setHeading: (CGFloat) val
{
    _heading = val;
    self.dictionary[@"heading"] = @(val);
}

- (CGFloat) speed
{
    _speed = [self.dictionary[@"speed"] floatValue];
    return _speed;
}

- (void) setSpeed: (CGFloat) val
{
    _speed = val;
    self.dictionary[@"speed"] = @(val);
}

@end
