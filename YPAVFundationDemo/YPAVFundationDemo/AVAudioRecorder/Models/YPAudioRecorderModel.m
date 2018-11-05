//
//  YPAudioRecoderModel.m
//  YPAVFundationDemo
//
//  Created by WorkZyp on 2018/11/1.
//  Copyright © 2018年 Zyp. All rights reserved.
//

#import "YPAudioRecorderModel.h"
#import <AVFoundation/AVFoundation.h>

#import "YPMeterTable.h"

@interface YPAudioRecorderModel () <AVAudioRecorderDelegate>

/** 播放*/
@property (strong, nonatomic) AVAudioPlayer *player;
/** 录音*/
@property (strong, nonatomic) AVAudioRecorder *recorder;
/** 持有下处理block，在需要调用的调用*/
@property (copy, nonatomic) recordingStopCompletionHandler stopCompletionHandler;

/** 保存音频的计量表格*/
@property (strong, nonatomic) YPMeterTable *meterTable;

@end

@implementation YPAudioRecorderModel


#pragma mark -
#pragma mark - sharedInstance  单例对象...
static id _instance;
+ (instancetype)sharedInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init];
        
        /** 创建AVRecord实例*/
        ((YPAudioRecorderModel *)_instance).recorder = [_instance createRecorder];
        
        /** 创建音频计量表格的实例*/
        ((YPAudioRecorderModel *)_instance).meterTable = [[YPMeterTable alloc] init];
        
    });
    return _instance;
}

#pragma mark -
#pragma mark - createAudioSession  创建音频录制的音频会话
/** 该功能的业务核心是录制并播放语音备忘录。
 所以我们不能使用音频会话默认的Solo Ambient(AVAudioSessionCategorySoloAmbient)分类，
 因为该分类不持之音频输入。所以应该选择AVAudioSessionCategoryPlayAndRecord分类。
 
 注：从iOS7开始，在使用麦克风之前，操作系统要求应用程序必须得到用户的明确许可。
 iOS10更是严格，要求当应用程序在试图访问麦克风时，必须做一些友好的申请权限的设置
 -具体设置  则在info.plist 添加如下键值对
 
 //申请麦克风权限
 NSMicrophoneUsageDescription 设置value:应用想要访问您的录音权限
 
 //随意扩展一些...顺道想起来了而已😁
 NSCameraUsageDescription:相机权限
 NSContactsUsageDescription:通信录
 NSPhotoLibraryUsageDescription:相册
 */
- (void)createAudioSession {
    AVAudioSession *session = [AVAudioSession sharedInstance];
    NSError *error;
    if (![session setCategory:AVAudioSessionCategoryPlayAndRecord error:&error]) {
        DLog(@"创建音频录制的音频会话error is %@",[error localizedDescription]);
    }
    
    /** ！！！此时播放录音时，总会出现一个问题，就是无法在扬声器中播放！！！！
        导致录制出来的声音在播放的时候，听筒播放，声音非常小，所以在配置音频会话时
     需要处理一下
     */
    UInt32 audioRouteOverride = kAudioSessionOverrideAudioRoute_Speaker;
    /** 'AudioSessionSetProperty' is deprecated: first deprecated in iOS        7.0 - no longer supported
    下面这个方法在iOS7.0之后就不在支持使用了...
     */
//    AudioSessionSetProperty (
//                             kAudioSessionProperty_OverrideAudioRoute,
//                             sizeof (audioRouteOverride),
//                             &audioRouteOverride
//                             );
    [session setPreferredIOBufferDuration:audioRouteOverride error:&error];
    
    if(session == nil)
        NSLog(@"Error creating session: %@", [error localizedDescription]);
    else if (![session setActive:YES error:&error]) {
        DLog(@"激活音频录制的音频回话error is %@",[error localizedDescription]);
    }
    
}


