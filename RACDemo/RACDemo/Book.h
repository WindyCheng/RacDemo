//
//  Book.h
//  RACDemo
//
//  Created by Windy on 2017/6/30.
//  Copyright © 2017年 Windy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Book : NSObject

@property(nonatomic, copy)NSString *title;

@property(nonatomic, copy)NSString *subtitle;

-(instancetype)initWithDict:(NSDictionary *)dict;
+(instancetype)bookWithDict:(NSDictionary *)dict;


@end
