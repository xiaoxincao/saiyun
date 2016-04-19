//
//  ADView.h
//  SaiyunVideo
//
//  Created by cying on 16/4/18.
//  Copyright © 2016年 cying. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ADView : UIView

//@property (nonatomic, strong)UIView *adview;

//@property (nonatomic, strong)UIView *clearview;

@property (nonatomic, strong)UIImageView *yunimage;

@property (nonatomic, strong)UILabel *textlabel;

@property (nonatomic, strong)UIButton *enterbtn;

@property (nonatomic, strong)UIButton *exitbtn;


- (void)enterbtnaddTarget:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents;

- (void)exitbtnaddTarget:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents;
@end
