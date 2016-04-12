//
//  RegisterViewController.m
//  CloudPlatform
//
//  Created by cying on 15/8/5.
//  Copyright (c) 2015年 cying. All rights reserved.
//

#import "RegisterViewController.h"
#import "LogInViewController.h"
#import "Tool.h"
#import "ClassifyModel.h"




@interface RegisterViewController ()<UIGestureRecognizerDelegate>

@property (nonatomic, readonly) UIButton *m_btnNaviRight;

@property (nonatomic, strong)NSMutableArray *resultarray;

@property (nonatomic, strong)NSString *Token;

@property (nonatomic, strong)NSString *node;

@property (nonatomic,copy)NSString *ticket;

@property (nonatomic,copy)NSString *keystr;

@end

@implementation RegisterViewController
@synthesize m_btnNaviRight = _btnNaviLeft;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initGester];
    
    self.title = @"注册";
    //设置导航栏背景颜色
    self.navigationController.navigationBar.barTintColor = NavColor;
    //设置导航栏字体及颜色
    [self.navigationController.navigationBar setTitleTextAttributes:
     
     @{NSFontAttributeName:[UIFont systemFontOfSize:17],
       
       NSForegroundColorAttributeName:[UIColor whiteColor]}];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    
    UIBarButtonItem *leftBtn = [[UIBarButtonItem alloc]initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(backClick)];
    self.navigationItem.leftBarButtonItem = leftBtn;
    self.navigationController.navigationBar.hidden = NO;
    [self getToken];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:YES];
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
}

- (void)backClick
{
    [self.navigationController popViewControllerAnimated:YES];
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
    if (![self.NameText isFirstResponder] && ![self.PhoneNumText isFirstResponder]&& ![self.RegPassWordText isFirstResponder]&& ![self.RegPassWordAgainText isFirstResponder]&& ![self.EmailText isFirstResponder]) {
        return NO;
    }
    return YES;
}

//- (void)returnOnKeyboard:(UITextField *)sender
//{
//    if (sender == self.NameText) {
//        [self.PhoneNumText becomeFirstResponder];
//    }
//    else if (sender == self.PhoneNumText) {
//        [self hidenKeyboard];
//    }
//}
//#pragma mark - 键盘操作
- (void)hidenKeyboard
{
    [self.NameText resignFirstResponder];
    [self.PhoneNumText resignFirstResponder];
    [self.RegPassWordText resignFirstResponder];
    [self.RegPassWordAgainText resignFirstResponder];
    [self.EmailText resignFirstResponder];
}

//判断手机号格式
- (BOOL)isMobile:(NSString *)num
{
    NSString * checkmobile = @"^1[3|4|5|7|8][0-9]\\d{8}$";
    
    NSPredicate * predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",checkmobile];
    if ([predicate evaluateWithObject:num])
    {
        return YES;
    }else{
        return NO;
    }
}

- (void)getToken
{
    [[NetworkSingleton sharedManager]postResultWithParameter:nil url:String_Register successBlock:^(id responseBody) {
        
        self.Token = responseBody[@"registerToken"];
        
    } failureBlock:^(NSString *error) {
        
    }];
}


#pragma mark -
#pragma mark - 注册按钮点击事件
//拉取验证码的按钮
- (IBAction)GetnodeBtn:(JKCountDownButton *)sender {
    //如果手机号没输入，提示需要输入手机号，密码提示需要输入密码
    if (_PhoneNumText.text.length < 11) {
        [[Tool SharedInstance]showtoast:@"请输入正确的手机号"];
        return;
    }
    if(_RegPassWordText.text.length < 6){
        [[Tool SharedInstance]showtoast:@"请输入不少于六位的密码"];
        return;
    }
    if (_RegPassWordAgainText.text.length == 0) {
        [[Tool SharedInstance]showtoast:@"请再次输入密码"];
        return;
    }
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
    NSDictionary *phonenum = @{@"phoneNumber":_PhoneNumText.text};
    [[NetworkSingleton sharedManager]postResultWithParameter:phonenum url:String_RegisterCode successBlock:^(id responseBody) {
        NSLog(@"----验证码----%@",responseBody[@"msg"]);
        if ([responseBody[@"success"] isEqual:@0]) {
            [[Tool SharedInstance]showtoast:responseBody[@"msg"]];
        }else{
            [[Tool SharedInstance]showtoast:responseBody[@"msg"]];
            self.node = responseBody[@"result"];
        }
        
    } failureBlock:^(NSString *error) {
        
    }];
}

