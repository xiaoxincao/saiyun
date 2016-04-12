//
//  RegisterViewController.h
//  CloudPlatform
//
//  Created by cying on 15/8/5.
//  Copyright (c) 2015年 cying. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface RegisterViewController :UIViewController
@property (strong, nonatomic) IBOutlet UITextField *NameText;
@property (strong, nonatomic) IBOutlet UITextField *PhoneNumText;
@property (strong, nonatomic) IBOutlet UITextField *RegPassWordText;
@property (strong, nonatomic) IBOutlet UITextField *RegPassWordAgainText;
@property (strong, nonatomic) IBOutlet UITextField *EmailText;

@property (weak, nonatomic) IBOutlet UIButton *Getnodepro;
- (IBAction)GetnodeBtn:(id)sender;



- (IBAction)RegisterBtn:(id)sender;

@end
