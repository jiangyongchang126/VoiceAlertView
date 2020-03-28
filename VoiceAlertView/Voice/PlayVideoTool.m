//
//  PlayVideoTool.m
//  test
//
//  Created by iMac on 2019/10/25.
//  Copyright © 2019 蒋永昌. All rights reserved.
//

#import "PlayVideoTool.h"

@interface PlayVideoTool ()

@property(nonatomic,strong)AVPlayer *player;
// 定时器(让代理不断执行协议中的方法)
@property(nonatomic,strong)NSTimer *timer;

@end

@implementation PlayVideoTool

// 初始化赋值
- (instancetype)init{
    
    if (self = [super init]) {
        
        // 添加观察者
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(didMusicPlayFinished) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
        
        //        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(routeChange:) name:AVAudioSessionRouteChangeNotification object:nil];
        
        
        //        //处理中断事件的通知
        //        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleInterreption:) name:AVAudioSessionInterruptionNotification object:[AVAudioSession sharedInstance]];
        
        
    }
    
    return self;
}

-(void)didMusicPlayFinished{
    
    CMTime alltime = self.player.currentItem.duration;
    Float64 seconds = CMTimeGetSeconds(alltime);
    
    NSString *allTime = [self returnFormaterMaxHour:seconds];
    if (self.passWithTime) {
        self.passWithTime(allTime, allTime);
    }
    
    [self pausePlay];
    self.player = nil;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"playerFinished" object:nil];
}

+ (instancetype)playerManager{
    
    static PlayVideoTool *manager = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        manager = [[self alloc]init];
    });
    
    return manager;
}
- (void)musicPlayWithMP3Url:(NSString *)url{
    
    if (_timer == nil) {
            // 创建一个定时器,0.1秒执行一次方法
            self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerAction) userInfo:nil repeats:YES];
            [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
    
    }
    self.url = url;
    
    // 设置音频源
    AVPlayerItem *item = [AVPlayerItem playerItemWithURL:[NSURL URLWithString:url]];
    // 替换当前的playItem
    [self.player replaceCurrentItemWithPlayerItem:item];
    
    [self.player play];
    self.playing = YES;
    

    
    
}

- (void)play{
    
    if (!self.player.currentItem) {
        AVPlayerItem *item = [AVPlayerItem playerItemWithURL:[NSURL URLWithString:self.url]];
        // 替换当前的playItem
        [self.player replaceCurrentItemWithPlayerItem:item];
    }
    if (_timer == nil) {
        // 创建一个定时器,0.1秒执行一次方法
        self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerAction) userInfo:nil repeats:YES];
        [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
    }
    [self.player play];
    self.playing = YES;
}


// 暂停音乐
- (void)pausePlay{
    
    [self.timer invalidate];
    _timer = nil;
    
    [self.player pause];
    self.playing = NO;
    
}

- (void)killPlayer{
    
    [self.timer invalidate];
    _timer = nil;
    [self.player pause];
    self.playing = NO;
    self.player = nil;

}

// 懒加载创建player对象
- (AVPlayer *)player{
    
    if (_player == nil) {
        _player = [[AVPlayer alloc]init];
    }
    return _player;
}


- (void)timerAction{
    
    CMTime time = self.player.currentTime;
    double currentTimeSec = time.value / time.timescale;
    
    CMTime alltime = self.player.currentItem.duration;
    Float64 seconds = CMTimeGetSeconds(alltime);
    
    NSString * curtimeStr = [self returnFormaterMaxHour:currentTimeSec];
    NSString *allTime = [self returnFormaterMaxHour:seconds];
    if (self.passWithTime) {
        self.passWithTime(curtimeStr, allTime);
    }
//    DLog(@"%@/%@",curtimeStr,allTime)
}

- (NSString *)returnFormaterMaxHour:(double)seconds{
    int time = (int)seconds;
    int hour = time/3600;
    int minute = (time - hour * 3600)/60;
    int second = time - hour * 3600 - minute * 60;
    
    //返回秒
    if (time < 60) {
        if (time < 0) {
            return @"00:00";
        }
        NSString *timeStr = [NSString stringWithFormat:@"00:%02d",time];
        return timeStr;
    }else if (time >= 60 && time < 3600){
        NSString *timeStr = [NSString stringWithFormat:@"%02d:%02d",minute,second];
        return timeStr;
    }else if (time >= 3600 && time < 86400){
        NSString *timeStr = [NSString stringWithFormat:@"%02d:%02d:%02d",hour,minute,second];
        return timeStr;
    }
    return @"00:00";
}


@end