- (IBAction)RegisterBtn:(id)sender {
    //账号密码为空时的提示
    if ([_NameText.text isEqualToString:@""])
    {
        [[Tool SharedInstance]showtoast:@"请输入昵称"];
        return;
    }
    if (_PhoneNumText.text.length < 11) {
        [[Tool SharedInstance]showtoast:@"请输入正确的手机号"];
        return;
    }
    if(_RegPassWordText.text.length < 6){
        [[Tool SharedInstance]showtoast:@"请输入不少于六位的密码"];
        return;
    }
    if (_RegPassWordAgainText.text.length == 0) {
        [[Tool SharedInstance]showtoast:@"请再次输入密码"];
        return;
    }
    if (![_RegPassWordText.text isEqualToString:_RegPassWordAgainText.text] ) {
        [[Tool SharedInstance]showtoast:@"请输入一致的密码"];
        return;
    }
    if ([_RegPassWordAgainText.text rangeOfString:@"[a-zA-Z0-9]+" options:NSRegularExpressionSearch].length < _RegPassWordAgainText.text.length)
    {
        [[Tool SharedInstance]showtoast:@"密码应为6-16位字母或数字，不包含其他字符"];
        return;
    }
    if (![self isMobile:_PhoneNumText.text]) {
        [[Tool SharedInstance]showtoast:@"手机号格式不对"];
        return;
    }

    NSDictionary *dict = @{@"name":_NameText.text,@"phoneNo":_PhoneNumText.text,@"userPass":_RegPassWordText.text,@"checkCode":_EmailText.text,@"registerToken":self.Token};
    [[NetworkSingleton sharedManager]postResultWithParameter:dict url:String_RegisterForApp successBlock:^(id responseBody) {
        NSLog(@"注册返回信息----%@--%@",responseBody[@"fail"],responseBody);
        if (responseBody[@"result"]) {
            NSDictionary *resultdict = responseBody[@"result"];
            NSInteger success = [[resultdict objectForKey:@"success"]integerValue];
            if (success == 1)
            {
                [[Tool SharedInstance]showtoast:@"注册成功"];
                [self gotologin];
            }
            else{
                [[Tool SharedInstance]showtoast:@"注册失败"];
            }
        }
        else
        {
            [[Tool SharedInstance]showtoast:responseBody[@"fail"]];
        }
    } failureBlock:^(NSString *error) {
        NSLog(@"错误%@",error);
    }];
}

- (void)gotologin
{
    
    [[NetworkSingleton sharedManager]postResultWithParameter:nil url:LoginAPI successBlock:^(id responseBody) {
        NSLog(@"--获取票据---%@",responseBody);
        self.keystr = responseBody[@"flowExecutionKey"];
        self.ticket = responseBody[@"loginTicket"];
        [self login:self.ticket andkey:self.keystr];
        
    } failureBlock:^(NSString *error) {
        NSLog(@"获取票据失败----%@",error);
    }];
}
- (void)login:(NSString *)tickt andkey:(NSString *)key
{
    NSDictionary *dict = @{@"username":_PhoneNumText.text,@"password":_RegPassWordText.text,@"lt":tickt,@"execution":key,@"_eventId":@"submit"};
    //3.请求
    [[NetworkSingleton sharedManager]postResultWithParameter:dict url:LoginAPI successBlock:^(id responseBody) {
        NSLog(@"登录----%@",responseBody);
        if([responseBody[@"errors"] isEqualToString: @""])
        {
            if ([responseBody[@"logined"]integerValue]==1) {
                [[Tool SharedInstance]showtoast:@"登陆成功"];
                [[NSUserDefaults standardUserDefaults] setBool:YES forKey:LogSuccess];
                [[NSUserDefaults standardUserDefaults]synchronize];
                [self saveCookies];
                self.navigationController.navigationBar.hidden = YES;
                [self.navigationController pushViewController:[AppDelegate appdelegate].drawerController animated:YES];
            }
            else
            {
                [[Tool SharedInstance]showtoast:@"登陆失败"];
            }
        }
        //erros有信息时提示
        else
            //if(responseBody[@"errors"]!=nil)
        {
            NSLog(@"====%@",responseBody[@"errors"]);
            [[Tool SharedInstance]showtoast:responseBody[@"errors"]];
        }
        
    } failureBlock:^(NSString *error) {
        NSLog(@"登录失败 -----%@",error);
    }];
    
}
- (void)saveCookies
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSArray *cookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies];
    NSData *cookiesData = [NSKeyedArchiver archivedDataWithRootObject: cookies];
    //存储归档后的cookie
    [userDefaults setObject: cookiesData forKey: @"cookie"];
    [userDefaults synchronize];
}

@end
