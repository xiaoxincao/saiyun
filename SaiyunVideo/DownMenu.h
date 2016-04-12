//
//  DownMenu.h
//  CloudPlatform
//
//  Created by cying on 15/9/6.
//  Copyright (c) 2015年 cying. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DownMenu : NSObject

@property (nonatomic,copy)void (^selectedItemBlock)(NSInteger index,NSString *selectedTitle);
@property (nonatomic,copy)void (^selectedchapterBlock)(NSArray *chapterarr);//传入视频名称，简介，路径
@property (nonatomic,copy)NSMutableArray *dataArray;



- (instancetype)initWithUPTitleArray:(NSArray *)titlearray andSensionArray:(NSArray *)sensionarray andDetailArray:(NSArray *)detailarray andAllArray:(NSArray *)allarray;

- (instancetype)initWithDownTitleArray:(NSArray *)titleArray;

@property (nonatomic,assign)BOOL isHidden;//下拉菜单的隐藏
@end
