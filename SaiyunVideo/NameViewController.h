//
//  NameViewController.h
//  CloudPlatform
//
//  Created by cying on 15/8/14.
//  Copyright (c) 2015年 cying. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol NameViewControllerDelegate <NSObject>

- (void)saveName:(NSString *)name;

@end

@interface NameViewController : UIViewController
@property (strong, nonatomic) IBOutlet UITextField *nametextfield;

@property (assign, nonatomic)id<NameViewControllerDelegate>delegate;

@property (copy, nonatomic)NSString *namestr;

@end
