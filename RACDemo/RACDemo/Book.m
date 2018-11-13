//
//  Book.m
//  RACDemo
//
//  Created by Windy on 2017/6/30.
//  Copyright © 2017年 Windy. All rights reserved.
//

#import "Book.h"

@implementation Book


- (instancetype)initWithDict:(NSDictionary *)dict{
  if (self = [super init]) {
      
     [self setValuesForKeysWithDictionary:dict];
    }
  return self;
}

+(instancetype)bookWithDict:(NSDictionary *)dict{
    
    return [[self alloc] initWithDict:dict];
}

-(void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
}

@end
