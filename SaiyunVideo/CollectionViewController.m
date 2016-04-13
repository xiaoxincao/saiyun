//
//  CollectionViewController.m
//  SaiyunVideo
//
//  Created by cying on 15/12/15.
//  Copyright (c) 2015年 cying. All rights reserved.
//

#import "CollectionViewController.h"
#import "VideoViewController.h"
#import "CollectionCell.h"
#import "CollectionModel.h"

@interface CollectionViewController ()<CollectionCellDelegate>


@property (nonatomic, strong)NSMutableArray *collectionarray;

@property (nonatomic, strong)NSMutableString *courseID;

@property (nonatomic, strong)NSMutableString *courseIDs;

@property (nonatomic, strong)NSMutableArray *resultarr;

@property (nonatomic, strong)MBProgressHUD *hud;


@end

@implementation CollectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNav];
    [self loadCollectionDataWithCompletionHandle:^{
        
    }];
    [self.tableView registerNib:[UINib nibWithNibName:@"CollectionCell" bundle:nil] forCellReuseIdentifier:@"cellid"];
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    [self.tableView setTableFooterView:view];

}

- (void)loadCollectionDataWithCompletionHandle:(void (^)())completionHandle
{
    self.collectionarray = [NSMutableArray array];
    self.hud = [[MBProgressHUD alloc]initWithView:self.view];
    [self.view addSubview: self.hud];
    self.hud.labelText = @"加载收藏数据中...";
    [self.hud show:YES];

    [[NetworkSingleton sharedManager]postResultWithParameter:nil url:MyCollection_List successBlock:^(id responseBody) {
        //NSLog(@"收藏列表-------%@",responseBody);
        __weak typeof(self) weakSelf = self;
        _resultarr = [responseBody objectForKey:@"result"];
        if ([responseBody[@"success"] isEqual:@1]) {
            self.hud.hidden = YES;
            for (int i = 0; i<weakSelf.resultarr.count; i++) {
                NSDictionary *dict = weakSelf.resultarr[i];
                CollectionModel *collection = [CollectionModel mj_objectWithKeyValues:dict];
                [self.collectionarray addObject:collection];
            }
            [self.tableView reloadData];
            if (_resultarr.count == 0) {
                [[Tool SharedInstance]showtoast:@"暂无收藏课程"];
            }
        }
        else
        {
            self.hud.hidden = YES;
            [[Tool SharedInstance]showtoast:responseBody[@"result"]];
        }
    } failureBlock:^(NSString *error) {
        NSLog(@"收藏errors--%@",error);
        self.hud.hidden = YES;
        [[Tool SharedInstance]showtoast:@"请稍后再试"];

    }];
}

- (void)setNav
{
    //设置导航栏字体及颜色
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSFontAttributeName:[UIFont systemFontOfSize:17],
       NSForegroundColorAttributeName:[UIColor whiteColor]}];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    //设置导航栏背景颜色
    self.navigationController.navigationBar.translucent  =  NO;
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"mainbg"]forBarMetrics:UIBarMetricsDefault];
    UIBarButtonItem *allBtn = [[UIBarButtonItem alloc]initWithTitle:@"全选" style:UIBarButtonItemStylePlain target:self action:@selector(AllSelect:)];
    UIBarButtonItem *deleteBtn = [[UIBarButtonItem alloc]initWithTitle:@"删除" style:UIBarButtonItemStylePlain target:self action:@selector(DeleteSelect:)];
    [self.navigationItem setRightBarButtonItems:[NSArray arrayWithObjects:deleteBtn, allBtn,nil]];
    UIBarButtonItem *backBtn = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"NaviBtn_Back@3x"] style:UIBarButtonItemStylePlain target:self action:@selector(backCenter)];
    self.navigationItem.leftBarButtonItem = backBtn;
    
    
}
//全选
- (void)AllSelect:(id)sender
{
    NSLog(@"全选");
    for (CollectionModel *model in self.collectionarray) {
        model.isChosed = YES;
    }
    [self.tableView reloadData];
}

- (void)DeleteSelect:(id)sender{
    self.courseIDs = [NSMutableString string];
    for (CollectionModel *model in self.collectionarray) {
        if(model.isChosed){
            //拼接mode.id
            self.courseIDs = (NSMutableString *)[self.courseIDs stringByAppendingString:[NSString stringWithFormat:@"%@,",model.courseId]];
        }
    }
    //没选中课程时点击删除时，id为空，ids没东西
    //当没选中课程时点击删除要弹出提示框
    if(self.courseIDs== nil&&self.courseID==nil){
        [[Tool SharedInstance]showtoast:@"亲，请先选中课程喔~"];
        
    }
    else if(self.courseIDs.length == 0){
        [[Tool SharedInstance]showtoast:@"亲，请先选中课程喔~"];
    }
    else {
        self.courseIDs = (NSMutableString *)[self.courseIDs substringToIndex:[self.courseIDs length] - 1];
        NSDictionary *dict = @{@"ids":self.courseIDs};
        __weak typeof(self) weakSelf = self;
        [[NetworkSingleton sharedManager]postResultWithParameter:dict url:Delete_MyCollection successBlock:^(id responseBody) {
            NSLog(@"删除---%@---%@",responseBody[@"result"],responseBody[@"msg"]);
            [weakSelf loadCollectionDataWithCompletionHandle:^{
            }];
            
        } failureBlock:^(NSString *error) {
            NSLog(@"删除收藏的错误信息--error %@",error);
        }];
    }
    
}

- (void)backCenter
{
    VideoViewController *vvc= [[VideoViewController alloc]init];
    [self.mm_drawerController setCloseDrawerGestureModeMask:MMCloseDrawerGestureModeAll];
    [self.mm_drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeAll];
    [self.navigationController pushViewController:vvc animated:YES];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.collectionarray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 177;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CollectionCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellid"];
    cell.delegate = self;
    cell.selectBtn.tag = indexPath.row;
    CollectionModel *collection = self.collectionarray[indexPath.row];
    [cell setCollectionModel:collection];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    VideoViewController *vccc = [VideoViewController sharedVideoViewController];
    //更新三个label，传个播放视频的url，章节列表
    NSDictionary *dict = self.resultarr[indexPath.row];
    [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"ISNOTICE"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"UpdateColloctionData" object:nil userInfo:dict];
    
    [self.navigationController pushViewController:vccc animated:YES];
}
- (void)choseTerm:(CollectionModel *)model{
    NSLog(@"按钮被点击%@",model.courseId);
    self.courseID = model.courseId;
}

@end
