// Copyright (c) Microsoft Corporation.  All Rights Reserved.  Licensed under the MIT License.  See License in the project root for license information.

#import <MSGraphCoreSDK/MSObject.h>

/**
 An `MSCollection` object is a collection of Graph objects.
 @see MSObject
 */
@interface MSCollection : MSObject

/**
 An array of Graph objects.
 */
@property (strong, nonatomic) NSArray *value;

/**
 There may be more items in the collection available via paging. This is the url to the next page of the collection.
 */
@property (strong, nonatomic) NSURL *nextLink;

/**
 Any additional data returned from the collection request will be in this dictionary.
 */
@property (strong, nonatomic) NSDictionary *additionalData;

/**
 Creates an MSCollection with the response from the service.
 @param array The array of OneDrive objects.
 @param nextLink The link to the next page of items, if there is one.
 @param additionalData Any other data returned from the service.
 */
- (instancetype)initWithArray:(NSArray *)array
                     nextLink:(NSString *)nextLink
               additionalData:(NSDictionary *)additionalData;
//
///**
// Return an array with all values compatible with NSJsonSerialization
//*/
//- (NSArray *) arrayFromItem;

@end
