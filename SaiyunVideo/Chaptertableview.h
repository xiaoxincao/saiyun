//
//  Chaptertableview.h
//  SaiyunVideo
//
//  Created by cying on 16/1/13.
//  Copyright (c) 2016年 cying. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Chaptertableview : UITableView<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) NSArray *dataarray;

@property (nonatomic, strong) NSString *courseId;

@property (nonatomic, strong)NSString *coursewareId;

@property (nonatomic, assign)int indexs;

@end
