// Copyright (c) Microsoft Corporation.  All Rights Reserved.  Licensed under the MIT License.  See License in the project root for license information.



#include <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, MSGraphEducationContactRelationshipValue){

	MSGraphEducationContactRelationshipParent = 0,
	MSGraphEducationContactRelationshipRelative = 1,
	MSGraphEducationContactRelationshipAide = 2,
	MSGraphEducationContactRelationshipDoctor = 3,
	MSGraphEducationContactRelationshipGuardian = 4,
	MSGraphEducationContactRelationshipChild = 5,
	MSGraphEducationContactRelationshipOther = 6,
	MSGraphEducationContactRelationshipUnknownFutureValue = 7,
    MSGraphEducationContactRelationshipEndOfEnum
};

@interface MSGraphEducationContactRelationship : NSObject

+(MSGraphEducationContactRelationship*) parent;
+(MSGraphEducationContactRelationship*) relative;
+(MSGraphEducationContactRelationship*) aide;
+(MSGraphEducationContactRelationship*) doctor;
+(MSGraphEducationContactRelationship*) guardian;
+(MSGraphEducationContactRelationship*) child;
+(MSGraphEducationContactRelationship*) other;
+(MSGraphEducationContactRelationship*) unknownFutureValue;

+(MSGraphEducationContactRelationship*) UnknownEnumValue;

+(MSGraphEducationContactRelationship*) educationContactRelationshipWithEnumValue:(MSGraphEducationContactRelationshipValue)val;
-(NSString*) ms_toString;

@property (nonatomic, readonly) MSGraphEducationContactRelationshipValue enumValue;

@end


@interface NSString (MSGraphEducationContactRelationship)

- (MSGraphEducationContactRelationship*) toMSGraphEducationContactRelationship;

@end
