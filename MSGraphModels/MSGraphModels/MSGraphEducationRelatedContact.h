// Copyright (c) Microsoft Corporation.  All Rights Reserved.  Licensed under the MIT License.  See License in the project root for license information.



#import "MSGraphEducationContactRelationship.h"


#import "MSObject.h"

@interface MSGraphEducationRelatedContact : MSObject

@property (nullable, nonatomic, setter=setEducationRelatedContactId:, getter=educationRelatedContactId) NSString* educationRelatedContactId;
@property (nonnull, nonatomic, setter=setDisplayName:, getter=displayName) NSString* displayName;
@property (nullable, nonatomic, setter=setEmailAddress:, getter=emailAddress) NSString* emailAddress;
@property (nullable, nonatomic, setter=setMobilePhone:, getter=mobilePhone) NSString* mobilePhone;
@property (nonnull, nonatomic, setter=setRelationship:, getter=relationship) MSGraphEducationContactRelationship* relationship;
@property (nonatomic, setter=setAccessConsent:, getter=accessConsent) BOOL accessConsent;

@end
