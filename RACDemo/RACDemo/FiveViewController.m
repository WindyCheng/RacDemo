//
//  FiveViewController.m
//  RACDemo
//
//  Created by WindyCheng on 2018/11/14.
//  Copyright © 2018年 Windy. All rights reserved.
//

#import "FiveViewController.h"
#import "RequestViewModel.h"
#import "Book.h"
#import <ReactiveCocoa/ReactiveCocoa.h>


static NSString *const cellId = @"Cell";

@interface FiveViewController ()<UITableViewDataSource>

@property (nonatomic, weak) UITableView *tableView;

@property (nonatomic, strong) RequestViewModel *viewModel;

@end

@implementation FiveViewController


- (RequestViewModel *)viewModel
{
    if (_viewModel == nil) {
        _viewModel = [[RequestViewModel alloc] init];
    }
    return _viewModel;
}


- (void)viewDidLoad {
    [super viewDidLoad];
   
    UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.bounds];
    tableView.dataSource = self;
    [self.view addSubview:tableView];
    self.tableView = tableView;
    
    [self bindSignal];
    
    [self.viewModel fetchFirstPage];
}


- (void)bindSignal{
    @weakify(self);
    [self.viewModel.reuqesCommandFirst.executionSignals.switchToLatest  subscribeNext:^(id x) {
        @strongify(self);
        
//        self.viewModel.models = x;
        [self.tableView reloadData];
        
//        [weakSelf.table.mj_header endRefreshing];
//        [weakSelf.table.mj_footer endRefreshing];
//        
//        if (weakSelf.viewModel.isAllLoad) {
//            [weakSelf.table.mj_footer endRefreshingWithNoMoreData];
//        }else{
//            [weakSelf setLoadingFooter];
//        }
//        [weakSelf.table reloadData];
//        [weakSelf hideLoadFailInBaseController];
//        weakSelf.table.hidden = NO;
        
        
    }];
    
    [self.viewModel.reuqesCommandFirst.errors subscribeNext:^(id x) {
        //检查没有网络的情况，是否出现默认界面
        
        NSError *error = x;
//        [weakSelf showFailureMessage:error.domain];
//        [weakSelf.table.mj_header endRefreshing];
//        [weakSelf.table.mj_footer endRefreshing];
//
//
//        [weakSelf showLoadFailInBaseControllerWithLoadHandler:^{
//            [weakSelf hideLoadFailInBaseController];
//            weakSelf.viewModel.cellViewModels = nil;
//            weakSelf.table.hidden = NO;
//            [weakSelf.table reloadData];
//            [weakSelf.table.mj_header beginRefreshing];
//        }];
//        weakSelf.table.hidden = YES;
//        [weakSelf hideEmptyInBaseController];
        
    }];
    
    [RACObserve(self, viewModel.models) subscribeNext:^(id x) {
        
        NSArray *arr = x;
        if(arr.count == 0){
//            [weakSelf showEmptyInBaseController];
//            weakSelf.table.hidden = YES;
        }else{
//            [weakSelf hideEmptyInBaseController];
//            weakSelf.table.hidden = NO;
        }
    }];
}






#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.viewModel.models.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    
    Book *book = self.viewModel.models[indexPath.row];
    cell.textLabel.text = book.title;
    cell.textLabel.textColor = [UIColor redColor];
    cell.detailTextLabel.textColor = [UIColor redColor];
    cell.detailTextLabel.text = book.subtitle;
    return cell;
}



@end
