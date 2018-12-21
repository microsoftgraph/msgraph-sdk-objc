// Copyright (c) Microsoft Corporation.  All Rights Reserved.  Licensed under the MIT License.  See License in the project root for license information.

#import "MSCollection.h"
#import "NSDate+MSSerialization.h"

@implementation MSCollection

-(instancetype)initWithArray:(NSArray *)array
                    nextLink:(NSString *)nextLink
              additionalData:(NSDictionary *)additionalData
{
    self = [super init];
    if (self){
        _value = array;
        _nextLink = [NSURL URLWithString:nextLink];
        _additionalData = additionalData;
    }
    return self;
}

- (instancetype)initWithData:(NSData *)data
{
    self = [super initWithData:data];
    if(self){
        self.value = [[self dictionaryFromItem] objectForKey:@"value"];
        self.nextLink = [[self dictionaryFromItem] objectForKey:@"@odata.nextLink"];
    }
    return self;
}

- (instancetype)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super initWithDictionary:dictionary];
    if(self)
    {
        self.value = [dictionary objectForKey:@"values"];
        self.nextLink = [dictionary objectForKey:@"@odata.nextLink"];
    }
    return self;
}

//- (NSArray *) arrayFromItem
//{
//    NSMutableArray *retArray = [NSMutableArray arrayWithCapacity:[self.value count]];
//    [self.value enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop){
//        retArray[idx] = [MSObject getNSJsonSerializationCompatibleValue:obj];
//    }];
//    return retArray;
//}

@end
