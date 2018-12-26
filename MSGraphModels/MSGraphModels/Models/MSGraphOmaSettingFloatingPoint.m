// Copyright (c) Microsoft Corporation.  All Rights Reserved.  Licensed under the MIT License.  See License in the project root for license information.



#import <MSGraphCoreSDK/NSDate+MSSerialization.h>

#import "MSGraphModels.h"

@interface MSObject()

@property (strong, nonatomic) NSMutableDictionary *dictionary;

@end

@interface MSGraphOmaSettingFloatingPoint()
{
    CGFloat _value;
}
@end

@implementation MSGraphOmaSettingFloatingPoint

- (CGFloat) value
{
    _value = [self.dictionary[@"value"] floatValue];
    return _value;
}

- (void) setValue: (CGFloat) val
{
    _value = val;
    self.dictionary[@"value"] = @(val);
}

@end
