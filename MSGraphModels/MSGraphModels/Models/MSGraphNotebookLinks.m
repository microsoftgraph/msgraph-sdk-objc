// Copyright (c) Microsoft Corporation.  All Rights Reserved.  Licensed under the MIT License.  See License in the project root for license information.



#import <MSGraphCoreSDK/NSDate+MSSerialization.h>

#import "MSGraphModels.h"

@interface MSObject()

@property (strong, nonatomic) NSMutableDictionary *dictionary;

@end

@interface MSGraphNotebookLinks()
{
    MSGraphExternalLink* _oneNoteClientUrl;
    MSGraphExternalLink* _oneNoteWebUrl;
}
@end

@implementation MSGraphNotebookLinks

- (MSGraphExternalLink*) oneNoteClientUrl
{
    if(!_oneNoteClientUrl){
        _oneNoteClientUrl = [[MSGraphExternalLink alloc] initWithDictionary: self.dictionary[@"oneNoteClientUrl"]];
    }
    return _oneNoteClientUrl;
}

- (void) setOneNoteClientUrl: (MSGraphExternalLink*) val
{
    _oneNoteClientUrl = val;
    self.dictionary[@"oneNoteClientUrl"] = val;
}

- (MSGraphExternalLink*) oneNoteWebUrl
{
    if(!_oneNoteWebUrl){
        _oneNoteWebUrl = [[MSGraphExternalLink alloc] initWithDictionary: self.dictionary[@"oneNoteWebUrl"]];
    }
    return _oneNoteWebUrl;
}

- (void) setOneNoteWebUrl: (MSGraphExternalLink*) val
{
    _oneNoteWebUrl = val;
    self.dictionary[@"oneNoteWebUrl"] = val;
}

@end