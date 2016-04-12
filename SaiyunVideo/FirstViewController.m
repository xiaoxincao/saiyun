//
//  FirstViewController.m
//  SaiyunVideo
//
//  Created by cying on 16/4/7.
//  Copyright © 2016年 cying. All rights reserved.
//

#import "FirstViewController.h"
#import "RegisterViewController.h"
#import "LogInViewController.h"

@interface FirstViewController ()

@end

@implementation FirstViewController
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
 }

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)ResBtn:(id)sender {
    RegisterViewController *revc = [[RegisterViewController alloc]init];
    [self.navigationController pushViewController:revc animated:YES];
}

- (IBAction)LogBtn:(id)sender {
    LogInViewController *logvc = [[ LogInViewController alloc]init];
    [self.navigationController pushViewController:logvc animated:YES];
}
@end
