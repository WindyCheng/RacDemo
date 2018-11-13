//
//  RedView.m
//  RACDemo
//
//  Created by Windy on 2017/6/30.
//  Copyright © 2017年 Windy. All rights reserved.
//

#import "RedView.h"

@implementation RedView

+ (RedView *)initWithNib
{
    RedView *view = [[NSBundle mainBundle] loadNibNamed:@"RedView" owner:self options:nil].lastObject;
    return view;
}


- (IBAction)click:(UIButton *)sender {
}

@end
