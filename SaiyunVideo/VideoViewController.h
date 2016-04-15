//
//  VideoViewController.h
//  SaiyunVideo
//
//  Created by cying on 15/11/16.
//  Copyright (c) 2015年 cying. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "HVWLuckyWheelButton.h"
#import "SliderView.h"
#import "ValueModel.h"
#import "Singleton.h"

@protocol VideoViewControllerDelegate <NSObject>

@end

@interface VideoViewController : UIViewController


- (IBAction)chapterBtn:(id)sender;//章节按钮
- (IBAction)lastBtn:(id)sender;//上一个
- (IBAction)playBtn:(id)sender;//播放
- (IBAction)nextBtn:(id)sender;//下一个


@property (strong, nonatomic) IBOutlet UIButton *chapterBtnproperty;

@property (strong, nonatomic) IBOutlet UIButton *nextBtnproperty;

@property (strong, nonatomic) IBOutlet UIButton *lastBtnproperty;

@property (strong, nonatomic) IBOutlet UILabel *CircleClassifyLabel;//圆盘分类的名字
@property (strong, nonatomic) IBOutlet UILabel *ChapterNameLabel;//章节名字
@property (strong, nonatomic) IBOutlet UILabel *TeacherDetailLabel;//老师简介
@property (strong, nonatomic) IBOutlet UIButton *upMenuBtn;
@property (strong, nonatomic) IBOutlet SliderView *progressSliderView;
@property (strong,nonatomic)NSTimer *timer;
@property (strong,nonatomic)NSTimer *hiddentimer;
@property (strong, nonatomic) IBOutlet UIButton *playproperty;//播放按钮属性
@property (strong, nonatomic) IBOutlet UIImageView *BGimageView;//背景图片View
@property (nonatomic,strong)ValueModel *vvmodel;
@property (nonatomic,strong)ValueModel *valuemodel;
@property (nonatomic,strong)ValueModel *vamodel;
@property (nonatomic,assign) CGPoint originalLocation;/**< 初始点 */
@property (nonatomic,strong) UIImageView *brightnessView;
@property (nonatomic,strong) UIProgressView *brightnessProgress; /**< 亮度条 */
@property(nonatomic,assign)CGFloat systemVolume;//系统音量
@property(nonatomic,strong)UISlider *volumeViewSlider;//声音调节
@property (strong, nonatomic) UIView *VideoView;//视频播放的容器View
@property (strong, nonatomic) AVPlayer *player;//播放器对象
@property (strong, nonatomic)AVPlayerLayer *playerLayer;
@property(nonatomic,strong)AVPlayerItem *playerItem; // 播放属性

singleton_interface(VideoViewController)


@end