#pragma mark -
#pragma mark - createRecorder  创建录制实例
- (AVAudioRecorder *)createRecorder {
    /**
     在录制音频的过程中，Core Audio Format(CFA)通常是最好的容器格式，
     因为它和内容无关并且可以保存Core Audio支持的任何音频格式。
     */
    NSString *filePath = [NSTemporaryDirectory() stringByAppendingPathComponent:@"memo.caf"];
    
    //音频流写入文件的本地文件URL
    NSURL *fileURL = [NSURL URLWithString:filePath];
    
    //用于配置录音会话键值信息的NSDictionary对象
    /** 该设置中指定的键值信息需要做必要的说明
     开发者可以使用的完整可用键信息在<AVFoundation/AVAudioSettings.h>中定义，
     大部分的键都专门定义了特有的格式，在此介绍一些通用的设置。
     
     1、【音频格式】AVFormatIDKey: 常见的支持的值有
     kAudioFormatLinearPCM               = 'lpcm',
     kAudioFormatMPEG4AAC                = 'aac ',
     kAudioFormatAppleLossless           = 'alac',
     kAudioFormatAppleIMA4               = 'ima4',
     kAudioFormatiLBC                    = 'ilbc',
     kAudioFormatULaw                    = 'ulaw',
     -指定kAudioFormatLinearPCM会将未压缩的音频流写入文件中。该格式的保真度
     最高，不过相应的文件也最大。 选择诸如AAC(kAudioFormatMPEG4AAC)或Apple
     IMA4(kAudioFormatAppleIMA4)的压缩格式会显著缩小文件，还能保证高质量的
     音频内容。
     注意！！！：你所指定的音频格式一定要和URL参数定义的文件类型兼容！
     
     2、【采样率】AVSampleRateKey: 用于定义录音器的采样率。
     采样率定义了对输入的模拟音频信号每一秒内的采样数。在录制音频的质量及最终文件大小
     方面，采样率扮演着至关重要的角色。
     -使用低采样率，如8kHz,对导致粗粒度、AM广播类型的录制效果，不过文件会比较小；
     -使用高采样率，如44.1kHz（CD质量的采样率）会得到非常高质量的内容，不过文件
     就会比较大。
     对于使用什么采样率最好并没有明确的定义，不过开发者应该尽量用标准的采样率，不如8000、
     16000、22050或者44100。最终是由我们的耳朵及具体的业务场景决定。
     
     3、【通道数】AVNumberOfChannelsKey: 用于定义记录音频内容的通道数。
     -默认值为1，意味着使用单声道录制。
     -设置为2，则意味着使用立体声录制。
     除非使用外部硬件录制，否则通常情况下应该创建单声道录音。
     
     4、【指定格式的键】
     处理Linear PCM或者压缩音频格式时，可以定义一些其他指定格式的键。
     可在Xcode 帮助文档中的 AV Foundation Audio Settings Constants引用中
     找到完整的列表。
     
     
     【位深】AVEncoderBitDepthHintKey
     【质量】AVEncoderAudioQualityKey
     */
    //使用Apple IMA4作为音频格式，采样率为44.1kHz，位深为16位，单声道录制，质量中等
    //这些设置考虑了质量和文件大小的平衡 -当然具体还可根据实际业务中的场景自己去平衡
    NSDictionary *settings = @{AVFormatIDKey : @(kAudioFormatAppleIMA4),
                               AVSampleRateKey : @44100.0f,
                               AVNumberOfChannelsKey : @1,
                               AVEncoderBitDepthHintKey : @16,
                               AVEncoderAudioQualityKey : @(AVAudioQualityMedium)
                               };
    
    //用于捕捉初始化阶段各种错误的指针
    NSError *error;
    //创建AVRecord的实例
    AVAudioRecorder *recorder = [[AVAudioRecorder alloc] initWithURL:fileURL settings:settings error:&error];
    
    if (recorder) {
        /** 此处需遵循下AVAudioRecorderDelegate协议
         -因录音器的委托协议方法中定义了一个方法，当录制完成时会发送一个通知
         所以得到录制过程完成的信息非常重要，这样才能处理让应用程序的用户为这
         段录音命名并且保存下来
         */
        recorder.delegate = self;
        
        /** -meteringEnabled: 是否支持对音频进行测量
         
         */
        recorder.meteringEnabled = YES;
        
        /** prepareToRecord:
         为了成功创建AVRecorder实例，建议调用其prepareToRecord方法。与AVPlayer的
         prepareToPlay方法类似，该方法执行底层Audio Queue初始化的必要过程。该方法还
         在URL参数指定的位置创建一个文件，将录制启动时的延迟降到最小
         */
        [recorder prepareToRecord];
        
        return recorder;
    }else {
        DLog(@"构建录音实例时遇到错误:%@",[error localizedDescription]);
    }
    
    return nil;
}

