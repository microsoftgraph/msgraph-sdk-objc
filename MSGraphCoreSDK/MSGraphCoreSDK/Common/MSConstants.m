//
// Copyright (c) Microsoft Corporation. All Rights Reserved. Licensed under the MIT License. See License in the project root for license information.
//

#import "MSConstants.h"

NSString *const MSGraphBaseURL = @"https://graph.microsoft.com/v1.0";
NSString *const MSErrorDomain = @"com.microsoft.graph.errors";

NSString *const MSErrorTooManyRedirectsFormatString = @"More than %d redirects encountered while sending the request.";

NSString *const MSErrorLocationHeaderNotFoundString = @"There is no location header in the redirect response.";
NSString *const MSErrorOperationUnsuccessfulString = @"Operation was unsuccessful.";
