//
//  TestResultModel.h
//  SaiyunVideo
//
//  Created by cying on 16/1/21.
//  Copyright © 2016年 cying. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TestResultModel : NSObject


@property (nonatomic, copy)NSString *name;

@property (nonatomic, copy)NSString *type;

@property (nonatomic, copy)NSString *id;//questionid

@property (nonatomic, copy)NSArray *options;

@property (nonatomic, strong)UIButton *optionBtn;

@property (nonatomic, strong)NSString *isRight;

@property (nonatomic, strong)NSString *myAns;

@end
