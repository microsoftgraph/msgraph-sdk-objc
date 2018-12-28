// Copyright (c) Microsoft Corporation.  All Rights Reserved.  Licensed under the MIT License.  See License in the project root for license information.

#import <Foundation/Foundation.h>

@interface MSObject : NSObject

/*
 Creates an MSObject with the given data.
 @param data The NSData instance from the response.
 @error If there are any errors during the conversion of data then it will be assigned to this.
 @warning This method will return nil if the data is nil.
 */
-(instancetype)initWithData:(NSData *)data error:(NSError **)error;;

/*
 Creates an MSObject with the given dictionary.
 @param dictionary The dictionary representation of the object.
 @warning This method will return nil if the dictionary is nil.
 */
- (instancetype)initWithDictionary:(NSDictionary*)dictionary;

/*
This method returns the underlying dictionary which is used to construct the model.
 @return The NSDictionary consisting of different properties and their values for the model.
 */
- (NSMutableDictionary*)getDictionary;

/*
 This method converts the internal dictionary to serialized data.
 @param error If there are any errors during the conversion of internal dictionary then it will be assigned to this.
 @return NSData representation of the internal dictionary,
 */
- (NSData *)getSerializedDataWithError:(NSError **)error;;


@end
