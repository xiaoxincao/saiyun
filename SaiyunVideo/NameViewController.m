//
//  NameViewController.m
//  CloudPlatform
//
//  Created by cying on 15/8/14.
//  Copyright (c) 2015年 cying. All rights reserved.
//

#import "NameViewController.h"
#import "PersonTableViewController.h"

@interface NameViewController ()

@end

@implementation NameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"昵称";
    UIBarButtonItem *namesaveBtn = [[UIBarButtonItem alloc]initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(namesaveBtnClick)];
    self.navigationItem.rightBarButtonItem = namesaveBtn;
    
    self.nametextfield.placeholder = self.namestr;
}

- (void)namesaveBtnClick
{
    [self.delegate saveName:self.nametextfield.text];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
