// Copyright (c) Microsoft Corporation.  All Rights Reserved.  Licensed under the MIT License.  See License in the project root for license information.



@class MSGraphTimeSlot, MSGraphAttendeeAvailability, MSGraphLocation; 

#import "MSGraphFreeBusyStatus.h"


#import <MSGraphCoreSDK/MSObject.h>

@interface MSGraphMeetingTimeSuggestion : MSObject

@property (nullable, nonatomic, setter=setMeetingTimeSlot:, getter=meetingTimeSlot) MSGraphTimeSlot* meetingTimeSlot;
@property (nonatomic, setter=setConfidence:, getter=confidence) double confidence;
@property (nullable, nonatomic, setter=setOrganizerAvailability:, getter=organizerAvailability) MSGraphFreeBusyStatus* organizerAvailability;
@property (nullable, nonatomic, setter=setAttendeeAvailability:, getter=attendeeAvailability) NSArray* attendeeAvailability;
@property (nullable, nonatomic, setter=setLocations:, getter=locations) NSArray* locations;
@property (nullable, nonatomic, setter=setSuggestionReason:, getter=suggestionReason) NSString* suggestionReason;

@end