#pragma mark -
#pragma mark - levels
/** levels
 录音器的updateMeters方法一定要正好在读取当前等级值之前调用，以保证读取的级别是最新的
之后向通道0请求平均值和峰值数据。通道都是0索引的，由于我们使用单声道录制，只需要询问第一
个声道即可。
 
 之后在计量表格中查询线性声音的强度值并最终创建一个新的YPLevelPair实例，这个类只是用来
保存返回的平均值和峰值数据。
 读取音频强度值与请求当前时间类似，当需要最新值时都需要轮询录音器。与请求当前时间一样，
客户端代码可能使用NSTimer。不过由于你希望频繁更新用于展示的计量值以保持动画效果，需要
更平滑的效果，所以可能改用CADisplayLink作为解决方案更合适
CADisplayLink与NSTimer类似，不过它可以与显示频率自动同步。
 */

/** 因这块属于需求扩展化的要求，在这举个例子来说明一下就行了...
在需要展示数据的VC中开启CADisplayLink计时
 - (void)startMeterTimer {
    [self.leveTimer invalidate];
    self.levelTimer = [CADisplayLink displayLinkWithTarget:self selector:@selector(updateMeter)];
    self.levelTimer.frameInterval = 4;//屏幕刷新频率的1/4足矣
    [self.levelTimer addRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
 }
 
 - (void)stopMeterTimer {
    [self.levelTimer invalidate];
    self.levelTimer = nil;
    [self.levelMeterView resetLevelMeter];
 }
 
 - (void)updateMeter {
    YPLevelPair *levels = [self.audioRecorderModel levels];
    self.levelMeterView.level = levels.level;
    self.levelMeterView.peakLevel = levels.peakLevel;
    [self.levelMeterView setNeedsDisplay];
 }
 
 */
- (YPLevelPair *)levels {
    [self.recorder updateMeters];
    float avgPower = [self.recorder averagePowerForChannel:0];
    float peakPower = [self.recorder peakPowerForChannel:0];
    float linearLevel = [self.meterTable valueForPower:avgPower];
    float linearPeak = [self.meterTable valueForPower:peakPower];
    return [YPLevelPair  levelsWithLevel:linearLevel peakLevel:linearPeak];
}


#pragma mark -
#pragma mark - record 录音
- (void)record {
    [self chekRecordStutes:^(BOOL isAllow) {
        if (isAllow) {
            /** 创建音频回话*/
            [self createAudioSession];
        
            [self.recorder record];
        }else {
            [[[UIAlertView alloc] initWithTitle:@"Microphone Access Denied"
                                        message:@"This app requires access to your device's Microphone.\n\nPlease enable Microphone access for this app in Settings / Privacy / Microphone"
                                       delegate:nil
                              cancelButtonTitle:@"Dismiss"
                              otherButtonTitles:nil] show];
        }
    }];
}

#pragma mark -
#pragma mark - pause 暂停录音
- (void)pause {
    [self.recorder pause];
}

#pragma mark -
#pragma mark - stopWithCompletionHandler: 停止
/** 当用户点击stop按钮时，会调用该方法并传递一个完成块。我们保存对这个块的引用并调用录音器
 实例的stop方法，录音器实例启动结束音频录制的过程。当音频录制完毕后，录音器调用其委托方法，
 此时需要执行完成块来告知发起方，以便采取适当的操作。
 如：通常这种情况下，我们会弹窗提示用户，为该段录音命名并保存
 
 */
