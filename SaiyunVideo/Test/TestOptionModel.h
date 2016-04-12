//
//  TestOptionModel.h
//  SaiyunVideo
//
//  Created by cying on 16/1/21.
//  Copyright © 2016年 cying. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TestOptionModel : NSObject


@property (nonatomic, copy)NSString *text;

@property (nonatomic, copy)NSString *id;//anwserid

@property (nonatomic, copy)NSString *value;//value

@property (nonatomic, assign)BOOL isChosed;

@property (nonatomic, assign)BOOL isLast;

@end
