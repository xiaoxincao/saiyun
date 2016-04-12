//
//  ClearView.m
//  CloudPlatform
//
//  Created by cying on 15/9/6.
//  Copyright (c) 2015年 cying. All rights reserved.
//

#import "ClearView.h"

@implementation ClearView

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (_touchBlock) {
        _touchBlock();
    }
}

@end
