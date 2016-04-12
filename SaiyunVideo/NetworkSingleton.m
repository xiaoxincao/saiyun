//
//  NetworkSingleton.m
//  文件.h
//
//  Created by Alesary on 15/9/15.
//  Copyright (c) 2015年 Alesary. All rights reserved.
//

#import "NetworkSingleton.h"

@interface NetworkSingleton()
{
    AFHTTPRequestOperationManager * _manager;
}
@end
@implementation NetworkSingleton


+(NetworkSingleton *)sharedManager{
    static NetworkSingleton *sharedNetworkSingleton = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate,^{
        sharedNetworkSingleton = [[self alloc] init];
    });
    return sharedNetworkSingleton;
}

-(id)init
{
    if (self=[super init]) {
        _manager=[AFHTTPRequestOperationManager manager];
    }
    return self;
}

-(AFHTTPRequestOperationManager *)baseHtppRequest{
    //AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [_manager.requestSerializer setTimeoutInterval:20];
    //_manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    //header 设置
    
    //    [manager.requestSerializer setValue:K_PASS_IP forHTTPHeaderField:@"Host"];
    //    [manager.requestSerializer setValue:@"max-age=0" forHTTPHeaderField:@"Cache-Control"];
    //    [manager.requestSerializer setValue:@"text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8" forHTTPHeaderField:@"Accept"];
    //    [manager.requestSerializer setValue:@"zh-cn,zh;q=0.8,en-us;q=0.5,en;q=0.3" forHTTPHeaderField:@"Accept-Language"];
    //    [manager.requestSerializer setValue:@"gzip, deflate" forHTTPHeaderField:@"Accept-Encoding"];
    //    [manager.requestSerializer setValue:@"keep-alive" forHTTPHeaderField:@"Connection"];
    //    [manager.requestSerializer setValue:@"Mozilla/5.0 (Macintosh; Intel Mac OS X 10.10; rv:35.0) Gecko/20100101 Firefox/35.0" forHTTPHeaderField:@"User-Agent"];
    
    _manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/plain", @"text/html",@"application/javascript",@"application/json", nil];
    
    return _manager;
}

-(void)getResultWithParameter:(NSDictionary *)parameter url:(NSString *)url successBlock:(SuccessBlock)successBlock failureBlock:(FailureBlock)failureBlock
{
    if (![Tool checkConectedWhileFaildShowReloadViewInView:[UIApplication sharedApplication].keyWindow reloadBlock:^{
        [[NetworkSingleton sharedManager]getResultWithParameter:parameter url:url successBlock:successBlock failureBlock:failureBlock];
    }])
    {
        return ;
    }
    [self setCoookie];
    AFHTTPRequestOperationManager *manager = [self baseHtppRequest];
    NSString *urlStr = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [manager GET:urlStr parameters:parameter success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         //NSLog(@"GET----SUccessoperation--%@---responseobject-%@",operation.responseString,responseObject);
         
         successBlock(responseObject);
     }
         failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         if ([operation.responseString  isEqual: @"gotoLogin"]) {
             //跳到登录页面，重新登录，提示登录失效
             [[Tool SharedInstance]showtoast:@"登录超时了，重新登录喔~"];
             LogInViewController *ll = [[LogInViewController alloc]init];
             UINavigationController *na = [[UINavigationController alloc]initWithRootViewController:ll];
             [AppDelegate appdelegate].window.rootViewController = na;
             
             
         }
         NSString *errorStr = [error.userInfo objectForKey:@"NSLocalizedDescription"];
         NSLog(@"GET--ERRR---%@",errorStr);
         NSLog(@"GET--EERRRSSTRR---%@",error);
         NSLog ( @"GET--operation: %@" , operation.responseString );
         failureBlock(errorStr);
         //[[Tool SharedInstance]showtoast:errorStr];
     }];
}

-(void)postResultWithParameter:(NSDictionary *)parameter url:(NSString *)url successBlock:(SuccessBlock)successBlock failureBlock:(FailureBlock)failureBlock
{
    if (![Tool checkConectedWhileFaildShowReloadViewInView:[UIApplication sharedApplication].keyWindow reloadBlock:^{
        [[NetworkSingleton sharedManager]postResultWithParameter:parameter url:url successBlock:successBlock failureBlock:failureBlock];
    }]) {
        return ;
    }
    //设置cookie
    [self setCoookie];
    AFHTTPRequestOperationManager *manager = [self baseHtppRequest];
    NSString *urlStr = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    
   
    [manager POST:urlStr parameters:parameter success:^(AFHTTPRequestOperation *operation, id responseObject){
        //NSLog(@"--para--%@--rsppp---%@--url--%@--opersa---%@",parameter,responseObject,urlStr,operation.responseString);
        successBlock(responseObject);
        

        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error){
        NSString *errorStr = [error.userInfo objectForKey:@"NSLocalizedDescription"];
        NSLog(@"EERRRSSTRR---%@",error);
        NSLog ( @"operation: %@" , operation.responseString );
        failureBlock(errorStr);
        NSLog(@"--url--%@",url);
        //[[Tool SharedInstance]showtoast:@"获取数据失败"];
    }];
}


-(void)upImageWithParameter:(NSDictionary *)parameter imageArray:(NSArray *)images url:(NSString *)url successBlock:(SuccessBlock)successBlock failureBlock:(FailureBlock)failureBlock
{
    AFHTTPRequestOperationManager *manger=[self baseHtppRequest];
    NSString *urlStr=[url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [manger POST:urlStr parameters:parameter constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
        for (int i=1; i<=images.count; i++) {
            
            NSData *imageData=UIImageJPEGRepresentation(images[i-1], 1.0);
            
            [formData appendPartWithFileData:imageData name:@"photo"
                                    fileName:
             [NSString stringWithFormat:@"image%d.png",i]
                                    mimeType:@"photo/png"];
        }
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        successBlock(responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSString *errorStr = [error.userInfo objectForKey:@"NSLocalizedDescription"];
        failureBlock(errorStr);
    }];
}

#pragma mark 删除cookie
- (void)deleteCookie
{
    NSHTTPCookieStorage *cookieStorage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    NSArray *cookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies];
    
    //删除cookie
    for (NSHTTPCookie *tempCookie in cookies) {
        [cookieStorage deleteCookie:tempCookie];
    }
    
    //把cookie打印出来，检测是否已经删除
    NSArray *cookiesAfterDelete = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies];
    for (NSHTTPCookie *tempCookie in cookiesAfterDelete) {
        NSLog(@"cookieAfterDelete: %@", tempCookie);
    }
    NSLog(@"\n");
}

- (void)setCoookie
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
            //NSLog(@"------%@",sessionid);
            [cookieStorage setCookie:(NSHTTPCookie *)cookie];
        }
    }else{
        NSLog(@"无cookie");
    }
}


@end
