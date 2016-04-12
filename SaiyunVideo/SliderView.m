//
//  SliderView.m
//  XiaoWangMusic
//
//  Created by lanou3g on 15/7/8.
//  Copyright (c) 2015年 吴非凡. All rights reserved.
//

#import "SliderView.h"

#define kLabelWidth 40
#define kLabelHeight 40

@interface SliderView ()



@end

@implementation SliderView

- (void)awakeFromNib
{

}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self addAllViews];
    }
    return self;
}

- (void)addAllViews
{
    self.minLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kLabelWidth, kLabelHeight)];
    _minLabel.font = [UIFont systemFontOfSize:14];
    [self addSubview:_minLabel];
    
    self.slider = [[UISlider alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_minLabel.frame), 0, self.frame.size.width - kLabelWidth * 2, 10)];
    CGPoint center = _slider.center;
    center.y = _minLabel.center.y;
    _slider.center = center;
    [self addSubview:_slider];
    
    self.maxLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_slider.frame), 0, kLabelWidth, kLabelHeight)];
    _maxLabel.font = [UIFont systemFontOfSize:14];
    [self addSubview:_maxLabel];

}



- (void)addTarget:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents
{
    [_slider addTarget:target action:action forControlEvents:controlEvents];
}

- (void)setThumbImage:(UIImage *)image forState:(UIControlState)state
{
    [_slider setThumbImage:image forState:state];
}

- (CGFloat)value
{
    return _slider.value;
}

- (void)setValue:(CGFloat)value
{
    _slider.value = value;
    
    _minLabel.text = [NSString stringWithFormat:@"%02d:%02d:%02d", ((int)value) / 3600,((int)value) / 60, ((int)value) % 60];
}

- (CGFloat)maximumValue
{
    return _slider.maximumValue;
}

- (void)setMaximumValue:(CGFloat)maximumValue
{
    _slider.maximumValue = maximumValue;
    _maxLabel.text = [NSString stringWithFormat:@"%02d:%02d:%02d",((int)maximumValue) / 3600,((int)maximumValue) / 60, ((int)maximumValue) % 60 ];
}

- (CGFloat)minimumValue
{
    return _slider.minimumValue;
}

- (void)setMinimumValue:(CGFloat)minimumValue
{
    _slider.minimumValue = minimumValue;
}

@end
