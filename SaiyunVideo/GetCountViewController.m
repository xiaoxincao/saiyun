//
//  GetCountViewController.m
//  SaiyunVideo
//
//  Created by cying on 16/4/6.
//  Copyright © 2016年 cying. All rights reserved.
//

#import "GetCountViewController.h"

@interface GetCountViewController ()<UIGestureRecognizerDelegate>


@end

@implementation GetCountViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self setNavigation];
    [self initGester];
}


- (void)setNavigation
{
    self.title = @"忘记密码";
    //设置导航栏字体及颜色
    [self.navigationController.navigationBar setTitleTextAttributes:
     
     @{NSFontAttributeName:[UIFont systemFontOfSize:17],
       
       NSForegroundColorAttributeName:[UIColor whiteColor]}];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    //设置导航栏背景颜色
    self.navigationController.navigationBar.barTintColor = NavColor;

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)initGester{
    //添加手势，点击屏幕其他区域关闭键盘的操作
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hidenKeyboard)];
    gesture.numberOfTapsRequired = 1;
    gesture.delegate = self;
    [self.view addGestureRecognizer:gesture];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if (![self.phonetext isFirstResponder] && ![self.Verificationcode isFirstResponder]&& ![self.codetext isFirstResponder]&& ![self.againcodetext isFirstResponder]) {
        return NO;
    }
    return YES;
}
- (void)hidenKeyboard
{
    [self.phonetext resignFirstResponder];
    [self.Verificationcode resignFirstResponder];
    [self.codetext resignFirstResponder];
    [self.againcodetext resignFirstResponder];
}


//修改密码完成按钮
- (IBAction)finishBtn:(id)sender {
    NSDictionary *dict = @{@"phone_no":self.phonetext.text,@"checkCode":self.Verificationcode.text,@"userpass":self.codetext.text};
    [[NetworkSingleton sharedManager]postResultWithParameter:dict url:UpCode successBlock:^(id responseBody) {
        NSLog(@"修改是否成功--%@",responseBody);
    } failureBlock:^(NSString *error) {
        
    }];
}

//获取验证码按钮
- (IBAction)getcodeBtn:(JKCountDownButton *)sender {
    
    sender.enabled = NO;
    [sender startWithSecond:60];
    [sender didChange:^NSString *(JKCountDownButton *countDownButton,int second) {
        NSString *title = [NSString stringWithFormat:@"剩余%d秒",second];
        return title;
    }];
    [sender didFinished:^NSString *(JKCountDownButton *countDownButton, int second) {
        countDownButton.enabled = YES;
        return @"点击重新获取";
    }];
    NSDictionary *phonenum = @{@"phone_no":self.phonetext.text};
    [[NetworkSingleton sharedManager]postResultWithParameter:phonenum url:UpPhonenum successBlock:^(id responseBody) {
        NSLog(@"----验证码----%@",responseBody[@"msg"]);
        if ([responseBody[@"success"] isEqual:@0]) {
            [[Tool SharedInstance]showtoast:responseBody[@"msg"]];
        }else{
            //self.node = responseBody[@"result"];
        }
        
    } failureBlock:^(NSString *error) {
        
    }];
}
@end
