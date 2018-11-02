//
//  YPAudioRecoderModel.m
//  YPAVFundationDemo
//
//  Created by WorkZyp on 2018/11/1.
//  Copyright © 2018年 Zyp. All rights reserved.
//

#import "YPAudioRecoderModel.h"
#import <AVFoundation/AVFoundation.h>


@interface YPAudioRecoderModel ()

@property (strong, nonatomic) AVAudioRecorder *recorder;

@end

@implementation YPAudioRecoderModel


#pragma mark -
#pragma mark - sharedInstance  单例对象...
static id _instance;
+ (instancetype)sharedInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init];
        
        
        
        
        
    });
    return _instance;
}

- (AVAudioRecorder *)createRecorder {
    NSString *filePath = [NSHomeDirectory() stringByAppendingPathComponent:@"voice.m4a"];
    //音频流写入文件的本地文件URL
    NSURL *localURL = [NSURL URLWithString:filePath];
    
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
     
     */
    NSDictionary *settings = @{AVFormatIDKey : @(kAudioFormatMPEG4AAC),
                               AVSampleRateKey : @22050.f,
                               AVNumberOfChannelsKey : @1
                               };
    
    //用于捕捉初始化阶段各种错误的指针
    NSError *error;
    //创建AVRecord的实例
    AVAudioRecorder *recorder = [[AVAudioRecorder alloc] initWithURL:localURL settings:settings error:&error];
    
    if (recorder) {
        /** prepareToRecord:
         为了成功创建AVRecorder实例，建议调用其prepareToRecord方法。与AVPlayer的
         prepareToPlay方法类似，该方法执行底层Audio Queue初始化的必要过程。该方法还
         在URL参数指定的位置创建一个文件，将录制启动时的延迟降到最小
         */
        [recorder prepareToRecord];
        
        return recorder;
    }
    
    return nil;
}


@end
