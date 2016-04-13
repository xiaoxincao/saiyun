
//
//  SettingTableViewController.m
//  CloudPlatform
//
//  Created by cying on 15/7/31.
//  Copyright (c) 2015年 cying. All rights reserved.
//

#import "SettingTableViewController.h"
#import "PersonTableViewController.h"
#import "AboutAppViewController.h"
#import "OpinionViewController.h"
#import "ExitCell.h"
#import "UIImageView+WebCache.h"



@interface SettingTableViewController ()

@property (nonatomic, strong)UITableView *settableview;
@property (nonatomic, readonly) UIButton *m_btnNaviRight;
@property (nonatomic, assign)BOOL switchoh;
@end

@implementation SettingTableViewController
@synthesize m_btnNaviRight = _btnNaviLeft;


- (void)viewDidLoad {
    [super viewDidLoad];
    
    _settableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) style:UITableViewStylePlain];
    _settableview.delegate = self;
    _settableview.dataSource = self;
    [self.view addSubview:_settableview];
    
    
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    [_settableview setTableFooterView:view];
    
    [self setSetNavigation];
}


- (void)setSetNavigation
{
    self.title = @"设置";
    
    //设置导航栏字体及颜色
    [self.navigationController.navigationBar setTitleTextAttributes:
     
     @{NSFontAttributeName:[UIFont systemFontOfSize:17],
       
       NSForegroundColorAttributeName:[UIColor whiteColor]}];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    //设置导航栏背景颜色
    self.navigationController.navigationBar.translucent  =  NO;
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"mainbg"]forBarMetrics:UIBarMetricsDefault];
    UIBarButtonItem *backBtn = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"NaviBtn_Back@3x"] style:UIBarButtonItemStylePlain target:self action:@selector(backCenter)];
    self.navigationItem.leftBarButtonItem = backBtn;
}
- (void)backCenter{
    BOOL set = [[NSUserDefaults standardUserDefaults]boolForKey:@"set"];
    if (set) {
        [self.navigationController popViewControllerAnimated:YES];
    }
    else{
    VideoViewController *vvc= [VideoViewController sharedVideoViewController];
    [self.mm_drawerController setCloseDrawerGestureModeMask:MMCloseDrawerGestureModeAll];
    [self.mm_drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeAll];
    [self.navigationController pushViewController:vvc animated:YES];
    }
    [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"set"];
    [[NSUserDefaults standardUserDefaults]synchronize];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    NSUserDefaults *userdefault = [NSUserDefaults standardUserDefaults];
    NSString *header = [userdefault objectForKey:Header];
    NSLog(@"设置里的头像---%@",header);
    [_settableview reloadData];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    }else if (section == 1){
        return 2;
    }else if (section == 2){
        return 2;
    }else{
        return 1;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

#pragma mark-Cell的重用
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIDarrow = @"UITableViewCellarrow";
    static NSString *cellIDswitch = @"UITableViewCellswitch";
    static NSString *cellIDnum = @"UITableViewCellnum";
    static NSString *cellIDnormal = @"UITableViewCellnormal";
    NSUInteger row = [indexPath row];
    NSUInteger section = [indexPath section];
    
    UITableViewCell *cell;
    //首先根据标示去缓存池取
    if (section == 1) {
        cell = [_settableview dequeueReusableCellWithIdentifier:cellIDarrow];
    }else if (section == 2)
    {
        if (row == 0) {
            cell = [_settableview dequeueReusableCellWithIdentifier:cellIDnum];
        }else{
            cell = [_settableview dequeueReusableCellWithIdentifier:cellIDswitch];
        }
    }else if (section == 3)
    {
        cell = [_settableview dequeueReusableCellWithIdentifier:cellIDarrow];
    }else{
        cell = [_settableview dequeueReusableCellWithIdentifier:cellIDnormal];
    }
    
    
    //如果缓存池没有取到则重新创建并放到缓存池中
    //if (cell == nil) {
    if (section == 0) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIDarrow];
        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
        NSUserDefaults *userdefault = [NSUserDefaults standardUserDefaults];
        NSString *header = [userdefault objectForKey:Header];
        if (header != nil) {
            NSMutableString *mutableuserHeader = [NSMutableString stringWithString:header];
            //设置用户头像
            NSString *userHeaderInfo = [PersonPort stringByAppendingString:mutableuserHeader];
            [cell.imageView sd_setImageWithURL:[NSURL URLWithString:userHeaderInfo] placeholderImage:[UIImage imageNamed:@"default_point@3x"]];            
        }else{
            cell.imageView.image = [UIImage imageNamed:@"default_point@3x.png"];
        }
    }else if (section == 1){
        if (row == 0) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIDnum];
            cell.textLabel.font = [UIFont systemFontOfSize:14];
            cell.textLabel.text = @"清除缓存";
        }else if(row == 1){
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIDswitch];
            UISwitch *sw1=[[UISwitch alloc]init];
            self.switchoh = [[NSUserDefaults standardUserDefaults]boolForKey:@"switchoh"];
            if (self.switchoh) {
                //默认开关开开的状态
                sw1.on = 1;
            }
            [sw1 addTarget:self action:@selector(switch1ValueChange:) forControlEvents:UIControlEventValueChanged];
            cell.accessoryView=sw1;
            cell.textLabel.font = [UIFont systemFontOfSize:14];
            cell.textLabel.numberOfLines = 2;
            cell.textLabel.text = @"允许WIFI网络播放/缓存视频请慎重选择开启 避免过度使用流量";
        }
    }else if (section == 2){
        if (row == 0) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIDarrow];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.textLabel.font = [UIFont systemFontOfSize:14];
            cell.textLabel.text = @"意见反馈";
        }else{
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIDarrow];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.textLabel.font = [UIFont systemFontOfSize:14];
            cell.textLabel.text = @"关于APP";
        }
        
    }else if(section == 3){
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIDnormal];
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ExitCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    

    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

