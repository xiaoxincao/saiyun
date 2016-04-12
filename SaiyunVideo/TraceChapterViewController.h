//
//  TraceChapterViewController.h
//  SaiyunVideo
//
//  Created by cying on 16/2/23.
//  Copyright © 2016年 cying. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TraceChapterViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>


@property (nonatomic, strong)UITableView *traceChaptable;

@property (nonatomic, strong) NSArray *dataarray;

@property (nonatomic, strong) NSString *courseId;

@property (nonatomic, strong)NSString *coursewareId;

@end
