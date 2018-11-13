//
//  ViewController.m
//  RACDemo
//
//  Created by Windy on 2017/6/30.
//  Copyright © 2017年 Windy. All rights reserved.
//

#import "ViewController.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "TwoViewController.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UITextField *useNameTextField;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.useNameTextField.rac_textSignal subscribeNext:^(id x){
        NSLog(@"%@", x);
    }];
    
    
    
    [[self.useNameTextField.rac_textSignal
      filter:^BOOL(id value){
          NSString*text = value;
          return text.length > 3;
      }]
     subscribeNext:^(id x){
         NSLog(@"%@-----------------", x);
     }];
//    编译运行，在text field只能怪输入几个字，你会发现只有当输入超过3个字符时才会有log。
//    刚才所创建的只是一个很简单的管道。这就是响应式编程的本质，根据数据流来表达应用的功能。
    
  //方式二
//    你可以像下面那样调整一下代码来展示每一步的操作。
    RACSignal *usernameSourceSignal =
    self.useNameTextField.rac_textSignal;
    
    RACSignal *filteredUsername = [usernameSourceSignal
                                  filter:^BOOL(id value){
                                      NSString*text = value;
                                      return text.length > 3;
                                  }];
    
    [filteredUsername subscribeNext:^(id x){
        NSLog(@"换种方式输出----------%@", x);
    }];
    
 /*   RACSignal的每个操作都会返回一个RACsignal，这在术语上叫做连贯接口（fluent interface）。这个功能可以让你直接构建管道，而不用每一步都使用本地变量。
    注意：ReactiveCocoa大量使用block。如果你是block新手，你可能想看看Apple官方的block编程指南。如果你熟悉block，但是觉得block的语法有些奇怪和难记，你可能会想看看这个有趣又实用的网页f*****gblocksyntax.com。*/
    
//    类型转换
//    如果你之前把代码分成了多个步骤，现在再把它改回来吧。。。。。。。。
    
    [[self.useNameTextField.rac_textSignal
      filter:^BOOL(id value){
          NSString*text = value; // implicit cast
          return text.length > 3;
      }]
     subscribeNext:^(id x){
         NSLog(@"类型转换写法-----------%@", x);
     }];
    
   /* 在上面的代码中，注释部分标记了将id隐式转换为NSString，这看起来不是很好看。幸运的是，传入block的值肯定是个NSString，所以你可以直接修改参数类型，把代码更新成下面的这样的： */
    [[self.useNameTextField.rac_textSignal
      filter:^BOOL(NSString*text){
          return text.length > 3;
      }]
     subscribeNext:^(id x){
         NSLog(@"最终版写法----------------%@", x);
     }];
    
    
    
    
    [[[self.useNameTextField.rac_textSignal
       map:^id(NSString*text){
           return @(text.length);
       }]
      filter:^BOOL(NSNumber*length){
          return[length integerValue] > 3;
      }]
     subscribeNext:^(id x){
         NSLog(@"输出字符串长度-----------------%@", x);
     }];
   /* 新加的map操作通过block改变了事件的数据。map从上一个next事件接收数据，通过执行block把返回值传给下一个next事件。在上面的代码中，map以NSString为输入，取字符串的长度，返回一个NSNumber。*/
    
   /* 能看到map操作之后的步骤收到的都是NSNumber实例。你可以使用map操作来把接收的数据转换成想要的类型，只要它是个对象。
    注意：在上面的例子中text.length返回一个NSUInteger，是一个基本类型。为了将它作为事件的内容，NSUInteger必须被封装。幸运的是Objective-C literal syntax提供了一种简单的方法来封装——@ (text.length)。*/
    
    
    
    
    
    
    // RACSignal使用步骤：
    // 1.创建信号 + (RACSignal *)createSignal:(RACDisposable * (^)(id<RACSubscriber> subscriber))didSubscribe
    // 2.订阅信号,才会激活信号. - (RACDisposable *)subscribeNext:(void (^)(id x))nextBlock
    // 3.发送信号 - (void)sendNext:(id)value
    
    
    // RACSignal底层实现：
    // 1.创建信号，首先把didSubscribe保存到信号中，还不会触发。
    // 2.当信号被订阅，也就是调用signal的subscribeNext:nextBlock
    // 2.2 subscribeNext内部会创建订阅者subscriber，并且把nextBlock保存到subscriber中。
    // 2.1 subscribeNext内部会调用siganl的didSubscribe
    // 3.siganl的didSubscribe中调用[subscriber sendNext:@1];
    // 3.1 sendNext底层其实就是执行subscriber的nextBlock
    
