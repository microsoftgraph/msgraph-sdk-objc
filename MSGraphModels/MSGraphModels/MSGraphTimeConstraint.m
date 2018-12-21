// Copyright (c) Microsoft Corporation.  All Rights Reserved.  Licensed under the MIT License.  See License in the project root for license information.



#import "NSDate+MSSerialization.h"

#import "MSGraphModels.h"

@interface MSObject()

@property (strong, nonatomic) NSMutableDictionary *dictionary;

@end

@interface MSGraphTimeConstraint()
{
    MSGraphActivityDomain* _activityDomain;
    NSArray* _timeslots;
}
@end

@implementation MSGraphTimeConstraint

- (MSGraphActivityDomain*) activityDomain
{
    if(!_activityDomain){
        _activityDomain = [self.dictionary[@"activityDomain"] toMSGraphActivityDomain];
    }
    return _activityDomain;
}

- (void) setActivityDomain: (MSGraphActivityDomain*) val
{
    _activityDomain = val;
    self.dictionary[@"activityDomain"] = val;
}

- (NSArray*) timeslots
{
    if(!_timeslots){
        
    NSMutableArray *timeslotsResult = [NSMutableArray array];
    NSArray *timeslots = self.dictionary[@"timeslots"];

    if ([timeslots isKindOfClass:[NSArray class]]){
        for (id tempTimeSlot in timeslots){
            [timeslotsResult addObject:tempTimeSlot];
        }
    }

    _timeslots = timeslotsResult;
        
    }
    return _timeslots;
}

- (void) setTimeslots: (NSArray*) val
{
    _timeslots = val;
    self.dictionary[@"timeslots"] = val;
}

@end
