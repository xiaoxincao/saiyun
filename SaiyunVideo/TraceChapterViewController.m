//
//  TraceChapterViewController.m
//  SaiyunVideo
//
//  Created by cying on 16/2/23.
//  Copyright © 2016年 cying. All rights reserved.
//

#import "TraceChapterViewController.h"
#import "ChaptersModel.h"
#import "ValueModel.h"

@interface TraceChapterViewController ()<UITableViewDataSource,UITableViewDelegate>


@property (nonatomic, strong)VideoViewController *vvc;

@property (nonatomic, strong)NSMutableArray *resultarray;

@property (nonatomic, strong)NSMutableArray *modelarray;

@end

@implementation TraceChapterViewController


- (void)viewDidLoad{
    [super viewDidLoad];
    self.traceChaptable = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    self.vvc = [[VideoViewController alloc]init];
    self.traceChaptable.delegate = self;
    self.traceChaptable.dataSource = self;
    [self.view addSubview:self.traceChaptable];
    
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    [self.traceChaptable setTableFooterView:view];

}


#pragma mark-
#pragma mark 代理&数据源
#pragma mark -行高
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 40;
}

//段数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return _dataarray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    ChaptersModel *model = _dataarray[section];
    return model.value.count;//行数
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 40;//段头的高度
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 40)];
    view.backgroundColor = [UIColor whiteColor];
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:view.frame];
    ChaptersModel *model = _dataarray[section];
    titleLabel.text = model.keyName;
    titleLabel.textColor = [UIColor orangeColor];
    [view addSubview:titleLabel];
    return view;
}



#pragma mark -重用cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
    }
    ChaptersModel *sectionModel = _dataarray[indexPath.section];
    ValueModel *model = sectionModel.value[indexPath.row];
    NSString * tempStr = [NSString stringWithFormat:@"%ld-%@",(long)indexPath.row+1,model.name];
    cell.textLabel.text = tempStr;
    cell.detailTextLabel.text = model.playTime;
    cell.textLabel.font = [UIFont systemFontOfSize:15];
    if(model.lastStudyTime)
    {
        cell.textLabel.textColor = [UIColor blackColor];
    }else
    {
        cell.textLabel.textColor = [UIColor grayColor];
    }
    cell.detailTextLabel.font = [UIFont systemFontOfSize:13];
    cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame];
    cell.selectedBackgroundView.backgroundColor = [UIColor orangeColor];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ChaptersModel *sectionModel = _dataarray[indexPath.section];
    ValueModel *model = sectionModel.value[indexPath.row];
    //需要courseid，coursewareid，userid
    if(model.lastStudyTime)
    {
        NSString *appendstr = [NSString stringWithFormat:Video_Chapter_Play,self.courseId,model.id];
        [[NetworkSingleton sharedManager]getResultWithParameter:nil url:appendstr successBlock:^(id responseBody) {
            NSDictionary *dict = responseBody[@"result"];
            ValueModel *valuemodel = [ValueModel mj_objectWithKeyValues:dict];
            if (valuemodel.fullFilePath) {
                //VideoViewController *vvv = [[VideoViewController alloc]init];
                //传值给video界面！
                NSNotification *notification = [NSNotification notificationWithName:@"TraceNotice" object:nil userInfo:dict];
                [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"ISNOTICE"];
                [[NSUserDefaults standardUserDefaults]synchronize];
                
                [[NSNotificationCenter defaultCenter]postNotification:notification];
                [self.navigationController pushViewController:self.vvc animated:YES];
            }
            else{
                [[Tool SharedInstance]showtoast:@"亲，先完成上一课程喔~"];
            }
            //NSLog(@"章节列表的内容----%@",dict);
        } failureBlock:^(NSString *error) {
        }];
    }
    else
    {
        [[Tool SharedInstance]showtoast:@"亲，先完成上一课程喔~"];
    }
    NSLog(@"点击了章节列表");
}

@end
