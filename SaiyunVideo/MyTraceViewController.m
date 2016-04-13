//
//  MyTraceViewController.m
//  CloudPlatform
//
//  Created by cying on 15/9/28.
//  Copyright (c) 2015年 cying. All rights reserved.
//

#import "MyTraceViewController.h"
#import "MyTraceTableViewCell.h"
#import "TraceChapterViewController.h"
#import "ChaptersModel.h"
#import "CircleModel.h"
#import "ValueModel.h"

@interface MyTraceViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong)UITableView *traceTV;





@property (nonatomic, strong)NSMutableArray *resultarray;

@property (nonatomic, strong)NSMutableArray *modelarray;

@property (nonatomic,strong)NSArray *detailchapterArray;

@property (nonatomic,strong)NSMutableArray *AllChapterArray;

@property (nonatomic,strong)NSMutableArray *valueArray;

@end

@implementation MyTraceViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTraceNavigation];
    _traceTV = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-64)];
    _traceTV.delegate = self;
    _traceTV.dataSource = self;
    
    [_traceTV registerNib:[UINib nibWithNibName:@"MyTraceTableViewCell" bundle:nil] forCellReuseIdentifier:@"traceID"];
    
    [self.view addSubview:_traceTV];
    [self loadDataWithCompletionHandle];
}


- (void)loadDataWithCompletionHandle{
//:(void (^)())completionHandle{
    [[NetworkSingleton sharedManager]postResultWithParameter:nil url:String_Study_Trace successBlock:^(id responseBody) {
        //NSLog(@"加载我的足迹----%@",responseBody);
        //加载成功时执行加载列表
        if ([responseBody[@"success"]isEqual: @1]) {
            self.resultarray = [responseBody objectForKey:@"result"];
            self.modelarray = [NSMutableArray array];
            for (NSDictionary *dict in self.resultarray) {
                CircleModel *circlemodel = [CircleModel mj_objectWithKeyValues:dict];
                [self.modelarray addObject:circlemodel];
            }
            [_traceTV reloadData];
        }
        //加载失败时提示结果信息
        else
        {
            [[Tool SharedInstance]showtoast:responseBody[@"result"]];
        }
    } failureBlock:^(NSString *error) {
        NSLog(@"足迹列表失败");
    }];
//    if (completionHandle) {
//        completionHandle();
//    }
}



#pragma mark-
#pragma mark 设置导航栏
- (void)setTraceNavigation
{
    self.navigationItem.title = @"我的足迹";
    
    //设置导航栏字体及颜色
    [self.navigationController.navigationBar setTitleTextAttributes:
     
     @{NSFontAttributeName:[UIFont systemFontOfSize:17],
       
       NSForegroundColorAttributeName:[UIColor whiteColor]}];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    self.navigationController.navigationBar.translucent  =  NO;
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"mainbg"]forBarMetrics:UIBarMetricsDefault];
    UIBarButtonItem *backBtn = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"NaviBtn_Back@3x"] style:UIBarButtonItemStylePlain target:self action:@selector(backCenter)];
    self.navigationItem.leftBarButtonItem = backBtn;
}
#pragma mark-
#pragma mark 返回主界面
- (void)backCenter{
    VideoViewController *vvc= [[VideoViewController alloc]init];
    [self.mm_drawerController setCloseDrawerGestureModeMask:MMCloseDrawerGestureModeAll];
    [self.mm_drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeAll];
    [self.navigationController pushViewController:vvc animated:YES];

}

#pragma mark-
#pragma mark 代理&数据源
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.modelarray.count;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    CircleModel *model = self.modelarray[section];
    return model.value.count;
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 50)];
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(40, 0,(kScreenWidth-40), 40)];
    UIImageView *foot = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 40, 30)];
    view.backgroundColor = [UIColor whiteColor];
    foot.image = [UIImage imageNamed:@"foot@3x"];
    CircleModel *model=self.modelarray[section];
    NSString *str = [model.keyName stringByAppendingString:@"走过的路"];
    titleLabel.text = str;
    [view addSubview:titleLabel];
    [view addSubview:foot];
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 30;//段头的高度
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 126;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *cellID = @"traceID";
    MyTraceTableViewCell *cell = [_traceTV dequeueReusableCellWithIdentifier:cellID];
    CircleModel *circlemodel = self.modelarray[indexPath.section];
    ValueModel *valuemodel = circlemodel.value[indexPath.row];
    [cell setTraceModel:valuemodel];
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    TraceChapterViewController *tracechapterVC = [[TraceChapterViewController alloc]init];
    //传id
    CircleModel *circlemodel = self.modelarray[indexPath.section];
    ValueModel *valuemodel = circlemodel.value[indexPath.row];
    self.courseId = valuemodel.courseId;
    tracechapterVC.courseId = self.courseId;
    [self loadChapterData:^{
        tracechapterVC.dataarray = self.AllChapterArray;
        [tracechapterVC.traceChaptable reloadData];
    }];
    [self.navigationController pushViewController:tracechapterVC animated:YES];
}

- (void)loadChapterData:(void (^)())successBlock
{
    NSString *ChaperStr = [NSString stringWithFormat:Video_Chapter_List,self.courseId];
    [[NetworkSingleton sharedManager]postResultWithParameter:nil url:ChaperStr successBlock:^(id responseBody) {
        self.detailchapterArray = [responseBody objectForKey:@"result"];
        if (self.detailchapterArray) {
            NSLog(@"加载我的足迹里章节列表成功---");
            //模型存给章节数组
            //存放value数据的模型数组
            self.valueArray = [NSMutableArray array];
            self.AllChapterArray = [[NSMutableArray alloc]init];
            for (int i = 0; i<self.detailchapterArray.count; i++) {
                NSDictionary *dict = self.detailchapterArray[i];
                ChaptersModel *chaptermodel = [ChaptersModel mj_objectWithKeyValues:dict];
                self.valueArray = (NSMutableArray *)chaptermodel.value;
                NSMutableArray *array = [NSMutableArray array];
                for (int j = 0; j<self.valueArray.count; j++) {
                    NSDictionary *dict = self.valueArray[j];
                    ValueModel *valuemodel = [ValueModel mj_objectWithKeyValues:dict];
                    [array addObject:valuemodel];
                }
                chaptermodel.value = array;
                [self.AllChapterArray addObject:chaptermodel];
            }
        }
        if (successBlock) {
            successBlock();
        }
    } failureBlock:^(NSString *error) {
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}   

@end
