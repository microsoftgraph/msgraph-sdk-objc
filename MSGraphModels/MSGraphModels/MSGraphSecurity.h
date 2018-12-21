// Copyright (c) Microsoft Corporation.  All Rights Reserved.  Licensed under the MIT License.  See License in the project root for license information.


@class MSGraphAlert; 


#import "MSGraphEntity.h"

@interface MSGraphSecurity : MSGraphEntity

  @property (nullable, nonatomic, setter=setAlerts:, getter=alerts) NSArray* alerts;
  
@end
