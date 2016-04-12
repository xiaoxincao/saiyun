//
//  ReloadView.h
//  HandsForLoL
//
//  Created by lanou3g on 15/7/23.
//  Copyright (c) 2015年 吴非凡. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ReloadView : UIView

+ (instancetype)reloadViewWithFrame:(CGRect)frame
                             target:(id)target
                             action:(SEL)action;


+ (instancetype)reloadViewWithFrame:(CGRect)frame
                      btnClickBlock:(void (^)())btnClickBlock;

@end
