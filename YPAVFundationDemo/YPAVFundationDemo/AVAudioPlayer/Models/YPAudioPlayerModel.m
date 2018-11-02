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
 
 其可处理音频格式覆盖情况主要有以下几种：
 AAC
 AMR (Adaptive multi-Rate，一种语音格式)
 ALAC (Apple lossless Audio Codec)
 iLBC (internet Low Bitrate Codec，另一种语音格式)
 IMA4 (IMA/ADPCM)
 linearPCM (uncompressed)
 u-law 和 a-law
 MP3 (MPEG-Laudio Layer 3)
 */


#import "YPAudioPlayerModel.h"

@interface YPAudioPlayerModel ()

/** 播放器*/
@property (strong, nonatomic) AVAudioPlayer *player;
/** 捕捉播放进度的定时器*/
@property (strong, nonatomic) NSTimer *catchPlayProgressTimer;

@end


@implementation YPAudioPlayerModel

#pragma mark -
#pragma mark - sharedInstance 创建model单例对象

static id _instance;
+ (instancetype)sharedInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init];
        ((YPAudioPlayerModel *)_instance).player = [_instance createAudioPlayerWithMusicName:@"shamoluotuo"];
    });
    return _instance;
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
        
        /** -volume:播放器独立的音频音量设置 后面修改时有详细记录，这里只是设置个默认值*/
        player.volume = 0.6;
        
        /** prepareToPlay:该方法会取得需要的音频硬件并预加载Audio Queue的缓冲区，
         调用prepareToPlay这个动作是可选的，当调用play方式时会隐性的激活，不过在创建
         时准备播放器可以降低调用play方法和听到声音输出之间的延时。建议调用！
         */
        [player prepareToPlay];
        
        /** 在准备播放的时候添加一个捕捉播放进度的定时器*/
        self.catchPlayProgressTimer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(catchPlayProgress) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:self.catchPlayProgressTimer forMode:NSDefaultRunLoopMode];
        
        /** 是否支持后台音乐播放的补充说明
            -当程序退出后台或者锁屏时，有时业务上需要我们的播放器能够继续播放
            -此时需要对应用程序的info.plist文件进行细微修改来实现对该功能的支撑
         
         ~在Xcode Project Navigator面板找到应用程序的info.plist文件，用Xcode属性列表编辑器打开。添加
         一个新的Required background modes类型的数组，在其中添加名为
         App plays audio or steams audio/video using AirPlay的选项
         
         ~也可在info中直接修改
         
         ~也可右击info.plist 文件，在响应的XML部分编辑plist，依次选择Open As | Source code
         将如下条目添加到文件底部的</dict>标签之前：
         <key>UIBackgroundModes</key>
         <array>
            <string>audio</string>
         </array>
         */
        
        /** 注册终断通知
            -当收到外界的电话、闹钟响起、弹出FaceTime请求等状况，虽然iOS系统本身
            可以很好的处理这些事件，不过我们还是要确保“应用本身”针对这些情况的
            处理也足够完美
         */
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleInterruption:) name:AVAudioSessionInterruptionNotification object:[AVAudioSession sharedInstance]];
        
        /** 对线路改变的响应处理
            -在iOS设备上添加或移除音频输入、输出线路时，会发生线路改变。有多重原因
            会导致线路变化，比如用户插入耳机或断开USB麦克风。当此类事件发生时，
            音频会根据情况改变输入或者输出线路，同事AVAudioSession会广播一个描述
            该变化的通知给所有的侦听器。为遵循Apple的Human Interface
            Guidelines(HIG)的相关定义，应用程序应该成为这些侦听器中的一员
         
        -注册线路改变的通知
         */
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleRouteChange:) name:AVAudioSessionRouteChangeNotification object:[AVAudioSession sharedInstance]];
        
        
        
        return player;
    }
    
    return nil;
}

#pragma mark -
#pragma mark - handleInterruption: 监听到中断通知事件
- (void)handleInterruption:(NSNotification *)notification {
    NSDictionary *info = notification.userInfo;
    //通过type对中断的类型进行判断处理
    AVAudioSessionInterruptionType type = [info[AVAudioSessionInterruptionTypeKey] unsignedIntegerValue];
    if (type == AVAudioSessionInterruptionTypeBegan) {
        //中断事件开始
        [self stop];
        //回传给VC层处理一些UI等等...
        if (self.playStoppedBlock) {
            self.playStoppedBlock();
        }
        
    }else {
        //中断事件结束  AVAudioSessionInterruptionTypeEnded
        /** 如果中断类型为 AVAudioSessionInterruptionTypeEnded，
            userInfo字典中会包含一个AVAudioSessionInterruptionOptions值来表明音频会话是否已经重新激活
            以及是否可以再次播放
         */
        AVAudioSessionInterruptionOptions options = [info[AVAudioSessionInterruptionTypeKey] unsignedIntegerValue];
        if (options == AVAudioSessionInterruptionOptionShouldResume) {
            /** 当options的值为AVAudioSessionInterruptionOptionShouldResume，需要调用play方法
             并通过调用自身的block方法实现状态的回传
             */
            [self play];
            //回传给VC层处理一些UI等等...
            if (self.playBeganBlock) {
                self.playBeganBlock();
            }
        }
    }
}

