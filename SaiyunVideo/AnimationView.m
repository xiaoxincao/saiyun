//
//  AnimationView.m
//  Test001
//
//  Created by StriEver on 16/3/25.
//  Copyright © 2016年 StriEver. All rights reserved.
//

#import "AnimationView.h"
@interface AnimationView()
@property (nonatomic, strong)UIImageView * imageView;
@property (nonatomic, strong)UIImageView * imageView1;
@end
@implementation AnimationView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor grayColor];
        [self setUpView];
    }
    return self;
}
- (void)didMoveToSuperview{
   // _imageView.alpha = 1;
//    [UIView animateWithDuration:10 animations:^{
//        _imageView.transform = CGAffineTransformMakeScale(1, 1);
//    } completion:^(BOOL finished) {
//        [UIView animateWithDuration:2 animations:^{
//            _imageView.transform = CGAffineTransformMakeScale(0, 0);
//            _imageView.alpha = 0;
//        } completion:^(BOOL finished) {
//            _imageView1.alpha = 1;
//            [UIView animateWithDuration:3 animations:^{
//                 _imageView1.transform = CGAffineTransformMakeScale(1, 1);
//            } completion:^(BOOL finished) {
//                [UIView animateWithDuration:2 animations:^{
//                    _imageView.transform = CGAffineTransformMakeScale(0, 0);
//                    _imageView1.alpha = 0;
//                    
//                } completion:^(BOOL finished) {
//                    [self removeFromSuperview];
//                    
//                }];
//                
//            }];
//            
//        }];
//        
//    }];
//    [UIView animateWithDuration:5 animations:^{
//        _imageView.
//        
//    }completion:^(BOOL finished) {
//        _imageView.alpha = 0;
//    }];
    [self shakeAnimationForView:_imageView];
    [self performSelector:@selector(showImage2) withObject:nil afterDelay:3];
}
- (void)setUpView{
    _imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"0"]];
    _imageView.frame = CGRectMake(20, 100, 80, 80);
   // _imageView.backgroundColor = [UIColor redColor];
    [self addSubview:_imageView];
    _imageView1 = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"1"]];
    _imageView1.frame = CGRectMake(200, 300, 80, 80);
    [self addSubview:_imageView1];
    _imageView1.alpha = 0;
}
- (void)showImage2{
    _imageView.alpha = 0;
    [_imageView stopAnimating];
    _imageView1.alpha = 1;
    [self shakeAnimationForView:_imageView1];
    [self performSelector:@selector(dismis) withObject:nil afterDelay:3];
}
- (void)dismis{
    [self removeFromSuperview];
}
- (void)shakeAnimationForView:(UIView *) view{
    CALayer *viewLayer = view.layer;
    CGPoint position = viewLayer.position;
    CGPoint beginPosition = CGPointMake(position.x , position.y+5);
    CGPoint endPosition = CGPointMake(position.x , position.y-5);
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"position"];
    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault]];
    [animation setFromValue:[NSValue valueWithCGPoint:beginPosition]];
    [animation setToValue:[NSValue valueWithCGPoint:endPosition]];
    [animation setAutoreverses:YES];
    [animation setDuration:.5];
    [animation setRepeatCount:6];
    [viewLayer addAnimation:animation forKey:nil];
    
}
@end
