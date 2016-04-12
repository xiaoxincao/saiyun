//
//  MenuViewController.h
//  SaiyunVideo
//
//  Created by cying on 15/11/17.
//  Copyright (c) 2015年 cying. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MenuViewController : UIViewController
@property (strong, nonatomic) IBOutlet UIView *MenuHeaderView;
@property (strong, nonatomic) IBOutlet UITableView *MenuTableview;

@property (strong, nonatomic) IBOutlet UIButton *userphoto;
@property (strong, nonatomic) IBOutlet UILabel *userLabel;


- (IBAction)ExitButton:(id)sender;

@property (strong, nonatomic) IBOutlet UIButton *userHeaderBtn;
@property (strong, nonatomic) IBOutlet UILabel *userNameLabel;
- (IBAction)userHeaderButton:(id)sender;


@end
