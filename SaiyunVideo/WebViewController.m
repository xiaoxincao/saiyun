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
    //创建url
    NSURL *url = [NSURL URLWithString:Company];
    //创建请求
    NSURLRequest *request=[NSURLRequest requestWithURL:url];
    
    //加载请求页面
    [self.webview loadRequest:request];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
