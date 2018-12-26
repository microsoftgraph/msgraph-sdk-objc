// Copyright (c) Microsoft Corporation.  All Rights Reserved.  Licensed under the MIT License.  See License in the project root for license information.





#import <MSGraphCoreSDK/MSObject.h>

@interface MSGraphIosDeviceType : MSObject

@property (nonatomic, setter=setIPad:, getter=iPad) BOOL iPad;
@property (nonatomic, setter=setIPhoneAndIPod:, getter=iPhoneAndIPod) BOOL iPhoneAndIPod;

@end