#pragma mark 切换流量开关转化事件
-(void)switch1ValueChange:(UISwitch *)sw{
    NSLog(@"section:%li,switch:%i",(long)sw.tag, sw.on);
    if (sw.on==1) {
        [[Tool SharedInstance]showtoast:@"亲，注意流量喔~"];
        [[NSUserDefaults standardUserDefaults]setBool:YES forKey:ON];
        [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"switchoh"];
        [[NSUserDefaults standardUserDefaults]synchronize];

    }else
    {
        [[NSUserDefaults standardUserDefaults]setBool:NO forKey:ON];
        [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"switchoh"];
        [[NSUserDefaults standardUserDefaults]synchronize];
    }
}
#pragma mark 切换推送通知
-(void)switch2ValueChange:(UISwitch *)sw{
    
    if (sw.on==1) {
        [[Tool SharedInstance]showtoast:@"已开启推送通知"];
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 2;
}

#pragma mark 自定义表头部????然并卵？？？？
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *lineview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth,1)];
    lineview.tintColor = [UIColor orangeColor];
    lineview.alpha = 0.5;
    return lineview;
}

#pragma mark cell的点击事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSUInteger row = [indexPath row];
    NSUInteger section = [indexPath section];
    if (section == 0) {
        NSUserDefaults *userdefault = [NSUserDefaults standardUserDefaults];
        BOOL loginsuccess = [userdefault boolForKey:@"LoginSuccess"];
        if(loginsuccess){
            NSLog(@"跳跳跳！");
            PersonTableViewController *persontvc = [[PersonTableViewController alloc]init];
            persontvc.personmodel = _setpersonmodel;
            [self.navigationController pushViewController:persontvc animated:YES];
        }else{
            LogInViewController *log = [[LogInViewController alloc]init];
            UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:log];
            [self presentViewController:nav animated:YES completion:nil];
        }
        
    }else if (section == 1){
        if (row == 0) {
            [[SDImageCache sharedImageCache]clearDisk];
            [self clearFile];
            //添加清除缓存成功地提示框
            [[Tool SharedInstance]showtoast:@"清理成功"];
            
        }else if (row == 1){
            NSLog(@"wifi");
        }
    }else if (section == 2){
        if (row == 0) {
            OpinionViewController *opiniovc = [[OpinionViewController alloc]init];
            [self.navigationController pushViewController:opiniovc animated:YES];
        }else{
            AboutAppViewController *aboutvc = [[AboutAppViewController alloc]init];
            [self.navigationController pushViewController:aboutvc animated:YES];
        }
    }else if(section == 3){
        //退出登录
        [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"logisroot"];
        [[NSUserDefaults standardUserDefaults]synchronize];
        NSLog(@"退出登录");
        [self clearuserdefault];
        [[NetworkSingleton sharedManager]postResultWithParameter:nil url:Outlogin successBlock:^(id responseBody) {
        } failureBlock:^(NSString *error) {
        }];
        [[NetworkSingleton sharedManager]postResultWithParameter:nil url:LogoutYunGu successBlock:^(id responseBody) {
        } failureBlock:^(NSString *error) {
        }];
        [[NetworkSingleton sharedManager]postResultWithParameter:nil url:LogoutUser successBlock:^(id responseBody) {
        } failureBlock:^(NSString *error) {
        }];
        //获取UserDefaults单例
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        BOOL logsuccess = NO;
        //移除UserDefaults中存储的用户信息
        [userDefaults setBool:YES forKey:@"ISNOLOGIN"];
        [userDefaults setBool:logsuccess forKey:LogSuccess];
        [userDefaults synchronize];
        LogInViewController *loginVC = [[LogInViewController alloc]init];
        UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:loginVC];
        [self presentViewController:nav animated:YES completion:^{
        }];
        
    }
    
}
#pragma mark 删除cookie
- (void)clearuserdefault
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults removeObjectForKey:@"cookie"];
}
- (void)clearFile
{
    NSString * cachPath = [ NSSearchPathForDirectoriesInDomains ( NSCachesDirectory , NSUserDomainMask , YES ) firstObject ];
    
    NSArray * files = [[ NSFileManager defaultManager ] subpathsAtPath :cachPath];
    
    NSLog ( @"cachpath = %@" , cachPath);
    
    for ( NSString * p in files) {
        
        NSError * error = nil ;
        
        NSString * path = [cachPath stringByAppendingPathComponent :p];
        
        if ([[ NSFileManager defaultManager ] fileExistsAtPath :path]) {
            
            [[ NSFileManager defaultManager ] removeItemAtPath :path error :&error];
        }
    }
    [ self performSelectorOnMainThread : @selector (clearCachSuccess) withObject : nil waitUntilDone : YES ];
}

- (void)clearCachSuccess
{
    NSIndexPath *index=[NSIndexPath indexPathForRow:1 inSection:2];//刷新
    [_settableview reloadRowsAtIndexPaths:[NSArray arrayWithObjects:index,nil] withRowAnimation:UITableViewRowAnimationNone];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



@end
