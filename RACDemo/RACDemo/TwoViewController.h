//
//  TwoViewController.h
//  RACDemo
//
//  Created by Windy on 2017/6/30.
//  Copyright © 2017年 Windy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ReactiveCocoa/ReactiveCocoa.h>

@interface TwoViewController : UIViewController

@property (nonatomic, strong) RACSubject *delegateSignal; //添加一个RACSubject代替代理。

@end
