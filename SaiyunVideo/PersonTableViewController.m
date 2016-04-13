//
//  PersonTableViewController.m
//  CloudPlatform
//
//  Created by cying on 15/8/13.
//  Copyright (c) 2015年 cying. All rights reserved.
//

#import "PersonTableViewController.h"
#import "SignViewController.h"
#import "NameViewController.h"
#import "LogInViewController.h"
#import "PersonInfo.h"


#define EducaTag 14
#define SexTag 15

@interface PersonTableViewController ()<NameViewControllerDelegate,SignViewControllerDelegate,UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    NSArray *titleArray;
    UIImageView *headerimage;
}
@end

@implementation PersonTableViewController
@synthesize detailArray;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initNavigation];
    self.navigationController.navigationBar.hidden = NO;

    
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    [self.tableView setTableFooterView:view];
    
    [self setcellName];
}

- (void)setcellName
{
    titleArray = [NSArray arrayWithObjects:@"签名",@"昵称",@"性别",@"邮箱绑定", nil];
    detailArray = [NSMutableArray arrayWithObjects:@"",@"这个人很懒，什么都没有留下",@"未填写",@"未填写",@"未填写", nil];
    NSUserDefaults *userdefault = [NSUserDefaults standardUserDefaults];
    NSString *name = [userdefault objectForKey:NiceName];
    NSString *sex = [userdefault objectForKey:Sex];
    NSString *email = [userdefault objectForKey:E_mail];
    NSString *sign = [userdefault objectForKey:Sign];
    if (sign) {
        [detailArray replaceObjectAtIndex:1 withObject:sign];
    }
    if (name) {
        [detailArray replaceObjectAtIndex:2 withObject:name];
    }
    if (sex) {
        [detailArray replaceObjectAtIndex:3 withObject:sex];
    }
    if (email) {
        [detailArray replaceObjectAtIndex:4 withObject:email];
    }
}

#pragma mark-获取用户信息
- (void)getuserInfo
{
    [[NetworkSingleton sharedManager]postResultWithParameter:nil url:GetUserInfo successBlock:^(id responseBody) {
        NSDictionary *resultdict = [responseBody objectForKey:@"result"];
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
        }
        else
        {
        }
    } failureBlock:^(NSString *error) {
        NSLog(@"Menu里获取用户信息错误");
    }];

}


- (void)saveName:(NSString *)name{
    [detailArray replaceObjectAtIndex:2 withObject:name];
    [self.tableView reloadData];
}

- (void)savesign:(NSString *)sign{
    [detailArray replaceObjectAtIndex:1 withObject:sign];
    [self.tableView reloadData];
}

#pragma mark -
#pragma mark 初始化导航栏
- (void)initNavigation
{
    self.title = @"个人资料";
    UIBarButtonItem *saveBtn = [[UIBarButtonItem alloc]initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(Save)];
    self.navigationItem.rightBarButtonItem = saveBtn;
}


