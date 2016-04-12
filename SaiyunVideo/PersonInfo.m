//
//  PersonInfo.m
//  CloudPlatform
//
//  Created by cying on 15/9/24.
//  Copyright (c) 2015年 cying. All rights reserved.
//

#import "PersonInfo.h"

@implementation PersonInfo



- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    NSLog(@"%@, error key : %@", NSStringFromClass([self class]), key);
}

@end
