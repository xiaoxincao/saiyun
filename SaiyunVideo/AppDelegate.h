//
//  AppDelegate.h
//  SaiyunVideo
//
//  Created by cying on 15/11/16.
//  Copyright (c) 2015年 cying. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MMDrawerController.h"
@interface AppDelegate : UIResponder <UIApplicationDelegate>



@property (strong, nonatomic) UIWindow *window;

@property (nonatomic, strong)MMDrawerController * drawerController;
+ (AppDelegate *)appdelegate;
@end

