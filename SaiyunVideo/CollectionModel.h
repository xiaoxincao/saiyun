//
//  CollectionModel.h
//  SaiyunVideo
//
//  Created by cying on 15/12/15.
//  Copyright (c) 2015年 cying. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CollectionModel : NSObject

@property (copy, nonatomic)NSString *courseName;

@property (copy, nonatomic)NSString *imagePath;

@property (copy, nonatomic)NSString *totalTime;

@property (copy, nonatomic)NSString *percentComplete;

@property (copy, nonatomic)NSString *courseId;

@property (assign,nonatomic)BOOL isChosed;

@end
