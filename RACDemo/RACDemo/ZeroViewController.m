//
//  ZeroViewController.m
//  RACDemo
//
//  Created by Windy on 2017/6/30.
//  Copyright © 2017年 Windy. All rights reserved.
//

#import "ZeroViewController.h"
#import <ReactiveCocoa/ReactiveCocoa.h>

@interface ZeroViewController ()

@property (weak, nonatomic) IBOutlet UITextField *userNameTextField;

@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;

@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
@end

@implementation ZeroViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    RACSignal *validUsernameSignal =
    [self.userNameTextField.rac_textSignal
     map:^id(NSString *text) {
         return @([self isValidUsername:text]);
     }];
    RACSignal *validPasswordSignal =
    [self.passwordTextField.rac_textSignal
     map:^id(NSString *text) {
         return @([self isValidPassword:text]);
     }];
   // 可以看到，上面的代码对每个输入框的rac_textSignal应用了一个map转换。输出是一个用NSNumber封装的布尔值。
  /*  下一步是转换这些信号，从而能为输入框设置不同的背景颜色。基本上就是，你订阅这些信号，然后用接收到的值来更新输入框的背景颜色。下面有一种方法：*/
    
//    [[validPasswordSignal
//      map:^id(NSNumber *passwordValid){
//          return[passwordValid boolValue] ? [UIColor clearColor]:[UIColor yellowColor];
//      }]
//     subscribeNext:^(UIColor *color){
//         self.passwordTextField.backgroundColor = color;
//     }];
   // （不要使用这段代码，下面有一种更好的写法！）
//    从概念上来说，就是把之前信号的输出应用到输入框的backgroundColor属性上。但是上面的用法不是很好。
   // 幸运的是，ReactiveCocoa提供了一个宏来更好的完成上面的事情。把下面的代码直接加到viewDidLoad中两个信号的代码后面：
    
    RAC(self.passwordTextField, backgroundColor) =
    [validPasswordSignal
     map:^id(NSNumber *passwordValid){
         return[passwordValid boolValue] ? [UIColor clearColor]:[UIColor yellowColor];
     }];
    
    RAC(self.userNameTextField, backgroundColor) =
    [validUsernameSignal
     map:^id(NSNumber *passwordValid){
         return[passwordValid boolValue] ? [UIColor clearColor]:[UIColor yellowColor];
     }];
    
    
    
   /* 目前在应用中，登录按钮只有当用户名和密码输入框的输入都有效时才工作。现在要把这里改成响应式的。
    现在的代码中已经有可以产生用户名和密码输入框是否有效的信号了——validUsernameSignal和validPasswordSignal了。现在需要做的就是聚合这两个信号来决定登录按钮是否可用。*/
    RACSignal *signUpActiveSignal =
    [RACSignal combineLatest:@[validUsernameSignal, validPasswordSignal]
                      reduce:^id(NSNumber*usernameValid, NSNumber *passwordValid){
                          return @([usernameValid boolValue]&&[passwordValid boolValue]);
                      }];
 /*  上面的代码使用combineLatest:reduce:方法把validUsernameSignal和validPasswordSignal产生的最新的值聚合在一起，并生成一个新的信号。每次这两个源信号的任何一个产生新值时，reduce block都会执行，block的返回值会发给下一个信号。*/
 /*   注意：RACsignal的这个方法可以聚合任意数量的信号，reduce block的参数和每个源信号相关。ReactiveCocoa有一个工具类RACBlockTrampoline，它在内部处理reduce block的可变参数。实际上在ReactiveCocoa的实现中有很多隐藏的技巧，值得你去看看。*/
    
  //  现在已经有了合适的信号，把下面的代码添加到viewDidLoad的末尾。这会把信号和按钮的enabled属性绑定
    [signUpActiveSignal subscribeNext:^(NSNumber*signupActive){
        self.loginBtn.enabled =[signupActive boolValue];
    }];
  /* 分割——信号可以有很多subscriber，也就是作为很多后续步骤的源。注意上图中那个用来表示用户名和密码有效性的布尔信号，它被分割成多个，用于不同的地方。
    聚合——多个信号可以聚合成一个新的信号，在上面的例子中，两个布尔信号聚合成了一个。实际上你可以聚合并产生任何类型的信号。
    这些改动的结果就是，代码中没有用来表示两个输入框有效状态的私有属性了。这就是用响应式编程的一个关键区别，你不需要使用实例变量来追踪瞬时状态。*/
    
    
    [[self.loginBtn
      rac_signalForControlEvents:UIControlEventTouchUpInside]
     subscribeNext:^(id x) {
         NSLog(@"登录------- clicked");
     }];
    
  /*  上面的代码从按钮的UIControlEventTouchUpInside事件创建了一个信号，然后添加了一个订阅，在每次事件发生时都会输出log。
    编译运行，确保的确有log输出。按钮只在用户名和密码框输入有效时可用，所以在点击按钮前需要在两个文本框中输入一些内容。*/
    
    
}

- (BOOL)isValidUsername:(NSString *)username {
    return username.length > 3;
}

- (BOOL)isValidPassword:(NSString *)password {
    return password.length > 3;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
