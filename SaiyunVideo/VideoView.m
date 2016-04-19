//
//  VideoView.m
//  SaiyunVideo
//
//  Created by cying on 16/4/18.
//  Copyright © 2016年 cying. All rights reserved.
//

#import "VideoView.h"

@implementation VideoView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self addAllViews];
    }
    return self;
}

- (void)addAllViews
{
    self.backgroundColor = [UIColor blackColor];
    self.subtitlelabel = [[UILabel alloc]init];
    self.subtitlelabel.textColor = [UIColor whiteColor];
    self.subtitlelabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:18.f];
    self.subtitlelabel.textAlignment = 1;
    [self addSubview:self.subtitlelabel];
    [self.subtitlelabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self).with.insets(UIEdgeInsetsMake(kScreenHeight/3-35, 5, 5, 5));
    }];
}
@end
