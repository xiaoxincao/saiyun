//
//  AppDelegate+XBNetworkingMonitor.m
//  XBBusinessServiceDemo
//
//  Created by Scarecrow on 15/9/26.
//  Copyright (c) 2015年 XB. All rights reserved.
//

#import "AppDelegate+XBNetworkingMonitor.h"


@implementation AppDelegate(XBNetworkingMonitor)

- (void)startMonitor
{
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        if (status == AFNetworkReachabilityStatusNotReachable) {
            NSLog(@"无网络");
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"网络连接失败"message:nil
                                                           delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [alert show];
            [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"noreachable"];
            [[NSUserDefaults standardUserDefaults]synchronize];
        }
        else if (status == AFNetworkReachabilityStatusReachableViaWWAN)
        {
            NSLog(@"运营商网络");
            [[NSUserDefaults standardUserDefaults]setBool:YES forKey:Flow];
            [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"noreachable"];
            [[NSUserDefaults standardUserDefaults]synchronize];
            //当4g网络时发送通知
            [[NSNotificationCenter
              defaultCenter]postNotificationName:NetworkViaWWAN object:nil];
            [[Tool SharedInstance]showtoast:@"当前为运营商网络，请注意流量的使用"];
        }else if(status == AFNetworkReachabilityStatusReachableViaWiFi){
            NSLog(@"WiFi网络");
            [[NSUserDefaults standardUserDefaults]setBool:NO forKey:Flow];
            [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"noreachable"];
            [[NSUserDefaults standardUserDefaults]synchronize];

        }
    }];

}

@end
