// Copyright (c) Microsoft Corporation.  All Rights Reserved.  Licensed under the MIT License.  See License in the project root for license information.



#import "MSGraphEducationContactRelationship.h"

@interface MSGraphEducationContactRelationship () {
    MSGraphEducationContactRelationshipValue _enumValue;
}
@property (nonatomic, readwrite) MSGraphEducationContactRelationshipValue enumValue;
@end

@implementation MSGraphEducationContactRelationship

+ (MSGraphEducationContactRelationship*) parent {
    static MSGraphEducationContactRelationship *_parent;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _parent = [[MSGraphEducationContactRelationship alloc] init];
        _parent.enumValue = MSGraphEducationContactRelationshipParent;
    });
    return _parent;
}
+ (MSGraphEducationContactRelationship*) relative {
    static MSGraphEducationContactRelationship *_relative;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _relative = [[MSGraphEducationContactRelationship alloc] init];
        _relative.enumValue = MSGraphEducationContactRelationshipRelative;
    });
    return _relative;
}
+ (MSGraphEducationContactRelationship*) aide {
    static MSGraphEducationContactRelationship *_aide;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _aide = [[MSGraphEducationContactRelationship alloc] init];
        _aide.enumValue = MSGraphEducationContactRelationshipAide;
    });
    return _aide;
}
+ (MSGraphEducationContactRelationship*) doctor {
    static MSGraphEducationContactRelationship *_doctor;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _doctor = [[MSGraphEducationContactRelationship alloc] init];
        _doctor.enumValue = MSGraphEducationContactRelationshipDoctor;
    });
    return _doctor;
}
+ (MSGraphEducationContactRelationship*) guardian {
    static MSGraphEducationContactRelationship *_guardian;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _guardian = [[MSGraphEducationContactRelationship alloc] init];
        _guardian.enumValue = MSGraphEducationContactRelationshipGuardian;
    });
    return _guardian;
}
+ (MSGraphEducationContactRelationship*) child {
    static MSGraphEducationContactRelationship *_child;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _child = [[MSGraphEducationContactRelationship alloc] init];
        _child.enumValue = MSGraphEducationContactRelationshipChild;
    });
    return _child;
}
+ (MSGraphEducationContactRelationship*) other {
    static MSGraphEducationContactRelationship *_other;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _other = [[MSGraphEducationContactRelationship alloc] init];
        _other.enumValue = MSGraphEducationContactRelationshipOther;
    });
    return _other;
}
+ (MSGraphEducationContactRelationship*) unknownFutureValue {
    static MSGraphEducationContactRelationship *_unknownFutureValue;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _unknownFutureValue = [[MSGraphEducationContactRelationship alloc] init];
        _unknownFutureValue.enumValue = MSGraphEducationContactRelationshipUnknownFutureValue;
    });
    return _unknownFutureValue;
}

+ (MSGraphEducationContactRelationship*) UnknownEnumValue {
    static MSGraphEducationContactRelationship *_unknownValue;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _unknownValue = [[MSGraphEducationContactRelationship alloc] init];
        _unknownValue.enumValue = MSGraphEducationContactRelationshipEndOfEnum;
    });
    return _unknownValue;
}


+ (MSGraphEducationContactRelationship*) educationContactRelationshipWithEnumValue:(MSGraphEducationContactRelationshipValue)val {

    switch(val)
    {
        case MSGraphEducationContactRelationshipParent:
            return [MSGraphEducationContactRelationship parent];
        case MSGraphEducationContactRelationshipRelative:
            return [MSGraphEducationContactRelationship relative];
        case MSGraphEducationContactRelationshipAide:
            return [MSGraphEducationContactRelationship aide];
        case MSGraphEducationContactRelationshipDoctor:
            return [MSGraphEducationContactRelationship doctor];
        case MSGraphEducationContactRelationshipGuardian:
            return [MSGraphEducationContactRelationship guardian];
        case MSGraphEducationContactRelationshipChild:
            return [MSGraphEducationContactRelationship child];
        case MSGraphEducationContactRelationshipOther:
            return [MSGraphEducationContactRelationship other];
        case MSGraphEducationContactRelationshipUnknownFutureValue:
            return [MSGraphEducationContactRelationship unknownFutureValue];
        case MSGraphEducationContactRelationshipEndOfEnum:
        default:
            return [MSGraphEducationContactRelationship UnknownEnumValue];
    }

    return nil;
}

- (NSString*) ms_toString {

    switch(self.enumValue)
    {
        case MSGraphEducationContactRelationshipParent:
            return @"parent";
        case MSGraphEducationContactRelationshipRelative:
            return @"relative";
        case MSGraphEducationContactRelationshipAide:
            return @"aide";
        case MSGraphEducationContactRelationshipDoctor:
            return @"doctor";
        case MSGraphEducationContactRelationshipGuardian:
            return @"guardian";
        case MSGraphEducationContactRelationshipChild:
            return @"child";
        case MSGraphEducationContactRelationshipOther:
            return @"other";
        case MSGraphEducationContactRelationshipUnknownFutureValue:
            return @"unknownFutureValue";
        case MSGraphEducationContactRelationshipEndOfEnum:
        default:
            return nil;
    }

    return nil;
}

- (MSGraphEducationContactRelationshipValue) enumValue {
    return _enumValue;
}

@end

@implementation NSString (MSGraphEducationContactRelationship)

- (MSGraphEducationContactRelationship*) toMSGraphEducationContactRelationship{

    if([self isEqualToString:@"parent"])
    {
          return [MSGraphEducationContactRelationship parent];
    }
    else if([self isEqualToString:@"relative"])
    {
          return [MSGraphEducationContactRelationship relative];
    }
    else if([self isEqualToString:@"aide"])
    {
          return [MSGraphEducationContactRelationship aide];
    }
    else if([self isEqualToString:@"doctor"])
    {
          return [MSGraphEducationContactRelationship doctor];
    }
    else if([self isEqualToString:@"guardian"])
    {
          return [MSGraphEducationContactRelationship guardian];
    }
    else if([self isEqualToString:@"child"])
    {
          return [MSGraphEducationContactRelationship child];
    }
    else if([self isEqualToString:@"other"])
    {
          return [MSGraphEducationContactRelationship other];
    }
    else if([self isEqualToString:@"unknownFutureValue"])
    {
          return [MSGraphEducationContactRelationship unknownFutureValue];
    }
    else {
        return [MSGraphEducationContactRelationship UnknownEnumValue];
    }
}

@end
