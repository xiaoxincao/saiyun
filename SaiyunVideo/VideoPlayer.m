//
//  VideoPlayer.m
//  SaiyunVideo
//
//  Created by cying on 16/4/19.
//  Copyright © 2016年 cying. All rights reserved.
//

#import "VideoPlayer.h"
#import <AVFoundation/AVFoundation.h>

static NSString *const VideoPlayerItemStatusKeyPath = @"status";
static NSString *const VideoPlayerItemLoadedTimeRangesKeyPath = @"loadedTimeRanges";

@interface VideoPlayer ()



@end

@implementation VideoPlayer

- (instancetype)init {
    self = [super init];
    if (self) {
        _player = [[AVPlayer alloc]init];
        _pausePlayWhenMove = YES;
    }
    return self;
}
//讲playerlayer添加到视频播放的容器view上
- (void)playInContainer:(UIView *)container {
    self.playerLayer = [AVPlayerLayer playerLayerWithPlayer:self.player];
    self.playerLayer.frame = container.bounds;
    self.playerLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    [container.layer addSublayer:self.playerLayer];
}

//重写path，传入path添加item，监听
- (void)setPath:(NSString *)path {
    if (path == nil) {
        return;
    }
    if ([_path isEqualToString:path]) {
        return;
    }
    _path = path;
    if (self.playState == SSVideoPlayerPlayStatePlaying) {
        [self.player pause];
    }
    if (self.playerItem) {
        if ([self.delegate respondsToSelector:@selector(videoPlayerDidSwitchPlay:)]) {
            [self.delegate videoPlayerDidSwitchPlay:self];
        }
        if (self.progressBlock) {
            self.progressBlock(0.0);
        }
        if (self.bufferProgressBlock) {
            self.bufferProgressBlock(0.0);
        }
        [self clear];
    }
    NSString *p = [path stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url = [NSURL fileURLWithPath:p];
    if ([p hasPrefix:@"http://"] || [p hasPrefix:@"https://"]) {
        url = [NSURL URLWithString:p];
    }
    AVPlayerItem *playItem = [[AVPlayerItem alloc]initWithURL:url];
    self.playerItem = playItem;
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(playEndNotification) name:AVPlayerItemDidPlayToEndTimeNotification object:playItem];
    [playItem addObserver:self forKeyPath:VideoPlayerItemStatusKeyPath options:NSKeyValueObservingOptionNew context:NULL];
    [playItem addObserver:self forKeyPath:VideoPlayerItemLoadedTimeRangesKeyPath options:NSKeyValueObservingOptionNew context:NULL];
    [self.player replaceCurrentItemWithPlayerItem:playItem];
    _duration = CMTimeGetSeconds(self.playerItem.duration);
    __weak VideoPlayer *weakSelf = self;
    self.observer = [self.player addPeriodicTimeObserverForInterval:CMTimeMake(1.0, 1.0) queue:dispatch_get_global_queue(0, 0) usingBlock:^(CMTime time) {
        if (CMTIME_IS_INDEFINITE(weakSelf.playerItem.duration)) {
            return ;
        }
        float f = CMTimeGetSeconds(time);
        float max = CMTimeGetSeconds(weakSelf.playerItem.duration);
        if (weakSelf.progressBlock) {
            weakSelf.progressBlock(f/max);
        }
    }];
    [self.player play];
//    CMTime dragedCMTime = CMTimeMake(7, 1);
//    [self.player seekToTime:dragedCMTime completionHandler:^(BOOL finish){
//        [_player play];
//    }];
   

}
//移除监听
- (void)clear {
    [self.player removeTimeObserver:self.observer];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:AVPlayerItemDidPlayToEndTimeNotification object:self.playerItem];
    [self.playerItem removeObserver:self forKeyPath:VideoPlayerItemLoadedTimeRangesKeyPath context:NULL];
    [self.playerItem removeObserver:self forKeyPath:VideoPlayerItemStatusKeyPath context:NULL];
    self.playerItem = nil;
}
//播放结束时
- (void)playEndNotification {
    if (self.progressBlock) {
        self.progressBlock(1.0);
    }
    if ([self.delegate respondsToSelector:@selector(videoPlayerDidEndPlay:)]) {
        [self.delegate videoPlayerDidEndPlay:self];
    }
}
//播放失败时
- (void)playFailedNotification {
    if ([self.delegate respondsToSelector:@selector(videoPlayerDidFailedPlay:)]) {
        [self.delegate videoPlayerDidFailedPlay:self];
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:VideoPlayerItemStatusKeyPath]) {
        AVPlayerStatus status = [change[NSKeyValueChangeNewKey]integerValue];
        //成功时去播放视频
        if (status == AVPlayerStatusReadyToPlay) {
            if ([self.delegate respondsToSelector:@selector(videoPlayerDidReadyPlay:)]) {
                [self.delegate videoPlayerDidReadyPlay:self];
            }
        }
        //失败时弹出提示信息
        else if (status == AVPlayerStatusFailed) {
            if ([self.delegate respondsToSelector:@selector(videoPlayerDidFailedPlay:)]) {
                [self.delegate videoPlayerDidFailedPlay:self];
            }
        }
    }
    else if ([keyPath isEqualToString:VideoPlayerItemLoadedTimeRangesKeyPath]) {
        if (CMTIME_IS_INDEFINITE(self.playerItem.duration)) {
            return ;
        }
        NSArray *array = self.playerItem.loadedTimeRanges;
        CMTimeRange timeRange = [array.firstObject CMTimeRangeValue];
        float duration = CMTimeGetSeconds(self.playerItem.duration);
        float current = CMTimeGetSeconds(timeRange.duration);
        if (self.bufferProgressBlock) {
            self.bufferProgressBlock(current/duration);
        }
    }
}

- (SSVideoPlayerPlayState)playState {
    if (ABS(self.player.rate - 1) <= 0.000001) {
        return SSVideoPlayerPlayStatePlaying;
    }
    return SSVideoPlayerPlayStateStop;
}

- (void)play {
    if (ABS(self.player.rate - 1) <= 0.000001) {
        return;
    }
    if (self.playerItem.status == AVPlayerItemStatusFailed) {
        return;
    }
    [self.player play];
    if ([self.delegate respondsToSelector:@selector(videoPlayerDidBeginPlay:)]) {
        [self.delegate videoPlayerDidBeginPlay:self];
    }
}

- (void)playAtTheBeginning {
    [self moveTo:0.0];
    [self play];
}

- (void)moveTo:(float)to {
    if (self.pausePlayWhenMove) {
        [self pause];
    }
    CMTime duration = self.playerItem.asset.duration;
    float max = CMTimeGetSeconds(duration);
    long long l = ceil(max*to);
    [self.player seekToTime:CMTimeMake(l, 1)];
    if (self.progressBlock) {
        self.progressBlock(to);
    }
}

- (void)pause {
    if (ABS(self.player.rate - 0) <= 0.000001) {
        return;
    }
    [self.player pause];
}

- (void)dealloc {
    [self pause];
    [self clear];
    self.player = nil;
    self.playerLayer = nil;
    self.playerItem = nil;
    self.observer = nil;
}
@end
