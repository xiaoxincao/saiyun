//
//  ClassifyModel.m
//  SaiyunVideo
//
//  Created by cying on 15/11/30.
//  Copyright (c) 2015年 cying. All rights reserved.
//

#import "ClassifyModel.h"

@implementation ClassifyModel

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    NSLog(@"%@, error key : %@", NSStringFromClass([self class]), key);
}

//- (void)setValue:(id)value forKey:(NSString *)key{
//    if ([key isEqualToString:@"description"]) {
//        [super setValue:value forKey:@"descrip"];
//    }else
//        [super setValue:value forKey:key];
//}

@end
