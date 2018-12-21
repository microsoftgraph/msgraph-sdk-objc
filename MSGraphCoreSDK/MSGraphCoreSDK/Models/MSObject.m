//
//  MSObject.m
//  MSGraphPOCSDK
//
//  Created by Vikas Dadheech on 26/07/18.
//  Copyright © 2018 Vikas Dadheech. All rights reserved.
//

#import "MSObject.h"

@interface MSObject()

@property NSMutableDictionary *dictionary;

@end

@implementation MSObject


- (instancetype)init {
   return [self initWithDictionary:[NSMutableDictionary new]];
}

-(instancetype)initWithData:(NSData *)data{
    self = [super init];
    if(self){
        self.dictionary = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
    }
    return self;
}

-(instancetype)initWithDictionary:(NSDictionary *)dictionary{
    self = [super init];
    if(self){
        self.dictionary = [NSMutableDictionary dictionaryWithDictionary:dictionary];
    }
    return self;
}

-(NSMutableDictionary *)dictionaryFromItem{
    return [self.dictionary mutableCopy];
}

- (NSData *)serializedData{
    return [NSJSONSerialization dataWithJSONObject:self.dictionary options:kNilOptions error:nil];
}
@end
