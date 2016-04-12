//
//  DownMenu.m
//  CloudPlatform
//
//  Created by cying on 15/9/6.
//  Copyright (c) 2015年 cying. All rights reserved.
//

#import "DownMenu.h"
#import "ClearView.h"
#import "VideoViewController.h"
#import "ChaptersModel.h"
#import "ValueModel.h"

@interface DownMenu ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong)UITableView *uptableView;

@property (nonatomic, strong)UITableView *downtableView;

@property (nonatomic, strong)NSArray *titleArray;//建议de数组

@property (nonatomic, strong)NSArray *sensionarray;

@property (nonatomic, strong)NSArray *allarray;

@property (nonatomic, strong)NSArray *detailArray;

@property (nonatomic, assign)NSInteger selectedIndex;

@property (nonatomic, strong)ClearView *clearview;//透明背景容器

@end
@implementation DownMenu

//章节列表
- (instancetype)initWithUPTitleArray:(NSArray *)titlearray andSensionArray:(NSArray *)sensionarray andDetailArray:(NSArray *)detailarray andAllArray:(NSArray *)allarray{
    if (self = [super init]) {
        self.titleArray = titlearray;
        self.sensionarray = sensionarray;
        self.detailArray = detailarray;
        self.allarray = allarray;
        [self addupAllViews];
        self.selectedIndex = 0;
    }
    return self;
}



//意见反馈列表
- (instancetype)initWithDownTitleArray:(NSArray *)titleArray{
    if (self = [super init]) {
        self.titleArray = titleArray;
        [self adddownAllViews];
        self.selectedIndex = 0;
    }
    return self;
}

#pragma mark -添加上所有View
//章节菜单
- (void)addupAllViews{
    //背景透明的View容器
    self.clearview = [[ClearView alloc] initWithFrame:kScreenBounds];
    _clearview.backgroundColor = [UIColor clearColor];
    __weak typeof(self) weakSelf = self;
    _clearview.touchBlock = ^(){
        weakSelf.isHidden = !weakSelf.isHidden;
    };
    
    CGRect tableViewFrame;

    //下拉菜单的tableview
    
    CGFloat X = 20;
    CGFloat Y = 350;
    CGFloat width = 280;
    CGFloat height = 150;
    if (self.titleArray.count*30 < height ) {
        CGFloat h = self.titleArray.count * 30;
        CGFloat y = 350 + 150 - h;
        tableViewFrame = CGRectMake(20, y, 280, h);
    }else
    {
        
        tableViewFrame =CGRectMake(X, Y, width, height);
    }
    
    self.uptableView = [[UITableView alloc]initWithFrame:tableViewFrame];
    _uptableView.delegate = self;
    _uptableView.dataSource = self;
    [_clearview addSubview:_uptableView];
    [_uptableView reloadData];
    [[UIApplication sharedApplication].keyWindow addSubview:_clearview];
    
    self.isHidden = YES;
    [self viewDidLayoutSubviews];
    
}

- (void)adddownAllViews
{
    //背景透明的View容器
    self.clearview = [[ClearView alloc] initWithFrame:kScreenBounds];
    _clearview.backgroundColor = [UIColor clearColor];
    __weak typeof(self) weakSelf = self;
    _clearview.touchBlock = ^(){
        weakSelf.isHidden = !weakSelf.isHidden;
    };
    
    //下拉菜单的tableview
    CGRect tableViewFrame;
    
    tableViewFrame =CGRectMake(100, 100, 150, 150);
    
    self.downtableView = [[UITableView alloc]initWithFrame:tableViewFrame];
    self.downtableView.delegate = self;
    self.downtableView.dataSource = self;
    [_clearview addSubview:self.downtableView];
    
    [[UIApplication sharedApplication].keyWindow addSubview:_clearview];
    
    self.isHidden = YES;
}

#pragma mark -被选择tableview行的索引
- (void)setSelectedIndex:(NSInteger)selectedIndex{
    _selectedIndex = selectedIndex;
}

#pragma mark -下拉菜单的显示
- (void)setIsHidden:(BOOL)isHidden{
    _isHidden = isHidden;
    self.clearview.hidden = isHidden;
    if (!self.isHidden) {
        [self.downtableView reloadData];
        [self.uptableView reloadData];
    }
}

#pragma mark - 点击
- (void)tapGRAction:(UIButton *)sender
{
    self.isHidden = !self.isHidden;
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation

{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - UITableViewDelegate && DataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return  self.titleArray.count;
}

#pragma mark -重用cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (tableView == _uptableView) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
        if (!cell) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
        }
        cell.textLabel.text = self.titleArray[indexPath.row];
        cell.textLabel.font = [UIFont systemFontOfSize:13];
        cell.textLabel.textColor = [UIColor blackColor];
        cell.detailTextLabel.font = [UIFont systemFontOfSize:13];
        cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame];
        //cell.selectedBackgroundView.backgroundColor = [UIColor orangeColor];
        return cell;
    }
    
  
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
        if (!cell) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        }
        cell.textLabel.text = self.titleArray[indexPath.row];
        cell.textLabel.font = [UIFont systemFontOfSize:15];
        cell.textLabel.textColor = [UIColor blackColor];
    
        return cell;
}

#pragma mark -行高
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (tableView == _uptableView) {
        return 30;
 
    }
     return 40;
}

#pragma mark 完善分割线的方法
-(void)viewDidLayoutSubviews {
    
    if ([self.uptableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.uptableView setSeparatorInset:UIEdgeInsetsZero];
        
    }
    if ([self.uptableView respondsToSelector:@selector(setLayoutMargins:)])  {
        [self.uptableView setLayoutMargins:UIEdgeInsetsZero];
    }
    
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPat{
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]){
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    cell.backgroundColor = [UIColor whiteColor];
}

#pragma mark -点击行
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    self.selectedIndex = indexPath.row;
    self.isHidden = !self.isHidden;
    if (tableView == _downtableView) {
        if (_selectedItemBlock) {
            _selectedItemBlock(indexPath.row,self.titleArray[indexPath.row]);
        }
    }
    else{
        
        if (_selectedchapterBlock) {
            _selectedchapterBlock(self.allarray[indexPath.row]);
        }
        
    }
    
}



@end
