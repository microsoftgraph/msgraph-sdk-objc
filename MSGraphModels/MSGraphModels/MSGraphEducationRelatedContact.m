// Copyright (c) Microsoft Corporation.  All Rights Reserved.  Licensed under the MIT License.  See License in the project root for license information.



#import "NSDate+MSSerialization.h"

#import "MSGraphModels.h"

@interface MSObject()

@property (strong, nonatomic) NSMutableDictionary *dictionary;

@end

@interface MSGraphEducationRelatedContact()
{
    NSString* _educationRelatedContactId;
    NSString* _displayName;
    NSString* _emailAddress;
    NSString* _mobilePhone;
    MSGraphEducationContactRelationship* _relationship;
    BOOL _accessConsent;
}
@end

@implementation MSGraphEducationRelatedContact

- (NSString*) educationRelatedContactId
{
    if([[NSNull null] isEqual:self.dictionary[@"id"]])
    {
        return nil;
    }   
    return self.dictionary[@"id"];
}

- (void) setEducationRelatedContactId: (NSString*) val
{
    self.dictionary[@"id"] = val;
}

- (NSString*) displayName
{
    return self.dictionary[@"displayName"];
}

- (void) setDisplayName: (NSString*) val
{
    self.dictionary[@"displayName"] = val;
}

- (NSString*) emailAddress
{
    if([[NSNull null] isEqual:self.dictionary[@"emailAddress"]])
    {
        return nil;
    }   
    return self.dictionary[@"emailAddress"];
}

- (void) setEmailAddress: (NSString*) val
{
    self.dictionary[@"emailAddress"] = val;
}

- (NSString*) mobilePhone
{
    if([[NSNull null] isEqual:self.dictionary[@"mobilePhone"]])
    {
        return nil;
    }   
    return self.dictionary[@"mobilePhone"];
}

- (void) setMobilePhone: (NSString*) val
{
    self.dictionary[@"mobilePhone"] = val;
}

- (MSGraphEducationContactRelationship*) relationship
{
    if(!_relationship){
        _relationship = [self.dictionary[@"relationship"] toMSGraphEducationContactRelationship];
    }
    return _relationship;
}

- (void) setRelationship: (MSGraphEducationContactRelationship*) val
{
    _relationship = val;
    self.dictionary[@"relationship"] = val;
}

- (BOOL) accessConsent
{
    _accessConsent = [self.dictionary[@"accessConsent"] boolValue];
    return _accessConsent;
}

- (void) setAccessConsent: (BOOL) val
{
    _accessConsent = val;
    self.dictionary[@"accessConsent"] = @(val);
}

@end
