//
// Copyright (c) Microsoft Corporation. All Rights Reserved. Licensed under the MIT License. See License in the project root for license information.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef void(^MSAuthenticationCompletion)(NSMutableURLRequest *request, NSError *error);

/**
 The `MSAuthenticationProvider` is a protocol that is used to inject authentication into the MSHTTPClient.
 It should handle all initial authentication, refreshing, and returning the access token.
 */
@protocol MSAuthenticationProvider <NSObject>

/**
 Gets the access token. This method should be implemented by a class which should provide the capability of providing the access token.
 @param completion The completion handler to be called when access token or an error can be returned.
 */

- (void) getAccessTokenWithCompletion:(void (^)(NSString *accessToken, NSError *error))completion;

@end
