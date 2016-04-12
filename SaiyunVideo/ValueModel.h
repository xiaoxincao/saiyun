//
//  ValueModel.h
//  SaiyunVideo
//
//  Created by cying on 15/12/29.
//  Copyright (c) 2015年 cying. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ValueModel : NSObject

@property (nonatomic, copy)NSString *name;//

@property (nonatomic, copy)NSString *id;

@property (nonatomic, assign)NSInteger testItemNum;

@property (nonatomic, copy)NSString *courseId;

@property (nonatomic, copy)NSString *coursewareId;

@property (nonatomic, copy)NSString *preWareId;

@property (nonatomic, copy)NSString *nextWareId;

@property (nonatomic, copy)NSString *teacherName;//老师名字

@property (nonatomic, copy)NSString *teacherIntro;//老师详细信息

@property (nonatomic, copy)NSString *imagePath;//圆环的图片1

@property (nonatomic, copy)NSString *courseName;//2

@property (nonatomic, copy)NSString *photoPath;//教师头像3

@property (nonatomic, copy)NSString *percentComplete;//4

@property (nonatomic, copy)NSString *studyTime;//5

@property (nonatomic, copy)NSString *brief;//6

@property (nonatomic, copy)NSString *chapterId;

@property (nonatomic, copy)NSString *videoName;//字幕

@property (nonatomic, copy)NSString *positionTitle;

@property (nonatomic, copy)NSString *university;


@property (nonatomic, copy)NSString *playTime;//视频时长

@property (nonatomic, copy)NSString *lastStudyTime;

@property (nonatomic, copy)NSString *fullFilePath;//视频路径

@property (nonatomic, copy)NSString *descrip;//教师信息描述

@property (nonatomic, copy)NSString *sequence;

@property (nonatomic, assign)BOOL isSelected;

@property (nonatomic, copy)NSString *isTestPass;

@property (nonatomic, assign)NSInteger isCollection;


@end
