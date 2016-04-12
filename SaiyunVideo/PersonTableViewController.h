//
//  PersonTableViewController.h
//  CloudPlatform
//
//  Created by cying on 15/8/13.
//  Copyright (c) 2015年 cying. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PersonInfo.h"

@class PersonTableViewController;

@protocol PersonTableViewControllerDelegate <NSObject>

-(void)PersonTableViewController:(PersonTableViewController*)PersonTableViewController didSelectIcon:(UIImage*)image;

@end
@interface PersonTableViewController : UITableViewController

@property (nonatomic, strong)PersonInfo *personmodel;

@property (nonatomic,weak)id <PersonTableViewControllerDelegate> delegate;
@property (nonatomic,strong)NSMutableArray *detailArray;

@end
