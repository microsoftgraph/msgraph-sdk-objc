// Copyright (c) Microsoft Corporation.  All Rights Reserved.  Licensed under the MIT License.  See License in the project root for license information.



#import "NSDate+MSSerialization.h"

#import "MSGraphModels.h"

@interface MSObject()

@property (strong, nonatomic) NSMutableDictionary *dictionary;

@end

@interface MSGraphPhoto()
{
    NSString* _cameraMake;
    NSString* _cameraModel;
    CGFloat _exposureDenominator;
    CGFloat _exposureNumerator;
    CGFloat _fNumber;
    CGFloat _focalLength;
    int32_t _iso;
    NSDate* _takenDateTime;
}
@end

@implementation MSGraphPhoto

- (NSString*) cameraMake
{
    if([[NSNull null] isEqual:self.dictionary[@"cameraMake"]])
    {
        return nil;
    }   
    return self.dictionary[@"cameraMake"];
}

- (void) setCameraMake: (NSString*) val
{
    self.dictionary[@"cameraMake"] = val;
}

- (NSString*) cameraModel
{
    if([[NSNull null] isEqual:self.dictionary[@"cameraModel"]])
    {
        return nil;
    }   
    return self.dictionary[@"cameraModel"];
}

- (void) setCameraModel: (NSString*) val
{
    self.dictionary[@"cameraModel"] = val;
}

- (CGFloat) exposureDenominator
{
    _exposureDenominator = [self.dictionary[@"exposureDenominator"] floatValue];
    return _exposureDenominator;
}

- (void) setExposureDenominator: (CGFloat) val
{
    _exposureDenominator = val;
    self.dictionary[@"exposureDenominator"] = @(val);
}

- (CGFloat) exposureNumerator
{
    _exposureNumerator = [self.dictionary[@"exposureNumerator"] floatValue];
    return _exposureNumerator;
}

- (void) setExposureNumerator: (CGFloat) val
{
    _exposureNumerator = val;
    self.dictionary[@"exposureNumerator"] = @(val);
}

- (CGFloat) fNumber
{
    _fNumber = [self.dictionary[@"fNumber"] floatValue];
    return _fNumber;
}

- (void) setFNumber: (CGFloat) val
{
    _fNumber = val;
    self.dictionary[@"fNumber"] = @(val);
}

- (CGFloat) focalLength
{
    _focalLength = [self.dictionary[@"focalLength"] floatValue];
    return _focalLength;
}

- (void) setFocalLength: (CGFloat) val
{
    _focalLength = val;
    self.dictionary[@"focalLength"] = @(val);
}

- (int32_t) iso
{
    _iso = [self.dictionary[@"iso"] intValue];
    return _iso;
}

- (void) setIso: (int32_t) val
{
    _iso = val;
    self.dictionary[@"iso"] = @(val);
}

- (NSDate*) takenDateTime
{
    if(!_takenDateTime){
        _takenDateTime = [NSDate ms_dateFromString: self.dictionary[@"takenDateTime"]];
    }
    return _takenDateTime;
}

- (void) setTakenDateTime: (NSDate*) val
{
    _takenDateTime = val;
    self.dictionary[@"takenDateTime"] = val;
}

@end
