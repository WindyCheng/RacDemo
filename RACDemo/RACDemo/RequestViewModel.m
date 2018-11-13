//
//  RequestViewModel.m
//  RACDemo
//
//  Created by Windy on 2017/6/30.
//  Copyright © 2017年 Windy. All rights reserved.
//

#import "RequestViewModel.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "Book.h"
#import "AFNetWorking.h"

@implementation RequestViewModel

- (instancetype)init
{
    if (self = [super init]) {
        
        [self initialBind];
    }
    return self;
}


- (void)initialBind
{
    _reuqesCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        
        RACSignal *requestSignal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            
            
            NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
            parameters[@"q"] = @"基础";
            
            [[AFHTTPSessionManager manager] GET:@"https://api.douban.com/v2/book/search"
                                    parameters:parameters
                                      progress:nil
                                       success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                                           NSLog(@"%@",responseObject);
                                           // 请求成功调用
                                           // 把数据用信号传递出去
                                           
//                                           self.models = responseObject;
                                           [subscriber sendNext:responseObject];
                                           [subscriber sendCompleted];
                                      } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                                          // 请求失败调用
                                      }];
            
            return nil;
        }];
        
        // 在返回数据信号时，把数据中的字典映射成模型信号，传递出去
        return [requestSignal map:^id(NSDictionary *value) {
            NSMutableArray *dictArr = value[@"books"];
            // 字典转模型，遍历字典中的所有元素，全部映射成模型，并且生成数组
            NSArray *modelArr = [[dictArr.rac_sequence map:^id(id value) {
                
                return [Book bookWithDict:value];
                
            }] array];
            return modelArr;
        }];
    }];
    

    
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.models.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    
    Book *book = self.models[indexPath.row];
    cell.textLabel.text = book.title;
    cell.textLabel.textColor = [UIColor redColor];
    cell.detailTextLabel.textColor = [UIColor redColor];
    cell.detailTextLabel.text = book.subtitle;
    return cell;
}

@end
