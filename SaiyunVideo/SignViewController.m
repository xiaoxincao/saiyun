//
//  SignViewController.m
//  CloudPlatform
//
//  Created by cying on 15/8/14.
//  Copyright (c) 2015年 cying. All rights reserved.
//

#import "SignViewController.h"

@interface SignViewController ()

@end

@implementation SignViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"签名";
    UIBarButtonItem *signsaveBtn = [[UIBarButtonItem alloc]initWithTitle:@"保存" style:UIBarButtonItemStyleBordered target:self action:@selector(signsaveBtnClick)];
    self.navigationItem.rightBarButtonItem = signsaveBtn;
    
    
}
- (void)SAG
{
    
    
}
- (void)signsaveBtnClick{
    [self.delegate savesign:self.signTextField.text];
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
