// Copyright (c) Microsoft Corporation.  All Rights Reserved.  Licensed under the MIT License.  See License in the project root for license information.



#import <UIKit/UiKit.h>
#import "MSGraphSelectionLikelihoodInfo.h"


#import <MSGraphCoreSDK/MSObject.h>

@interface MSGraphScoredEmailAddress : MSObject

@property (nullable, nonatomic, setter=setAddress:, getter=address) NSString* address;
@property (nonatomic, setter=setRelevanceScore:, getter=relevanceScore) CGFloat relevanceScore;
@property (nullable, nonatomic, setter=setSelectionLikelihood:, getter=selectionLikelihood) MSGraphSelectionLikelihoodInfo* selectionLikelihood;
@property (nullable, nonatomic, setter=setItemId:, getter=itemId) NSString* itemId;

@end
