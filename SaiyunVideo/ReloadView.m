//
//  ReloadView.m
//  HandsForLoL
//
//  Created by lanou3g on 15/7/23.
//  Copyright (c) 2015年 吴非凡. All rights reserved.
//

#import "ReloadView.h"
#define kButtonWidth 200
#define kButtonHeight 40

@interface ReloadView ()

@property (nonatomic, strong) UIButton *button;
@property (nonatomic, copy) void (^btnClickBlock)();
@end

@implementation ReloadView
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self addAllViews];
    }
    return self;
}

- (void)addAllViews
{
    self.backgroundColor = [UIColor whiteColor];
    self.button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [_button setTitle:@"重新加载" forState:UIControlStateNormal];
    [_button setTintColor:[UIColor whiteColor]];
    [_button setFrame:CGRectMake((self.frame.size.width - kButtonWidth) / 2, (self.frame.size.height - kButtonHeight) / 2, kButtonWidth, kButtonHeight)];
    [_button setBackgroundColor:NavColor];
    [self addSubview:_button];
}


+ (instancetype)reloadViewWithFrame:(CGRect)frame
                             target:(id)target
                             action:(SEL)action
{
    ReloadView *reloadView = [[ReloadView alloc] initWithFrame:frame];
    [reloadView.button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return reloadView;
}

+ (instancetype)reloadViewWithFrame:(CGRect)frame
                      btnClickBlock:(void (^)())btnClickBlock
{
    ReloadView *reloadView = [[ReloadView alloc] initWithFrame:frame];
    [reloadView.button addTarget:reloadView action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    reloadView.btnClickBlock = btnClickBlock;
    return reloadView;
}

- (void)btnAction:(UIButton *)sender
{
    if (_btnClickBlock) {
        _btnClickBlock();
    }
    [self removeFromSuperview];
}
@end
