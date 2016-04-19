//
//  VideoPlayer.h
//  SaiyunVideo
//
//  Created by cying on 16/4/19.
//  Copyright © 2016年 cying. All rights reserved.
//

#import <Foundation/Foundation.h>


@class VideoPlayer;

@protocol VideoPlayerDelegate <NSObject>

@optional

- (void)videoPlayerDidReadyPlay:(VideoPlayer *)videoPlayer;

- (void)videoPlayerDidBeginPlay:(VideoPlayer *)videoPlayer;

- (void)videoPlayerDidEndPlay:(VideoPlayer *)videoPlayer;

- (void)videoPlayerDidSwitchPlay:(VideoPlayer *)videoPlayer;

- (void)videoPlayerDidFailedPlay:(VideoPlayer *)videoPlayer;

@end


typedef NS_ENUM(NSInteger,SSVideoPlayerPlayState) {
    SSVideoPlayerPlayStatePlaying,
    SSVideoPlayerPlayStateStop,
};

typedef NS_ENUM(NSInteger,SSVideoPlayerDisplayMode) {
    SSVideoPlayerDisplayModeAspectFit,
    SSVideoPlayerDisplayModeAspectFill
};


@interface VideoPlayer : NSObject

@property (nonatomic,  weak) id <VideoPlayerDelegate> delegate;

@property (nonatomic,  copy) void (^progressBlock)(float progress);

@property (nonatomic,  copy) void (^bufferProgressBlock)(float progress);

@property (nonatomic,assign,readonly) SSVideoPlayerPlayState playState;

@property (nonatomic,assign) SSVideoPlayerDisplayMode displayMode;

@property (nonatomic,assign) BOOL pausePlayWhenMove; //Default YES.

@property (nonatomic,assign,readonly) float duration;

@property (nonatomic,  copy) NSString *path;

- (void)playInContainer:(UIView *)container ;

- (void)play;

- (void)playAtTheBeginning;

- (void)moveTo:(float)to; //0 to 1.

- (void)pause;

@end
