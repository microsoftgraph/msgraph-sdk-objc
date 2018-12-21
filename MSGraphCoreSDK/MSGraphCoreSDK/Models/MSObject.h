//
//  MSObject.h
//  MSGraphPOCSDK
//
//  Created by Vikas Dadheech on 26/07/18.
//  Copyright © 2018 Vikas Dadheech. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MSObject : NSObject

/**
 Creates an MSObject with the given dictionary.
 @param dictionary The dictionary representation of the object.
 @warning This method will return nil if the dictionary is nil.
 */
- (instancetype)initWithDictionary:(NSDictionary*)dictionary;

-(instancetype)initWithData:(NSData *)data;

/**
 Creates a dictionary from the given item.
 @return dictionary Representation for the given item.
 */
- (NSDictionary*)dictionaryFromItem;

- (NSData *)serializedData;


@end
