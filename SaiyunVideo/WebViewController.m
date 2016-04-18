//
//  WebViewController.m
//  SaiyunVideo
//
//  Created by cying on 16/4/18.
//  Copyright © 2016年 cying. All rights reserved.
//

#import "WebViewController.h"

@interface WebViewController ()

@end

@implementation WebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self request];
}

- (void)request
{
    NSString *urlstr = @"http://www.cying.com.cn";
    
    //创建url
    NSURL *url = [NSURL URLWithString:urlstr];
    //创建请求
    NSURLRequest *request=[NSURLRequest requestWithURL:url];
    
    //加载请求页面
    [self.webview loadRequest:request];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
