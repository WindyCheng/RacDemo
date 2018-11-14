//
//  RequestViewModel.h
//  RACDemo
//
//  Created by Windy on 2017/6/30.
//  Copyright © 2017年 Windy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ReactiveCocoa/ReactiveCocoa.h>

@interface RequestViewModel : NSObject<UITableViewDataSource>

// 请求命令
@property (nonatomic, strong, readonly) RACCommand *reuqesCommand;

// 请求命令
@property (nonatomic, strong) RACCommand *reuqesCommandFirst;

//模型数组
@property (nonatomic, strong) NSArray *models;

- (void)fetchFirstPage;

@end
