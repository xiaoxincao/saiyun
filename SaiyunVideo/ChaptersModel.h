//
//  ChaptersModel.h
//  SaiyunVideo
//
//  Created by cying on 15/12/1.
//  Copyright (c) 2015年 cying. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ChaptersModel : NSObject

@property (nonatomic, copy)NSString *keyName;//章节名字

@property (nonatomic, copy)NSString *name;

@property (nonatomic, copy)NSMutableArray *value;



@property (nonatomic, copy)NSString *playTime;//视频时长

@property (nonatomic, copy)NSString *lastStudyTime;

@property (nonatomic, copy)NSString *fullFilePath;//视频路径

@property (nonatomic, copy)NSString *descrip;//教师信息描述

@property (nonatomic, copy)NSNumber *sequence;



@end
