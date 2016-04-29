//
//  AppDelegate.m
//  SaiyunVideo
//
//  Created by cying on 15/11/16.
//  Copyright (c) 2015年 cying. All rights reserved.
//

#import "AppDelegate.h"
#import "AppDelegate+UploadPlayTime.h"
#import "LogInViewController.h"
#import "GuideViewController.h"
#import <shareSDKConstants.h>

@interface AppDelegate ()<UIAlertViewDelegate>



@end

@implementation AppDelegate



+ (AppDelegate *)appdelegate{
    return (AppDelegate *)[UIApplication sharedApplication].delegate;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    //设置状态条的字颜色为白色
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
    //设置侧栏
    VideoViewController *center = [[VideoViewController alloc]init];
    UINavigationController *nav1 = [[UINavigationController alloc]initWithRootViewController:center];
    MenuViewController *leftDrawer = [[MenuViewController alloc]init];
    UINavigationController *nav2 = [[UINavigationController alloc]initWithRootViewController:leftDrawer];
    _drawerController = [[MMDrawerController alloc]
                         initWithCenterViewController:nav1
                         leftDrawerViewController:nav2
                         rightDrawerViewController:nil];
    [_drawerController setMaximumLeftDrawerWidth:[[UIScreen mainScreen] bounds].size.width -100.0f];
    [_drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeAll];
    [_drawerController setCloseDrawerGestureModeMask:MMCloseDrawerGestureModeAll];
    
    //监听网络的方法
    [self startMonitor];
    
    BOOL ssss = [[NSUserDefaults standardUserDefaults]boolForKey:LogSuccess];
    if(!ssss){
        FirstViewController *firstvc = [[FirstViewController alloc]init];
        UINavigationController *fa = [[UINavigationController alloc]initWithRootViewController:firstvc];
        self.window.rootViewController = fa;
        
        [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"logisroot"];
        [[NSUserDefaults standardUserDefaults]synchronize];
    }
    else
    {
        self.window.rootViewController = _drawerController;
    }
    
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    //如果是第一个登录界面，退出后台时就会闪退
    NSLog(@"进入后台");
    //进入后台时上传播放时间
    [self uploadplaytime];
}





- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

@end
