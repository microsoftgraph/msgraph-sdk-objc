// Copyright (c) Microsoft Corporation.  All Rights Reserved.  Licensed under the MIT License.  See License in the project root for license information.



@class MSGraphTimeSlot; 
#import "MSGraphActivityDomain.h"


#import "MSObject.h"

@interface MSGraphTimeConstraint : MSObject

@property (nullable, nonatomic, setter=setActivityDomain:, getter=activityDomain) MSGraphActivityDomain* activityDomain;
@property (nullable, nonatomic, setter=setTimeslots:, getter=timeslots) NSArray* timeslots;

@end
