//
//  ClassifyModel.h
//  SaiyunVideo
//
//  Created by cying on 15/11/30.
//  Copyright (c) 2015年 cying. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ClassifyModel : NSObject

@property (nonatomic, copy)NSString *name;//章节名称

@property (nonatomic, copy)NSString *description;//老师的详细描述

@property (nonatomic, copy)NSString *fullFilePath;//视频的播放路径

@property (nonatomic, copy)NSString *preWareId;//前一个视频id

@property (nonatomic, copy)NSString *nextWareId;//下一个视频id

@property (nonatomic, copy)NSString *id;//本视频id

@property (nonatomic, copy)NSString *videoExtName;//视频路径的后缀

@property (nonatomic, copy)NSString *playTime;//视频播放时间

@property (nonatomic, copy)NSString *videoName;

@end
