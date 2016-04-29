//
//  Tool.m
//  CloudPlatform
//
//  Created by cying on 15/9/6.
//  Copyright (c) 2015年 cying. All rights reserved.
//

#import "Tool.h"
#import "ReloadView.h"
#import "AppDelegate.h"
#define minshowtime   0.5

@interface Tool (){
    MBProgressHUD *toastHud;
    MBProgressHUD *progressHud;
    
}

@end

static Tool *tool;
@implementation Tool

+ (Tool *)SharedInstance{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken,^{
        tool = [[Tool alloc]init];
        [tool actionRenderUIComponents];
    });
    return tool;
}

#pragma mark -keyWindow
+ (UIWindow *)keyWindow {
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    UIWindow *keywindow = delegate.window;
    return keywindow;
}

#pragma mark -actionRenderUIComponents
- (void)actionRenderUIComponents {
    UIWindow *keywindow = [Tool keyWindow];
    toastHud = [[MBProgressHUD alloc] initWithWindow:keywindow];
    toastHud.minSize = CGSizeMake(220, 60);
    toastHud.userInteractionEnabled = NO;
    toastHud.mode = MBProgressHUDModeText;
    toastHud.minShowTime = minshowtime*2;
    //toastHud.color = [UIColor hexFloatColor:@"545454"];
    toastHud.alpha = 0.3;
    [keywindow addSubview:toastHud];
    progressHud = [[MBProgressHUD alloc] initWithWindow:keywindow];
    progressHud.animationType = MBProgressHUDAnimationFade;
    //progressHud.mode = MBProgressHUDModeCustomView;
    progressHud.userInteractionEnabled = YES;
    progressHud.minShowTime = minshowtime;
    progressHud.labelText = @"加载中...";
    progressHud.square = YES;
    //annurImageView = [[XiangQuAnnurImageView alloc] initWithFrame:CGRectMake(0, 0, 45, 45)];
    //progressHud.customView = annurImageView;
    [keywindow addSubview:progressHud];
}

#pragma mark -toast
- (void)showtoast:(NSString *)toastStr {
    if (toastStr.length > 0) {
        if (toastStr.length > 15) {
            toastHud.labelText = @"";
            toastHud.detailsLabelText = toastStr;
        } else {
            toastHud.labelText = toastStr;
            toastHud.detailsLabelText = @"";
        }
        [[Tool keyWindow] bringSubviewToFront:toastHud];
        [toastHud show:YES];
        [toastHud hide:YES];
    }
}

- (void)showtoast:(NSString *)toastStr wait:(double)wait
{
    toastHud.minShowTime = wait;
    [self showtoast:toastStr];
    toastHud.minShowTime = minshowtime * 2;
}


#pragma mark -progress
- (void)hideprogress {
    [progressHud hide:YES];
    [toastHud hide:YES];
}

- (void)showprogress {
    [toastHud hide:YES];
    [[Tool keyWindow] bringSubviewToFront:progressHud];
    [progressHud setMinShowTime:0];
    progressHud.labelText  = @"";
    //[tool actionCountProgress];
    [progressHud show:NO];
}



+ (BOOL)checkConectedWhileFaildShowReloadViewInView:
(UIView *)view
                                        reloadBlock:(void (^)())reloadBlock
{
    if ([Reachability reachabilityForInternetConnection].currentReachabilityStatus == NotReachable && [Reachability reachabilityForLocalWiFi].currentReachabilityStatus == NotReachable) {
        ReloadView *reloadView = [ReloadView reloadViewWithFrame:view.frame btnClickBlock:^{
            if (reloadBlock) {
                reloadBlock();
            }
        }];
        [view addSubview:reloadView];
        return NO;
    }
    return YES;
}


+ (void)showAlertWithTitle:(NSString *)title Message:(NSString *)message CancelbtnTitle:(NSString *)buttonTitle OtherBtnTitles:(NSString *)otherBtnTitles
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:buttonTitle otherButtonTitles: otherBtnTitles, nil];
    [alertView show];
}
// 加载数据基类
+ (void)loadDataByGetWithUrl:(NSURL *)url
            completionHandle:(void(^)(id result))completionHandle
{
    // 判断网络状态
    if (![Tool checkConectedWhileFaildShowReloadViewInView:[UIApplication sharedApplication].keyWindow reloadBlock:^{
        [[Tool SharedInstance]showtoast:@"当前已失去网络连接"];
        [Tool loadDataByGetWithUrl:url completionHandle:completionHandle];
    }]) {
        return ;
    }
    [Tool setCoookie];
    [NSURLConnection sendAsynchronousRequest:[NSURLRequest requestWithURL:url] queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        
        if (!data) {
            NSLog(@"没有网络数据");
            if (completionHandle) {
                completionHandle(nil);
            }
            return ;
        }
        id obj = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
        if (!obj) {
            NSLog(@"获取的数据无法解析");
            if (completionHandle) {
                completionHandle(nil);
            }
            return ;
        }
        
        if (completionHandle) {
            completionHandle(obj);
        }
        
        
        
    }];
}

+ (MBProgressHUD *)createHUD
{
    UIWindow *window = [[UIApplication sharedApplication].windows lastObject];
    MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithWindow:window];
    HUD.labelText = @"加载中...";
    HUD.labelColor = [UIColor whiteColor];
    HUD.color = [UIColor blackColor];
    HUD.alpha = 0.5;
    HUD.detailsLabelFont = [UIFont boldSystemFontOfSize:16];
    [window addSubview:HUD];
    [HUD show:YES];
    //[HUD addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:HUD action:@selector(hide:)]];
    
    return HUD;
}


+ (void)showHUD:(NSString *)text andView:(UIView *)view andHUD:(MBProgressHUD *)hud
{
    [view addSubview:hud];
    hud.labelText = text;//显示提示
    hud.dimBackground = YES;//使背景成黑灰色，让MBProgressHUD成高亮显示
    hud.square = YES;//设置显示框的高度和宽度一样
    [hud show:YES];
}
+ (void)hideHud
{
    
}
- (void)hide:(MBProgressHUD *)hud
{
    [hud hide:YES];
}
+ (void)setCoookie
{
    //NSLog(@"============再取出保存的cookie重新设置cookie===============");
    //取出保存的cookie
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    //对取出的cookie进行反归档处理
    NSArray *cookies = [NSKeyedUnarchiver unarchiveObjectWithData:[userDefaults objectForKey:@"cookie"]];
    
    if (cookies) {
        NSLog(@"有cookie");
        //设置cookie
        NSHTTPCookieStorage *cookieStorage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
        for (id cookie in cookies) {
            [cookieStorage setCookie:(NSHTTPCookie *)cookie];
        }
    }else{
        NSLog(@"无cookie");
    }
    
    //打印cookie，检测是否成功设置了cookie
    NSArray *cookiesA = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies];
    for (NSHTTPCookie *cookie in cookiesA) {
        //NSLog(@"setCookie: %@", cookie);
    }
    //NSLog(@"\n");
}

@end