//    // 1.创建信号
//    RACSignal *siganl = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
//        
//        // block调用时刻：每当有订阅者订阅信号，就会调用block。
//        
//        // 2.发送信号
//        [subscriber sendNext:@1];
//        
//        // 如果不在发送数据，最好发送信号完成，内部会自动调用[RACDisposable disposable]取消订阅信号。
//        [subscriber sendCompleted];
//        
//        return [RACDisposable disposableWithBlock:^{
//            
//            // block调用时刻：当信号发送完成或者发送错误，就会自动执行这个block,取消订阅信号。
//            
//            // 执行完Block后，当前信号就不在被订阅了。
//            
//            NSLog(@"信号被销毁");
//            
//        }];
//    }];
//    
//    // 3.订阅信号,才会激活信号.
//    [siganl subscribeNext:^(id x) {
//        // block调用时刻：每当有信号发出数据，就会调用block.
//        NSLog(@"接收到数据:%@",x);
//    }];
    
}

- (IBAction)clickAction:(UIButton *)sender {
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    // 创建第二个控制器
    TwoViewController *twoVc= [storyboard instantiateViewControllerWithIdentifier:@"Two"];
    
    // 设置代理信号
    twoVc.delegateSignal = [RACSubject subject];
    
    // 订阅代理信号
    [twoVc.delegateSignal subscribeNext:^(id x) {
        
        NSLog(@"点击了通知按钮------%@", (NSString *)x);
    }];
    
    // 跳转到第二个控制器
    [self.navigationController pushViewController:twoVc animated:YES];
    
    
}
    
    
- (IBAction)showMessage:(UIButton *)sender {
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"" message:@"Alert" delegate:nil cancelButtonTitle:@"YES" otherButtonTitles:@"NO", nil];
    [[alertView rac_buttonClickedSignal] subscribeNext:^(NSNumber *indexNumber) {
        if ([indexNumber intValue] == 1) {
            NSLog(@"you touched NO");
        } else {
            NSLog(@"you touched YES");
        }
    }];
    [alertView show];
}
    
/*还有一个很常用的category就是UIButton+RACCommandSupport.h，它提供了一个property：rac_command，就是当button被按下时会执行的一个命令，命令被执行完后可以返回一个signal，有了signal就有了灵活性。比如点击投票按钮，先判断一下有没有登录，如果有就发HTTP请求，没有就弹出登陆框，可以这么实现。*/
  /*  voteButton.rac_command = [[RACCommand alloc] initWithEnabled:self.viewModel.voteCommand.enabled signalBlock:^RACSignal *(id input) {
        // Assume that we're logged in at first. We'll replace this signal later if not.
        RACSignal *authSignal = [RACSignal empty];
        
        if ([[PXRequest apiHelper] authMode] == PXAPIHelperModeNoAuth) {
            // Not logged in. Replace signal.
            authSignal = [[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
                @strongify(self);
                
                FRPLoginViewController *viewController = [[FRPLoginViewController alloc] initWithNibName:@"FRPLoginViewController" bundle:nil];
                UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:viewController];
                
                [self presentViewController:navigationController animated:YES completion:^{
                    [subscriber sendCompleted];
                }];
                
                return nil;
            }]];
        }
        
        return [authSignal then:^RACSignal *{
            @strongify(self);
            return [[self.viewModel.voteCommand execute:nil] ignoreValues];
        }];
    }];
    [voteButton.rac_command.errors subscribeNext:^(id x) {
        [x subscribeNext:^(NSError *error) {
            [SVProgressHUD showErrorWithStatus:[error localizedDescription]];
        }];
    }];
    */
    
    
    
    
    




@end