#pragma mark -
#pragma mark 保存方法
- (void)Save{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSUserDefaults *userdefault = [NSUserDefaults standardUserDefaults];
    NSString *IDD = [userdefault objectForKey:ID];
    
        //上传个人资料
        NSDictionary *personinfoDict = @{@"description":detailArray[1],@"name":detailArray[2],@"sex":detailArray[3],@"id": IDD,@"email":detailArray[4]};
        [[NetworkSingleton sharedManager] postResultWithParameter:personinfoDict url:UpdateUserInfo successBlock:^(id responseBody) {
            NSDictionary *resultdict = [responseBody objectForKey:@"result"];
            NSInteger success = [[resultdict objectForKey:@"success"]integerValue];
            if (success == 1) {
                //修改后的资料存在本地
                [[NSUserDefaults standardUserDefaults] setObject:detailArray[1] forKey:Sign];
                [[NSUserDefaults standardUserDefaults] setObject:detailArray[2] forKey:NiceName];
                [[NSUserDefaults standardUserDefaults] setObject:detailArray[3] forKey:Sex];
                [[NSUserDefaults standardUserDefaults] synchronize];
                //[[Tool SharedInstance]showtoast:[resultdict objectForKey:@"msg"]];
            }
            else{
                NSLog(@"上传资料失败");
            }
        } failureBlock:^(NSString *error) {
        }];
    
       NSDictionary *headerdict = @{@"photo":@"png",@"id":IDD};
       NSArray *imagearray = [[NSArray alloc]initWithObjects:headerimage.image, nil];

        [[NetworkSingleton sharedManager]upImageWithParameter:headerdict imageArray:imagearray url:Upload_Headportrait successBlock:^(id responseBody) {
    
            NSDictionary *resultdict = [responseBody objectForKey:@"result"];
            NSInteger success = [[resultdict objectForKey:@"success"]integerValue];
            
            if (success == 1) {
                [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                NSLog(@"更新成功%@", resultdict[@"msg"]);
                [[Tool SharedInstance]showtoast:@"更新个人信息成功"];
                [self getuserInfo];
                
            }else
            {
                NSLog(@"--失败-%@",resultdict[@"msg"]);
            }
        } failureBlock:^(NSString *error) {
            NSLog(@"上传头像失败");
        }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return titleArray.count+1;
}

#pragma mark -
#pragma mark - 重用cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSUInteger row = [indexPath row];
    if (row == 0) {
        static NSString *cellID = @"cellID";
        UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:cellID];
        if (cell == nil) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellID];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
        cell.textLabel.text = @"头像";
        headerimage = [[UIImageView alloc]init];
        headerimage.frame = CGRectMake(kScreenWidth-60, 10, 30, 30);
        
        NSUserDefaults *userdefault = [NSUserDefaults standardUserDefaults];
        NSString *header = [userdefault objectForKey:Header];
        if (header != nil) {
        NSMutableString *mutableuserHeader = [NSMutableString stringWithString:header];
        //设置用户头像
        NSString *userHeaderInfo = [PersonPort stringByAppendingString:mutableuserHeader];
        [headerimage sd_setImageWithURL:[NSURL URLWithString:userHeaderInfo] placeholderImage:[UIImage imageNamed:@"default_point@3x"]];
        }else{
            headerimage.image = [UIImage imageNamed:@"default_point@3x"];
        }
        [cell.contentView addSubview:headerimage];
        
        return  cell;
        
    }
    else{
        static NSString *cellID = @"cellID";
        UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:cellID];
        if (cell == nil) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellID];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
        cell.textLabel.text = titleArray[indexPath.row-1];
        cell.detailTextLabel.text = detailArray[indexPath.row];
        cell.detailTextLabel.font = [UIFont systemFontOfSize:14];
        return cell;
    }
}


#pragma mark -
#pragma mark - cell的点击事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        UIActionSheet* actionSheet = [[UIActionSheet alloc]initWithTitle:@"请选择图片" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"打开相机",@"从相册中选取", nil];
        
        actionSheet.delegate = self;
        [actionSheet showInView:self.view];
    }else if (indexPath.row == 1)
    {
        //签名
        SignViewController *signvc = [[SignViewController alloc]init];
        signvc.delegate = self;
        [self.navigationController pushViewController:signvc animated:YES];

    }else if (indexPath.row == 2){
        //昵称
        NameViewController *namevc = [[NameViewController alloc]init];
        namevc.delegate = self;
        [self.navigationController pushViewController:namevc animated:YES];

    }else if (indexPath.row == 3){
        UIAlertView *sex = [[UIAlertView alloc]initWithTitle:@"设置性别" message:@"" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"男",@"女", nil];
        sex.tag = SexTag;
        [sex show];
    }else {
        NSLog(@"邮箱绑定");
    }
}

#pragma mark -
#pragma mark -AlertView的点击事件
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    switch (buttonIndex) {
        case 1:
            detailArray[3] = @"男";
            [self.tableView reloadData];
            break;
        case 2:
            detailArray[3] = @"女";
            [self.tableView reloadData];
            break;
        default:
            break;
    }
}

//更换头像弹框对应的方法
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    switch (buttonIndex) {
        case 0:
            [self takePhoto];
            break;
        case 1:
            [self localPhoto];
            break;
        default:
            break;
    }
}

//获取照相机
-(void)takePhoto{
    UIImagePickerController* picker = [[UIImagePickerController alloc]init];
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    picker.delegate = self;
    picker.allowsEditing =YES;
    [self presentViewController:picker animated:YES completion:nil];
}

//获取本地图库
-(void)localPhoto{
    UIImagePickerController *picker = [[UIImagePickerController alloc]init];
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    picker.delegate = self;
    picker.allowsEditing = YES;
    [self presentViewController:picker animated:YES completion:nil];
}

#pragma mark pick delegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo{
    
    [headerimage setImage:image];
    
    [self.delegate PersonTableViewController:self didSelectIcon:image];
    
    [self dismissViewControllerAnimated:YES completion:^{
//        UIAlertView* alert = [[UIAlertView alloc]initWithTitle:nil message:@"头像更换成功" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
//        [alert show];
    }];
    
}


@end
