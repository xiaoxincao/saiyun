//
//  SliderView.h
//  XiaoWangMusic
//
//  Created by lanou3g on 15/7/8.
//  Copyright (c) 2015年 吴非凡. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SliderView : UIView

@property (nonatomic, strong) IBOutlet UILabel *minLabel;
@property (nonatomic, strong) IBOutlet UILabel *maxLabel;
@property (nonatomic, strong) IBOutlet UISlider *slider;

@property (nonatomic, assign) CGFloat maximumValue;
@property (nonatomic, assign) CGFloat minimumValue;
@property (nonatomic, assign) CGFloat value;

- (void)addTarget:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents;

- (void)setThumbImage:(UIImage *)image forState:(UIControlState)state;

@end