#pragma mark -
#pragma mark - handleRouteChange: 监听到线路发生改变的通知事件
- (void)handleRouteChange:(NSNotification *)notification {
    NSDictionary *info = notification.userInfo;
    //通过reason对线路变化的原因进行判断处理
    AVAudioSessionRouteChangeReason reason = [info[AVAudioSessionRouteChangeReasonKey] unsignedIntegerValue];
    
    if (reason == AVAudioSessionRouteChangeReasonOldDeviceUnavailable) {
        /** 有设备断开连接
            -知道有设备断开连接后，需要向userinfo字典提出请求，以获得其中用于描述前一个线路的AVAudioSessionRouteDescription。线路的描述信息整合在一个输入NSArray和一个输出NSArray中。
            数组中的元素都是AVAudioSessionPortDescription的实例，用于描述不同的I/O接口属性。
         
         上述情况下，需要从线路描述中找到第一个输出接口并判断是否为耳机接口。如果是，则停止播放，并调用中断停止Block
         做停止相关的处理
         */
        
        //以前的线路
        AVAudioSessionRouteDescription *previousRoutes = info[AVAudioSessionRouteChangePreviousRouteKey];
        //以前的第一个输出接口
        AVAudioSessionPortDescription *previousOutput = previousRoutes.outputs[0];
        //第一个输出接口的类型
        NSString *portType = previousOutput.portType;
        
        if ([portType isEqualToString:AVAudioSessionPortHeadphones]) {
            //是耳机接口 停止播放
            [self stop];
            
            //回传给VC层处理一些UI等等...
            if (self.playStoppedBlock) {
                self.playBeganBlock();
            }
        }
    }
}


#pragma mark -
#pragma mark - catchPlayProgress 捕捉音频播放进度 主流的slider实现效果
- (void)catchPlayProgress {
    double currentTime = self.player.currentTime;
    double totalTime = self.player.duration;
    float progress = currentTime / totalTime;
    if (self.updateProgressBlock) {
        self.updateProgressBlock(progress,[self getPlayingTimeString]);
    }
}


#pragma mark -
#pragma mark - setPlayProgressWithValue: 主流的slider实现效果
- (void)setPlayProgressWithValue:(float)value {
    double currentTime = value * self.player.duration;
    self.player.currentTime = currentTime;
    if (!self.isPlaying) {
        [self play];
    }
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
        //停止时销毁播放进度捕捉的计时器
        [self.catchPlayProgressTimer invalidate];
        self.catchPlayProgressTimer = nil;
        
        [self catchPlayProgress];
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

#pragma mark -
#pragma mark - setPanChangedWithValue: 调节立体声效果
/**
 -pan:立体声播放声音
 默认值为0.0（居中）
 范围为-1.0(极左) ~ 1.0(极右)
 */
-(void)setPanChangedWithValue:(CGFloat)value {
    if (value < -1.0 || value > 1.0) {
        //容错
        return;
    }
    
    self.player.pan = value;
}

#pragma mark -
#pragma mark - setRateChangedWithValue: 设置播放的速率
/**
 -rate:属性 设置播放的速率
 默认为1.0为正常
 0.5缩短一半
 2.0加快一倍
 注：设置该值之前必须将是否允许控制播放速率为YES，即enableRate属性
 */
-(void)setRateChangedWithValue:(CGFloat)value {
    if (!self.player.enableRate) {
        //兼容性判断 如果没有开启播放速率控制，则主动开启，避免方法设置效果无用
        self.player.enableRate = YES;
    }
    self.player.rate = value;
}



#pragma mark -
#pragma mark - Other ....  匹配一些可能业务中需要的效果⤵️ 具体按照自己的业务需求来 *****
/** 将时间按照 05:00 分钟:秒  格式返回*/
- (NSString *)getMinuteAndSecondTimeStrWithSecond:(NSInteger)totalSecond {
    NSInteger minute = totalSecond / 60;
    NSInteger second = (NSInteger)totalSecond % 60;
    NSString *timeStr = [NSString stringWithFormat:@"%02ld:%02ld",minute,second];
    return timeStr;
}

/** 需求为 【播放时长/总时长】 这种格式返回 仿mac qq音乐 */
- (NSString *)getPlayingTimeString {
    NSString *totalTimeString = [self getMinuteAndSecondTimeStrWithSecond:self.player.duration];
    NSString *currentTimeString = [self getMinuteAndSecondTimeStrWithSecond:self.player.currentTime];
    NSString *playingTimeStr = [NSString stringWithFormat:@"%@ / %@",currentTimeString,totalTimeString];
    return playingTimeStr;
}


@end
