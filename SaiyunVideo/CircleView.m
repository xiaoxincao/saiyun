//
//  CircleView.m
//  SaiyunVideo
//
//  Created by cying on 16/4/19.
//  Copyright © 2016年 cying. All rights reserved.
//

#import "CircleView.h"
#import "UIImage+wiRoundedRectImage.h"

@implementation CircleView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self addAllViews];
    }
    return self;
}

- (void)addAllViews
{
    self.centerimg = [[UIImageView alloc]init];
    self.centerimg.image = [UIImage imageNamed:@"yun"];
    [UIImage createRoundedRectImage:self.centerimg.image size:CGSizeMake(kScreenWidth-60, kScreenWidth-60) radius:(kScreenWidth-60)/2];
    self.centerimg.layer.masksToBounds=YES;
    [self addSubview:self.centerimg];
    [self.centerimg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self).with.insets(UIEdgeInsetsMake(30, 30, 30, 30));
    }];
}
@end
