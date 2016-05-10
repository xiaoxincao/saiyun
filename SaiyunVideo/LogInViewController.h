//
//  LogInViewController.h
//  CloudPlatform
//
//  Created by cying on 15/8/5.
//  Copyright (c) 2015年 cying. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LogInViewController : UIViewController
@property (strong, nonatomic) IBOutlet UITextField *accountTextField;
@property (strong, nonatomic) IBOutlet UITextField *passwordTextField;
@property (strong, nonatomic) IBOutlet UIButton *logBtnoutlet;
@property (weak, nonatomic) IBOutlet UIButton *rememberpro;

@property (strong, nonatomic) MBProgressHUD *hud;
@property (strong, nonatomic) LogInViewController *login;

@property (nonatomic, assign) BOOL isRootview;


- (IBAction)rememberCode:(id)sender;

- (IBAction)forgetkeyBtn:(id)sender;
- (IBAction)logBtn:(id)sender;

@end
