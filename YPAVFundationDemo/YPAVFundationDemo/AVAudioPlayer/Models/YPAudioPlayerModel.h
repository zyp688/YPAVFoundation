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

/** 实例model单例对象*/
+ (instancetype)sharedInstance;

/** 播放*/
- (void)play;
/** 暂停*/
- (void)pause;
/** 停止*/
- (void)stop;

/** 调节音量 value:0~1*/
- (void)setVolumeChangedWithValue:(CGFloat)value;

/** 设置播放器pan值 立体声 pan:-1.0(极左)~1.0(极右)*/
-(void)setPanChangedWithValue:(CGFloat)value;

/** 设置播放器rate值 语速
 设置该值之前 必须将enableRate属性设为YES
 */
-(void)setRateChangedWithValue:(CGFloat)value;

@end

NS_ASSUME_NONNULL_END