- (void)stopWithCompletionHandler:(recordingStopCompletionHandler)handler {
    if (!self.recorder.currentTime) {//压根就没有开始录的话...返回，细节处理根据需求而定...
        return;
    }
    self.stopCompletionHandler = handler;
    [self.recorder stop];
}

#pragma mark -
#pragma mark - AVAudioRecorderDelegate
- (void)audioRecorderDidFinishRecording:(AVAudioRecorder *)recorder successfully:(BOOL)flag {
    if (self.stopCompletionHandler) {
        self.stopCompletionHandler(flag);
    }
}


#pragma mark -
#pragma mark - saveRecordingWithName: completionHandler: 将录制完成的录音按照name的名字保存起来
- (void)saveRecordingWithName:(NSString *)name completionHandler:(recordingSaveCompletionHandler)handler {
    NSTimeInterval timeStamp = [NSDate timeIntervalSinceReferenceDate];
    NSString *fileName = [NSString stringWithFormat:@"/%@_%.0f.caf",name,timeStamp];
    NSString *docsDir = [self documentsDirectory];
    NSString *destPath = [docsDir stringByAppendingString:fileName];
    NSURL *srcURL = [NSURL fileURLWithPath:self.recorder.url.path];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isExist = [fileManager fileExistsAtPath:srcURL.path];
    if (isExist) {
        NSData *mydata = [NSData dataWithContentsOfFile:srcURL.path];
        BOOL isSaved = [mydata writeToFile:destPath atomically:NO];
        if (isSaved) {
            handler(YES,@[name,destPath]);
            [self.recorder prepareToRecord];
        }else {
            handler(NO,@[@"error",@""]);
        }
        /*
        NSURL *destURL = [NSURL fileURLWithPath:destPath];
        NSError *error;
        BOOL success = [fileManager copyItemAtURL:srcURL toURL:destURL error:&error];
        if (success) {
            handler(YES,@[name,destURL]);
            [self.recorder prepareToRecord];
        }else {
            handler(NO,error);
        }
        */
    }
}

#pragma mark -
#pragma mark - documentsDirectory  得到Document文件路径
- (NSString *)documentsDirectory {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    return [paths lastObject];
    
}

#pragma mark -
#pragma mark - playMemoAudio: 播放录音
- (BOOL)playMemoAudio:(YPMemoAudiosModel *)model {
    [self.player stop];
    self.player = [[AVAudioPlayer alloc] initWithContentsOfURL:model.url error:nil];
    if (self.player) {
        self.player.volume = 1.0;
        [self.player play];
        return YES;
    }
    
    return NO;
}

#pragma mark -
#pragma mark - formatCurrentTime
/** 展示播放时间
 AVAudioRecorder具有的currentTime 属性，可以为用户提供时间反馈信息。
 该属性返回一个NSTimeinterval，用于指示从录制开始到现在的时间，以秒来
 计算。NSTimeinterval不适合在用户界面上显示，处理一下时间
 */
- (NSString *)formatCurrentTime {
    NSUInteger time = (NSUInteger)self.recorder.currentTime;
    NSUInteger hours = time / 3600;
    NSUInteger minutes = (time / 60) % 60;
    NSUInteger seconds = time % 60;
    NSString *format = @"%02i:%02i:%02i";
    
    return [NSString stringWithFormat:format,hours,minutes,seconds];
}

#pragma mark -
#pragma mark - canRecord 是否允许了录音的权限
- (void)chekRecordStutes:(void(^)(BOOL isAllow))isAllow
{
    
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    if ([audioSession respondsToSelector:@selector(requestRecordPermission:)]) {
        [audioSession performSelector:@selector(requestRecordPermission:) withObject:^(BOOL granted) {
            if (isAllow) {
                isAllow(granted);
            }
        }];
    }
}

@end



@implementation YPMemoAudiosModel

//在保存完录音成功后，调用该方法记录下录音名字和保存的地址url
+ (YPMemoAudiosModel *)memoWithName:(NSString *)name url:(NSURL *)url {
    YPMemoAudiosModel *memoAudiosModle = [YPMemoAudiosModel new];
    memoAudiosModle.name = name;
    memoAudiosModle.url = url;
    return memoAudiosModle;
}


@end
