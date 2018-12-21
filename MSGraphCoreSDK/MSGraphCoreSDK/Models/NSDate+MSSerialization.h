// Copyright (c) Microsoft Corporation.  All Rights Reserved.  Licensed under the MIT License.  See License in the project root for license information.

#import <Foundation/Foundation.h>

@interface NSDate (Serialization)

- (NSString *)ms_toString;

+ (instancetype)ms_dateFromString:(NSString *)dateString;

@end
