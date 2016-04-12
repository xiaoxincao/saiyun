//
//  AppDelegate.m
//  SaiyunVideo
//
//  Created by cying on 15/11/16.
//  Copyright (c) 2015年 cying. All rights reserved.
//

#import "AppDelegate.h"
#import "LogInViewController.h"
#import "GuideViewController.h"

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
    
    //注册监控网络通知，随时通知用户
    
    Reachability *reachability = [Reachability reachabilityWithHostName:@"www.baidu.com"];
    [reachability startNotifier];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityChanged:) name:kReachabilityChangedNotification object:nil];
    
    BOOL ssss = [[NSUserDefaults standardUserDefaults]boolForKey:LogSuccess];
    
    if(!ssss){

        FirstViewController *firstvc = [[FirstViewController alloc]init];
        UINavigationController *fa = [[UINavigationController alloc]initWithRootViewController:firstvc];
        self.window.rootViewController = fa;
        
 
//        GuideViewController *guidevc = [[GuideViewController alloc]init];
//        
//        self.window.rootViewController = guidevc;
        
        [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"logisroot"];
        [[NSUserDefaults standardUserDefaults]synchronize];
    }
    else
    {
        self.window.rootViewController = _drawerController;
    }
    
    
    
    //判断是否第一次启动
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"everLaunched"]) {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"everLaunched"];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"firstLaunch"];
    }
    else{
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"firstLaunch"];
    }
    return YES;
}

- (void)reachabilityChanged:(NSNotification *)notification
{
    Reachability *curReachability = [notification object];
    NSParameterAssert([curReachability isKindOfClass:[Reachability class]]);
    NetworkStatus curStatus = [curReachability currentReachabilityStatus];
    
    
    if(curStatus == NotReachable) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"网络连接失败"message:nil
                                                       delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
        NSLog(@"网络链接失败");
        [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"noreachable"];
        [[NSUserDefaults standardUserDefaults]synchronize];
    }else if (curStatus == ReachableViaWiFi) {
        [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"4g"];
        [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"noreachable"];
        [[NSUserDefaults standardUserDefaults]synchronize];
        NSLog(@"wifi--");
        //[[Tool SharedInstance]showtoast:@"wifi网络下可尽情浏览视频"];
    }else if(curStatus == ReachableViaWWAN){
        NSLog(@"4g网络");
        [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"4g"];
        [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"noreachable"];
        [[NSUserDefaults standardUserDefaults]synchronize];
        [[Tool SharedInstance]showtoast:@"当前为运营商网络，请注意流量的使用"];
    }
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    //如果是第一个登录界面，退出后台时就会闪退
    //进入后台
    NSLog(@"进入后台");
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"ISNOTICE"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    NSString *studystr = [[NSUserDefaults standardUserDefaults]objectForKey:StudyTime];
    NSString *totalstr = [[NSUserDefaults standardUserDefaults]objectForKey:TotalTime];
    NSString *wareid = [[NSUserDefaults standardUserDefaults]objectForKey:CoursewareID];
    NSString *courid = [[NSUserDefaults standardUserDefaults]objectForKey:@"valuemodelid"];
    if ([studystr intValue] != 0||studystr != nil) {
        if (wareid == nil) {
            NSDictionary *dict = @{@"coursewareId":courid,@"studyTime":studystr,@"totalTime":totalstr};
            //如果有视频播放再上传时间
            [[NetworkSingleton sharedManager]getResultWithParameter:dict url:String_Save_Video_Exit_Info successBlock:^(id responseBody) {
                NSLog(@"后台上传播放时间成功---%@--%@",responseBody[@"result"],responseBody[@"msg"]);
                
            } failureBlock:^(NSString *error) {
                NSLog(@"上传播放时间失败");
            }];
        }else{
        NSDictionary *dict = @{@"coursewareId":wareid,@"studyTime":studystr,@"totalTime":totalstr};
        
        //如果有视频播放再上传时间
        [[NetworkSingleton sharedManager]getResultWithParameter:dict url:String_Save_Video_Exit_Info successBlock:^(id responseBody) {
            NSLog(@"后台上传播放时间成功---%@--%@",responseBody[@"result" ],responseBody[@"msg"]);
            
        } failureBlock:^(NSString *error) {
            NSLog(@"上传播放时间失败");
        }];
       }
    }
}





- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
