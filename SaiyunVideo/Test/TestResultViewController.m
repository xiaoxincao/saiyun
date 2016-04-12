//
//  TestResultViewController.m
//  SaiyunVideo
//
//  Created by cying on 16/1/23.
//  Copyright © 2016年 cying. All rights reserved.
//

#import "TestResultViewController.h"
#import "OptionsTableViewCell.h"

@interface TestResultViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic , strong)NSMutableArray *resultarray;

@property (nonatomic , strong)NSMutableArray *saveresultarray;

@end

@implementation TestResultViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.Testresulttableview.delegate = self;
    self.Testresulttableview.dataSource = self;
    [self loadResultData];
    [self.Testresulttableview registerNib:[UINib nibWithNibName:@"OptionsTableViewCell" bundle:nil] forCellReuseIdentifier:@"optioncellID"];
    NSLog(@"--考试传给考试结果的参数--%@",self.ispassteststr);
    if([self.ispassteststr isEqual: @1])
    {
        self.Texttipslab.text = @"恭喜你，考试通过啦~";
    }
    else{
        self.Texttipslab.text = @"亲，考试未通过，可再测一次喔~";
    }
    
    [self setNavigation];
    
}

- (void)setNavigation
{
    self.title = @"考试结果";
    UIBarButtonItem *left = [[UIBarButtonItem alloc]initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:@selector(leftBtn)];
    self.navigationItem.leftBarButtonItem = left;
    //    UIBarButtonItem *right = [[UIBarButtonItem alloc]initWithTitle:@"重新测试" style:UIBarButtonItemStylePlain target:self action:@selector(rightBtn)];
    //    self.navigationItem.leftBarButtonItem = right;
}

- (void)leftBtn
{
    // NSLog(@"");
    
}
- (void)rightBtn
{
    TestViewController *testvc = [[TestViewController alloc]init];
    [self.navigationController pushViewController:testvc animated:YES];
}
- (void)loadResultData
{
    NSString *appendstr = [NSString stringWithFormat:Test_Result,self.courseid,self.courwareid];
    NSLog(@"考试url---%@",appendstr);
    [[NetworkSingleton sharedManager]postResultWithParameter:nil url:appendstr successBlock:^(id responseBody) {
        //NSLog(@"--获取考试结果成功--%@",responseBody);
        
        self.saveresultarray = [NSMutableArray array];
        for (NSDictionary *dict in responseBody[@"result"]) {
            TestResultModel *resultmodel = [TestResultModel mj_objectWithKeyValues:dict];
            NSMutableArray *saveoptionarray = [NSMutableArray array];
            for (NSDictionary *optiondict in dict[@"options"]) {
                TestOptionModel *optionmodel = [TestOptionModel mj_objectWithKeyValues:optiondict];
                [saveoptionarray addObject:optionmodel];
            }
            resultmodel.options = saveoptionarray;
            [self.saveresultarray addObject:resultmodel];
            //NSLog(@"加载考试成功--%@",self.saveresultarray);
        }
        [self.Testresulttableview reloadData];
        
        
    } failureBlock:^(NSString *error) {
        NSLog(@"获取考试结果失败");
    }];
    
}

//组头的高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 30;//段头的高度
}
//行高
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 30;
}
//组数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return self.saveresultarray.count;
}
//行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    TestResultModel *resultmodel = self.saveresultarray[section];
    return resultmodel.options.count;
}

//设置组头
- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 40)];
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:view.frame];
    TestResultModel *model = self.saveresultarray[section];
    titleLabel.text = model.name;
    titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:20.f];
    [view addSubview:titleLabel];
    return view;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    OptionsTableViewCell *cell = [self.Testresulttableview dequeueReusableCellWithIdentifier:@"optioncellID"];
    TestResultModel *resultmodel = self.saveresultarray[indexPath.section];
    TestOptionModel *model = resultmodel.options[indexPath.row];
    [cell setResltCell:resultmodel andOption:model];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    UIView *tempView = [[UIView alloc] init];
    [cell setBackgroundView:tempView];
    cell.backgroundColor = [UIColor clearColor];
    
    
    return cell;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)NextBtnAct:(id)sender {
    if ([self.ispassteststr isEqual: @0]) {
        [[Tool SharedInstance]showtoast:@"通过考试才可以观看下一视频喔~"];
    }
    else
    {
        NSLog(@"下一课件");
        NSNotification *notification = [NSNotification notificationWithName:@"HiddenBtn" object:nil userInfo:nil];
        [[NSNotificationCenter defaultCenter]postNotification:notification];
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}

- (IBAction)AgainBtnAct:(id)sender {
    //重新观看
    NSNotification *notification = [NSNotification notificationWithName:@"AgainHiddenBtn" object:nil userInfo:nil];
    [[NSNotificationCenter defaultCenter]postNotification:notification];
    
    [self.navigationController popToRootViewControllerAnimated:YES];
    
}
@end
