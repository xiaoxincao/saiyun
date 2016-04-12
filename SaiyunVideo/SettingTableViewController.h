//
//  SettingTableViewController.h
//  CloudPlatform
//
//  Created by cying on 15/7/31.
//  Copyright (c) 2015年 cying. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PersonInfo.h"


@interface SettingTableViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong)PersonInfo *setpersonmodel;


@end
