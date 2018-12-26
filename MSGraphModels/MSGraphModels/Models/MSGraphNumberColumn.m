// Copyright (c) Microsoft Corporation.  All Rights Reserved.  Licensed under the MIT License.  See License in the project root for license information.



#import <MSGraphCoreSDK/NSDate+MSSerialization.h>

#import "MSGraphModels.h"

@interface MSObject()

@property (strong, nonatomic) NSMutableDictionary *dictionary;

@end

@interface MSGraphNumberColumn()
{
    NSString* _decimalPlaces;
    NSString* _displayAs;
    CGFloat _maximum;
    CGFloat _minimum;
}
@end

@implementation MSGraphNumberColumn

- (NSString*) decimalPlaces
{
    if([[NSNull null] isEqual:self.dictionary[@"decimalPlaces"]])
    {
        return nil;
    }   
    return self.dictionary[@"decimalPlaces"];
}

- (void) setDecimalPlaces: (NSString*) val
{
    self.dictionary[@"decimalPlaces"] = val;
}

- (NSString*) displayAs
{
    if([[NSNull null] isEqual:self.dictionary[@"displayAs"]])
    {
        return nil;
    }   
    return self.dictionary[@"displayAs"];
}

- (void) setDisplayAs: (NSString*) val
{
    self.dictionary[@"displayAs"] = val;
}

- (CGFloat) maximum
{
    _maximum = [self.dictionary[@"maximum"] floatValue];
    return _maximum;
}

- (void) setMaximum: (CGFloat) val
{
    _maximum = val;
    self.dictionary[@"maximum"] = @(val);
}

- (CGFloat) minimum
{
    _minimum = [self.dictionary[@"minimum"] floatValue];
    return _minimum;
}

- (void) setMinimum: (CGFloat) val
{
    _minimum = val;
    self.dictionary[@"minimum"] = @(val);
}

@end
