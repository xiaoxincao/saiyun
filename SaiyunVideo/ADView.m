//
//  ADView.m
//  SaiyunVideo
//
//  Created by cying on 16/4/18.
//  Copyright © 2016年 cying. All rights reserved.
//

#import "ADView.h"
#import "WebViewController.h"
@implementation ADView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self addAllViews];
    }
    return self;
}

- (void)addAllViews
{
    CGFloat Width = kScreenWidth;
    CGFloat Height = 40;
    
    UIImageView *yunimage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 5, 30, 30)];
    yunimage.image = [UIImage imageNamed:@"yun144@3x"];
    
    UILabel *textlabel = [[UILabel alloc]initWithFrame:CGRectMake(30, 0, Width-30-80, Height)];
    textlabel.text = @"云谷创课，今天你创业了么？";
    textlabel.font = [UIFont systemFontOfSize:15];
    textlabel.textColor = [UIColor whiteColor];
    
    self.enterbtn = [UIButton buttonWithType:UIButtonTypeSystem];
    self.enterbtn.frame = CGRectMake(Width-80, 0, 60, Height);
    [self.enterbtn setTitle:@"点击进入" forState:UIControlStateNormal];
    [self.enterbtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    
    self.exitbtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.exitbtn.frame = CGRectMake(Width-20, 0, 20, 20);
    [self.exitbtn setImage:[UIImage imageNamed:@"close"] forState:UIControlStateNormal];

    
    [self addSubview:yunimage];
    [self addSubview:textlabel];
    [self addSubview:self.enterbtn];
    [self addSubview:self.exitbtn];

}

- (void)enterbtnaddTarget:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents
{
    [self.enterbtn addTarget:target action:action forControlEvents:controlEvents];
}

- (void)exitbtnaddTarget:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents
{
    [self.exitbtn addTarget:target action:action forControlEvents:controlEvents];
}


@end
