//
//  Chaptertableview.m
//  SaiyunVideo
//
//  Created by cying on 16/1/13.
//  Copyright (c) 2016年 cying. All rights reserved.
//

#import "Chaptertableview.h"
#import "ChaptersModel.h"
#import "ValueModel.h"

@implementation Chaptertableview



- (id)initWithFrame:(CGRect)frame style:(UITableViewStyle)style{
    self = [super initWithFrame:frame style:style];
    if (self) {
        self.delegate = self;
        self.dataSource = self;
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
        
    }
    return self;
}



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
    
    if(model.lastStudyTime)
    {
        cell.textLabel.textColor = [UIColor blackColor];
    }else
    {
        cell.textLabel.textColor = [UIColor grayColor];
    }
    
    NSString * tempStr = [NSString stringWithFormat:@"%ld-%@",(long)indexPath.row+1,model.name];
    cell.textLabel.text = tempStr;
    
    
    //cell.imageView.image = [UIImage imageNamed:@"collect"];
    cell.detailTextLabel.text = model.playTime;
    cell.textLabel.font = [UIFont systemFontOfSize:13];
    cell.detailTextLabel.font = [UIFont systemFontOfSize:13];
    cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame];
    
//    if (indexPath.row == self.indexs ) {
//        cell.selected = YES;
//        cell.backgroundColor = [UIColor orangeColor];
//
//    }else
//    {
//        cell.backgroundColor = [UIColor whiteColor];
//
//    }
    cell.selectedBackgroundView.backgroundColor = [UIColor orangeColor];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ChaptersModel *sectionModel = _dataarray[indexPath.section];
    ValueModel *model = sectionModel.value[indexPath.row];
    //如果有的话就可以点击调用方法
    NSLog(@"LastStudyTIme-----%@",model.lastStudyTime);
    if(model.lastStudyTime)
    {
    self.indexs = indexPath.row;
        
    NSString *appendstr = [NSString stringWithFormat:Video_Chapter_Play,self.courseId,model.id];
    [[NetworkSingleton sharedManager]getResultWithParameter:nil url:appendstr successBlock:^(id responseBody) {
        
        NSDictionary *dict = responseBody[@"result"];
            //传值给video界面！
            NSNotification *notification = [NSNotification notificationWithName:@"ChapterNotice" object:nil userInfo:dict];
            [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"ISNOTICE"];
            [[NSUserDefaults standardUserDefaults]synchronize];

            [[NSNotificationCenter defaultCenter]postNotification:notification];
        
    } failureBlock:^(NSString *error) {
        
    }];
    }
    else
    {
         [[Tool SharedInstance]showtoast:@"亲，先完成上一课程喔~"];
    }
}
@end
