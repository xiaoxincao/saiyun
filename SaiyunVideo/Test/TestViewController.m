//
//  TestViewController.m
//  SaiyunVideo
//
//  Created by cying on 16/1/20.
//  Copyright © 2016年 cying. All rights reserved.
//

#import "TestViewController.h"
#import "TestResultViewController.h"
#import "TestResultModel.h"
#import "TestOptionModel.h"
#import "OptionsTableViewCell.h"
#import "NSString+ITTAddtion.h"

@interface TestViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic , strong)NSMutableArray *resultarray;

@property (nonatomic , strong)NSMutableArray *saveresultarray;

@property (nonatomic , copy)NSString *questionid;

@property (nonatomic , copy)NSString *anwserid;

@property (nonatomic , copy)NSString *value;


@end

@implementation TestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.TestTableview.delegate = self;
    self.TestTableview.dataSource = self;
    [self loadTestData];
    self.TestTableview.backgroundColor = [UIColor whiteColor];
    self.TestTableview.separatorStyle = NO;
    [self. TestTableview registerNib:[UINib nibWithNibName:@"OptionsTableViewCell" bundle:nil] forCellReuseIdentifier:@"optioncellID"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadTestData
{
    NSString *appendstr = [CourseWare_Test stringByAppendingString:self.courwareid];
    NSLog(@"aaa----%@",appendstr);
    [[NetworkSingleton sharedManager]getResultWithParameter:nil url:appendstr successBlock:^(id responseBody) {
        NSLog(@"考试！！--列表==%@",responseBody);
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
            NSLog(@"加载考试成功--%@",self.saveresultarray);
        }
        [self.TestTableview reloadData];
    } failureBlock:^(NSString *error) {
        NSLog(@"获取考试失败");
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
//每组行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
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
    OptionsTableViewCell *cell = [self.TestTableview dequeueReusableCellWithIdentifier:@"optioncellID"];
    TestResultModel *resultmodel = self.saveresultarray[indexPath.section];
    TestOptionModel *model = resultmodel.options[indexPath.row];
    [cell setOptionCell:model andResult:resultmodel];
    UIView *tempView = [[UIView alloc] init];
    [cell setBackgroundView:tempView];
    cell.backgroundColor = [UIColor clearColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}
//提交答案
- (IBAction)HandAnswerAct:(id)sender {
    //获取当前选中的选项！
    //questionid,anwserid,value
    
    NSMutableArray *dictarray = [NSMutableArray array];
    for (TestResultModel *resultmodel in self.saveresultarray) {
        for (TestOptionModel *optionmodel in resultmodel.options) {
            NSMutableDictionary * dict = [NSMutableDictionary dictionary] ;
            if (optionmodel.isChosed) {
                [dict setObject: resultmodel.id forKey:@"qid"];
                [dict setObject:optionmodel.id forKey:@"aid"];
                [dict setObject: optionmodel.value  forKey:@"val"];
                [dictarray addObject:dict];
            }
        }
    }
    NSString *result = [NSString  jsonStringWithArray:dictarray];
    NSDictionary *dictionary = @{@"coursewareId":self.courwareid,@"result":result};
    [[NetworkSingleton sharedManager]postResultWithParameter:dictionary url:Submit_TestAnswers successBlock:^(id responseBody) {
        NSLog(@"提交答案结果---%@--%@--%@",responseBody[@"result"],responseBody[@"msg"],responseBody);
        if ([responseBody[@"success"] isEqual:@1]) {
            [[Tool SharedInstance]showtoast:@"提交答案成功"];
            //跳转到测试结果页面
            TestResultViewController *testresultVC = [[TestResultViewController alloc]init];
            testresultVC.courwareid = self.courwareid;
            testresultVC.courseid = self.courseid;
            testresultVC.ispassteststr = responseBody[@"result"];
            [self.navigationController pushViewController:testresultVC animated:YES];
        }else{
            [[Tool SharedInstance]showtoast:@"提交答案失败"];
        }
    } failureBlock:^(NSString *error) {
        NSLog(@"提交答案失败");
    }];
}
@end
