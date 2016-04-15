//
//  AppDelegate+UploadPlayTime.m
//  SaiyunVideo
//
//  Created by cying on 16/4/15.
//  Copyright © 2016年 cying. All rights reserved.
//

#import "AppDelegate+UploadPlayTime.h"

@implementation AppDelegate (UploadPlayTime)

- (void)uploadplaytime
{
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
@end
