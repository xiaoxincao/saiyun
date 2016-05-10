//
//  MenuViewController.m
//  SaiyunVideo
//
//  Created by cying on 15/11/17.
//  Copyright (c) 2015年 cying. All rights reserved.
//

#import "MenuViewController.h"
#import "MyTraceViewController.h"
#import "CollectionViewController.h"
#import "SettingTableViewController.h"
#import "UIViewController+MMDrawerController.h"
#import "AppDelegate.h"
#import "UIImageView+WebCache.h"
#import "UIButton+WebCache.h"
#import "UIButton+WebCache.h"
#import "CircleModel.h"
#import "PersonTableViewController.h"

@interface MenuViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong)NSArray *array;

@end

@implementation MenuViewController




- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    _MenuTableview.delegate = self;
    _MenuTableview.dataSource = self;
    _MenuHeaderView.backgroundColor = [UIColor darkGrayColor];
    _MenuTableview.backgroundColor = [UIColor darkGrayColor];

    [self getuserInfo];
    [self setMenuNavigation];
    
    _array = [NSArray arrayWithObjects:@"我的收藏",@"我的足迹",@"个人设置",nil];
    
    //设置圆角按钮
    _userHeaderBtn.layer.cornerRadius = 75;
    _userHeaderBtn.clipsToBounds = YES;
    
    
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    NSUserDefaults *userdefault = [NSUserDefaults standardUserDefaults];
    BOOL loginsuccess = [userdefault boolForKey:LogSuccess];
    if (loginsuccess) {
        [self updateinfo];
        self.userphoto.userInteractionEnabled = NO;
    }else
    {
        self.userphoto.userInteractionEnabled = YES;
    }
    
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
//    [self.mm_drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeNone];
//    
//    [self.mm_drawerController setCloseDrawerGestureModeMask:MMCloseDrawerGestureModeNone];
    
}
#pragma mark-获取用户信息
- (void)getuserInfo
{
    [[NetworkSingleton sharedManager]postResultWithParameter:nil url:GetUserInfo successBlock:^(id responseBody) {
        NSDictionary *resultdict = [responseBody objectForKey:@"result"];
        //NSLog(@"--Menu%@",resultdict);
        //如果加载成功的话则赋值给列表内容，并保存到本地
        if ([resultdict[@"success"] isEqual: @1]) {
            NSDictionary *userdict = [resultdict objectForKey:@"user"];
            PersonInfo *person = [PersonInfo mj_objectWithKeyValues:userdict];
            [[NSUserDefaults standardUserDefaults]setObject:userdict[@"description"] forKey:Sign];
            [[NSUserDefaults standardUserDefaults]setObject:person.email forKey:E_mail];
            [[NSUserDefaults standardUserDefaults]setObject:userdict[@"id"] forKey:ID];
            [[NSUserDefaults standardUserDefaults]setObject:person.name forKey:NiceName];
            [[NSUserDefaults standardUserDefaults]setObject:person.phone_no forKey:Account];
            [[NSUserDefaults standardUserDefaults]setObject:person.photo forKey:Header];
            [[NSUserDefaults standardUserDefaults]setObject:person.sex forKey:Sex];
            [[NSUserDefaults standardUserDefaults]synchronize];
            //更新个人信息
            [self updateinfo];
        }
        else
        {
            
        }
    } failureBlock:^(NSString *error) {
        NSLog(@"Menu里获取用户信息错误");
    }];
}
- (void)updateinfo{

    NSUserDefaults *userdefault = [NSUserDefaults standardUserDefaults];
        NSString *header = [userdefault objectForKey:Header];
        NSString *name = [userdefault objectForKey:NiceName];
    if (header != nil) {
        //设置用户头像
        NSString *userHeaderInfo = [PersonPort stringByAppendingString:header];
        [self.userphoto sd_setBackgroundImageWithURL:[NSURL URLWithString:userHeaderInfo] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"default_point@3x"]];

        self.userphoto.userInteractionEnabled = NO;
        self.userNameLabel.text = name;
        self.userNameLabel.textColor = [UIColor whiteColor];
        self.userNameLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:20.f];
    }else
    {
        self.userNameLabel.text = @"用户名";
        [self.userphoto setBackgroundImage:[UIImage imageNamed:@"default_point@3x"] forState:UIControlStateNormal];
    }

}
- (void)setMenuNavigation
{
    self.title = @"云谷创课";
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSFontAttributeName:[UIFont systemFontOfSize:19],
       NSForegroundColorAttributeName:[UIColor whiteColor]}];
    self.navigationController.navigationBar.barTintColor = [UIColor darkGrayColor];
    self.navigationController.navigationBar.translucent  =  NO;
    
    if ([self.navigationController.navigationBar respondsToSelector:@selector( setBackgroundImage:forBarMetrics:)]){
        NSArray *list=self.navigationController.navigationBar.subviews;
        for (id obj in list) {
            if ([obj isKindOfClass:[UIImageView class]]) {
                UIImageView *imageView=(UIImageView *)obj;
                NSArray *list2=imageView.subviews;
                for (id obj2 in list2) {
                    if ([obj2 isKindOfClass:[UIImageView class]]) {
                        UIImageView *imageView2=(UIImageView *)obj2;
                        imageView2.hidden=YES;
                    }
                }
            }
        }
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_array count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"cellId";
    UITableViewCell *cell;
    cell = [_MenuTableview dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    cell.textLabel.text = _array[indexPath.row];
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.textLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:18.f];
    cell.backgroundColor = [UIColor darkGrayColor];
    _MenuTableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row == 0) {
        
        NSUserDefaults *userdefault = [NSUserDefaults standardUserDefaults];
        BOOL loginsuccess = [userdefault boolForKey:@"LoginSuccess"];
        if(loginsuccess){
            CollectionViewController *collectionVC = [[CollectionViewController alloc]init];
            UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:collectionVC];
            [self PushVc:nav];
        }else{
            LogInViewController *log = [[LogInViewController alloc]init];
            UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:log];
            [self presentViewController:nav animated:YES completion:nil];
        }
        
    }
    if (indexPath.row == 1) {
        NSUserDefaults *userdefault = [NSUserDefaults standardUserDefaults];
        BOOL loginsuccess = [userdefault boolForKey:@"LoginSuccess"];
        if(loginsuccess){
            MyTraceViewController *mytraceVC = [[MyTraceViewController alloc]init];
            UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:mytraceVC];
            [self PushVc:nav];
        }else{
            LogInViewController *log = [[LogInViewController alloc]init];
            UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:log];
            [self presentViewController:nav animated:YES completion:nil];
        }
    }
    if (indexPath.row == 2) {
        SettingTableViewController *setTVC = [[SettingTableViewController alloc]init];
        UINavigationController *nc = [[UINavigationController alloc]initWithRootViewController:setTVC];
        [self PushVc:nc];
    }
    
}

- (void)PushVc:(UIViewController *)VC
{
    AppDelegate *appdelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    appdelegate.drawerController.centerViewController = VC;
    [appdelegate.drawerController closeDrawerAnimated:YES completion:nil];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)ExitButton:(id)sender {
    exit(0);
}



- (IBAction)userHeaderButton:(id)sender {
    //判断登录状态
    //保存一个未登录的状态
    [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"ISNOLOGIN"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    //没登录时跳转登录界面
    LogInViewController *logVC = [[LogInViewController alloc]init];
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:logVC];
    [self presentViewController:nav animated:YES completion:nil];
}



@end
