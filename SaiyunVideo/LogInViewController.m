//
//  LogInViewController.m
//  CloudPlatform
//
//  Created by cying on 15/8/5.
//  Copyright (c) 2015年 cying. All rights reserved.
//

#import "LogInViewController.h"
#import "RegisterViewController.h"
#import "Tool.h"
#import "PersonInfo.h"
#import "PersonTableViewController.h"
#import "MJExtension.h"
#import "AppDelegate.h"
#import "GetCountViewController.h"
#import "JKCountDownButton.h"


@interface LogInViewController ()<UIGestureRecognizerDelegate>

@property (nonatomic,assign)BOOL isremember;

@property (nonatomic,copy)NSString *ticket;

@property (nonatomic,copy)NSString *keystr;

@end

@implementation LogInViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupTextField];
    
    [self setupnavigation];
    
    [self initGester];
    
    BOOL save = [[NSUserDefaults standardUserDefaults]boolForKey:@"SaveCode"];
    NSString *account = [[NSUserDefaults standardUserDefaults]objectForKey:@"accounttext"];
    NSString *code = [[NSUserDefaults standardUserDefaults]objectForKey:@"passwordtext"];
    if (save) {
        [_rememberpro setBackgroundImage:[UIImage imageNamed:@"chose2"] forState:UIControlStateNormal];
        self.accountTextField.text = account;
        self.passwordTextField.text = code;
    }
    else{
        [_rememberpro setBackgroundImage:[UIImage imageNamed:@"chose1@3x"] forState:UIControlStateNormal];
    }

    [self clearuserdefault];
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
- (void)clearuserdefault
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults removeObjectForKey:@"cookie"];
}
#pragma mark -设置导航栏
- (void)setupnavigation{
    self.title = @"登录";
    //设置导航栏字体及颜色
    [self.navigationController.navigationBar setTitleTextAttributes:
     
     @{NSFontAttributeName:[UIFont systemFontOfSize:17],
       
       NSForegroundColorAttributeName:[UIColor whiteColor]}];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.hidden = NO;
    //设置导航栏背景颜色
    self.navigationController.navigationBar.barTintColor = NavColor;
    
    UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc]initWithTitle:@"注册" style:UIBarButtonItemStylePlain target:self action:@selector(Register)];
    self.navigationItem.rightBarButtonItem = rightBtn;
  
}


#pragma mark -关闭登录按钮
- (void)shutdown{
    //[self.navigationController popToRootViewControllerAnimated:YES];
    //[self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark -
#pragma mark -注册按钮
- (void)Register{
    NSLog(@"注册");
    RegisterViewController *rvc = [[RegisterViewController alloc]init];
    [self.navigationController pushViewController:rvc animated:YES];
    
}
#pragma mark - 设置textfield
- (void)setupTextField
{
    self.accountTextField.leftViewMode = UITextFieldViewModeAlways;
    self.accountTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    [self.accountTextField addTarget:self action:@selector(returnOnKeyboard:) forControlEvents:UIControlEventEditingDidEndOnExit];
    
    self.passwordTextField.leftViewMode = UITextFieldViewModeAlways;
    self.passwordTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    [self.passwordTextField addTarget:self action:@selector(returnOnKeyboard:) forControlEvents:UIControlEventEditingDidEndOnExit];
    
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
    if (![self.accountTextField isFirstResponder] && ![self.passwordTextField isFirstResponder]) {
        return NO;
    }
    return YES;
}

- (void)returnOnKeyboard:(UITextField *)sender
{
    if (sender == self.accountTextField) {
        [self.passwordTextField becomeFirstResponder];
    } else if (sender == self.passwordTextField) {
        [self hidenKeyboard];
    }
}
#pragma mark - 键盘操作
- (void)hidenKeyboard
{
    [self.accountTextField resignFirstResponder];
    [self.passwordTextField resignFirstResponder];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)rememberCode:(id)sender {
    
    _isremember = !_isremember;
    if (_isremember) {
        NSLog(@"记住密码");
        [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"SaveCode"];
        [[NSUserDefaults standardUserDefaults]synchronize];
        [_rememberpro setBackgroundImage:[UIImage imageNamed:@"chose2"] forState:UIControlStateNormal];
    }else
    {
        NSLog(@"取消记住密码");
        [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"SaveCode"];
        [[NSUserDefaults standardUserDefaults]synchronize];
        [_rememberpro setBackgroundImage:[UIImage imageNamed:@"chose1@3x"] forState:UIControlStateNormal];
        
    }
    
}

- (IBAction)forgetkeyBtn:(id)sender {
    NSLog(@"忘记密码");
    GetCountViewController *forgetcountvc = [[GetCountViewController alloc]init
                                             ];
    [self.navigationController pushViewController:forgetcountvc animated:YES];
}

- (IBAction)logBtn:(id)sender {
    // NSLog(@"登录");
    
    //账号密码为空时的提示
        if(_accountTextField.text.length == 0){
            [[Tool SharedInstance]showtoast:@"请输入账号"];
            return;
        }
        if (_passwordTextField.text.length == 0) {
            [[Tool SharedInstance]showtoast:@"请输入密码"];
            return;
        }
    
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
    NSDictionary *dict = @{@"username":_accountTextField.text,@"password":_passwordTextField.text,@"lt":tickt,@"execution":key,@"_eventId":@"submit"};
    //3.请求
    [[NetworkSingleton sharedManager]postResultWithParameter:dict url:LoginAPI successBlock:^(id responseBody) {
        NSLog(@"登录----%@",responseBody);
        if([responseBody[@"errors"] isEqualToString: @""])
        {
            if ([responseBody[@"logined"]integerValue]==1) {
                [[Tool SharedInstance]showtoast:@"登陆成功"];
                
                [[NSUserDefaults standardUserDefaults] setBool:YES forKey:LogSuccess];
                [[NSUserDefaults standardUserDefaults] setObject:self.accountTextField.text forKey:@"accounttext"];
                [[NSUserDefaults standardUserDefaults] setObject:self.passwordTextField.text forKey:@"passwordtext"];
                [[NSUserDefaults standardUserDefaults]synchronize];
                self.isRootview = [[NSUserDefaults standardUserDefaults]boolForKey:@"logisroot"];
                //NSLog(@"保存的为--%hhd",self.isRootview);
                if (self.isRootview) {
                    self.navigationController.navigationBar.hidden = YES;
                    [self.navigationController pushViewController:[AppDelegate appdelegate].drawerController animated:YES];
                }else{
                    [self dismissViewControllerAnimated:YES completion:nil];
                }
                

                [self saveCookies];

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


/*** 不知为何有时退出应用后，cookie不保存，所以这里手动保存cookie ***/
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
