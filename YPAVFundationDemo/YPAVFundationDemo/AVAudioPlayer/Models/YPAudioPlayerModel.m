//
//  YPAudioPlayerModel.m
//  YPAVFundationDemo
//
//  Created by WorkZyp on 2018/10/31.
//  Copyright © 2018年 Zyp. All rights reserved.
//

/**
 AVAudioPlayer构建于Core Audio中的C-based Audio Queue Services的最顶层。
 所以它可以提供所有你在Audio Queue Services中所能找到的核心功能，比如播放、循环、
 设置音频计量，但使用的却是非常简单并友好的Objective-C接口。除非你需要从网络流中播放
 音频、需要访问原始音频样本或者需要非常低的时延，否则AVAudioPlayer基本都能胜任！
 */


#import "YPAudioPlayerModel.h"

@interface YPAudioPlayerModel ()

/** 播放器*/
@property (strong, nonatomic) AVAudioPlayer *player;
/** 是否正在播放*/
@property (assign, nonatomic) BOOL isPlaying;
/** 捕捉播放进度的定时器*/
@property (strong, nonatomic) NSTimer *catchPlayProgressTimer;

@end


@implementation YPAudioPlayerModel

#pragma mark -
#pragma mark - createAudipoPlayerModel 创建model对象
+ (instancetype)createAudioPlayerModel {
    YPAudioPlayerModel *model = [YPAudioPlayerModel new];
    model.player = [model createAudioPlayerWithMusicName:@"shamoluotuo"];
    return model;
}

#pragma mark -
#pragma mark - createAudioPlayerWithMusicName: 创建播放器，name:工程内音乐文件的名字
- (AVAudioPlayer *)createAudioPlayerWithMusicName:(NSString *)name {
    NSError *error;
    AVAudioPlayer *player = [[AVAudioPlayer alloc] initWithContentsOfURL:[[NSBundle mainBundle] URLForResource:name withExtension:@"mp3"] error:&error];
    if (player) {
        /** -numberOfLoops:该属性实现音频无缝循环
                -设置为一个大于0的数，可实现播放器对应次数的循环
                -设置为-1时，则表示播放器会无限循环
         */
        player.numberOfLoops = -1;
        
        /** -enableRate:该属性表示是否可以对播放器的播放率进行控制
         */
        player.enableRate = YES;
        
        /** -volume:播放器独立的音频音量设置*/
        player.volume = 0.6;
        
        /** prepareToPlay:该方法会取得需要的音频硬件并预加载Audio Queue的缓冲区，
         调用prepareToPlay这个动作是可选的，当调用play方式时会隐性的激活，不过在创建
         时准备播放器可以降低调用play方法和听到声音输出之间的延时。建议调用！
         */
        [player prepareToPlay];
        
        /** 在准备播放的时候添加一个捕捉播放进度的定时器*/
        self.catchPlayProgressTimer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(catchPlayProgress) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:self.catchPlayProgressTimer forMode:NSDefaultRunLoopMode];
        
        return player;
    }
    
    return nil;
}


#pragma mark -
#pragma mark - catchPlayProgress 捕捉音频播放进度 主流的slider实现效果
- (void)catchPlayProgress {
    double currentTime = self.player.currentTime;
    double totalTime = self.player.duration;
    float progress = currentTime / totalTime;
    if (self.updateProgress) {
        self.updateProgress(progress,[self getPlayingTimeString]);
    }
}


#pragma mark -
#pragma mark - setPlayProgressWithValue: 主流的slider实现效果
- (void)setPlayProgressWithValue:(float)value {
    double currentTime = value * self.player.duration;
    self.player.currentTime = currentTime;
}


#pragma mark -
#pragma mark - play 播放音乐
- (void)play {
    if (!self.isPlaying) {
        [self.player play];
        self.isPlaying = YES;
    }
}

#pragma mark -
#pragma mark - pause 暂停音乐
- (void)pause {
    if (self.isPlaying) {
        [self.player pause];
        //暂停是否需要更改播放状态？？？依具体场景而定，isPlaying置为No的话，这里认为当播放器处于暂停状态时，再按停止没有意义。
        self.isPlaying = NO;
    }
}

#pragma mark -
#pragma mark - stop 停止音乐

/**
 pause和stop方法在应用程序外面看来实现的功能都是停止当前播放的行为，
 下一时间里我们调用play方法，通过pause和stop方法停止的音频都会继续播放。
 这两者主要的区别是在底层的处理上：
 调用stop方法会撤销调用prepareToPlay时所做的设置，而调用pause方法则不会
 
 -故实现真正的停止方法，应将当前播放器的播放时间置为0
 */
- (void)stop {
    if (self.isPlaying) {
        [self.player stop];
        self.player.currentTime = 0.0;
        self.isPlaying = NO;
    }
}



#pragma mark -
#pragma mark - volumeChanged: 调节音量大小
/**
 -volume: 音量属性
 播放器的音量独立于系统的音量，可通过对播放器的音量控制实现很多有意思的事情，
 比如声音渐隐效果。 其设置值区间在0.0(静音)-1.0(最大音量)之间
 */
- (void)setVolumeChangedWithValue:(CGFloat)value {
    if (value < 0.0 || value > 1.0) {
        //容错
        return;
    }
    
    self.player.volume = value;
}

/** 将时间按照 05:00 分钟:秒  格式返回*/
- (NSString *)getMinuteAndSecondTimeStrWithSecond:(NSInteger)totalSecond {
    NSInteger minute = totalSecond / 60;
    NSInteger second = (NSInteger)totalSecond % 60;
    NSString *timeStr = [NSString stringWithFormat:@"%02ld:%02ld",minute,second];
    return timeStr;
}

- (NSString *)getPlayingTimeString {
    NSString *totalTimeString = [self getMinuteAndSecondTimeStrWithSecond:self.player.duration];
    NSString *currentTimeString = [self getMinuteAndSecondTimeStrWithSecond:self.player.currentTime];
    NSString *playingTimeStr = [NSString stringWithFormat:@"%@ / %@",currentTimeString,totalTimeString];
    return playingTimeStr;
}


@end
