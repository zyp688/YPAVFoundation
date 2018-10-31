//
//  YPAudioPlayerModel.h
//  YPAVFundationDemo
//
//  Created by WorkZyp on 2018/10/31.
//  Copyright © 2018年 Zyp. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface YPAudioPlayerModel : NSObject

/** 实时更新播放进度的回调*/
@property (copy, nonatomic) void(^updateProgress)(CGFloat playProgress, NSString *playingTimeStr);
/** 设置播放进度*/
- (void)setPlayProgressWithValue:(float)value;

/** 实例model对象*/
+ (instancetype)createAudioPlayerModel;

/** 播放*/
- (void)play;
/** 暂停*/
- (void)pause;
/** 停止*/
- (void)stop;

/** 调节音量 value:0~1*/
- (void)setVolumeChangedWithValue:(CGFloat)value;



@end

NS_ASSUME_NONNULL_END
