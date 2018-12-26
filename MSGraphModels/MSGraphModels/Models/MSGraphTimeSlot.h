// Copyright (c) Microsoft Corporation.  All Rights Reserved.  Licensed under the MIT License.  See License in the project root for license information.



@class MSGraphDateTimeTimeZone; 


#import "MSObject.h"

@interface MSGraphTimeSlot : MSObject

@property (nullable, nonatomic, setter=setStart:, getter=start) MSGraphDateTimeTimeZone* start;
@property (nullable, nonatomic, setter=setEnd:, getter=end) MSGraphDateTimeTimeZone* end;

@end
