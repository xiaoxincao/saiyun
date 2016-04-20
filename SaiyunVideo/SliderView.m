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
    _maxLabel.font = [UIFont systemFontOfSize:14];
    [self addSubview:_maxLabel];

}


@end
