//
// Copyright (c) Microsoft Corporation. All Rights Reserved. Licensed under the MIT License. See License in the project root for license information.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef void(^MSAuthenticationCompletion)(NSMutableURLRequest *request, NSError *error);

/**
 The `MSAuthenticationProvider` is a protocol that is used to inject authentication into the MSGraphClient.
 It should handle all initial authentication, refreshing, and appending authentication headers to http requests.
 */
@protocol MSAuthenticationProvider <NSObject>

/**
 Appends the proper authentication headers to the given request.
 @param request The request to append headers to.
 @param completionHandler The completion handler to be called when the auth headers have been appended.
 error should be non nil if there was no error, and should contain any error(s) that occurred.
 */
- (void) appendAuthenticationHeaders:(NSMutableURLRequest *)request completion:(MSAuthenticationCompletion)completionHandler;

@end
