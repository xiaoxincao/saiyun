//
//  SignViewController.h
//  CloudPlatform
//
//  Created by cying on 15/8/14.
//  Copyright (c) 2015年 cying. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SignViewControllerDelegate <NSObject>

- (void)savesign:(NSString *)sign;

@end

@interface SignViewController : UIViewController

@property (strong, nonatomic) IBOutlet UITextField *signTextField;

@property (nonatomic, strong)NSString *signstr;

@property (nonatomic, assign)id<SignViewControllerDelegate>delegate;

@end
