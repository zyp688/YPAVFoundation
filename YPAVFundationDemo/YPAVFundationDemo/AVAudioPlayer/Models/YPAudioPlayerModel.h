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

/** 实例model单例对象*/
+ (instancetype)sharedInstance;

/** 是否正在播放*/
@property (assign, nonatomic) BOOL isPlaying;
/** 实时更新播放进度的回调*/
@property (copy, nonatomic) void(^updateProgressBlock)(CGFloat playProgress, NSString *playingTimeStr);
/** 设置播放进度*/
- (void)setPlayProgressWithValue:(float)value;

/** 收到中断事件 开始时 的回传Block*/
@property (copy, nonatomic) void(^playBeganBlock)(void);
/** 收到中断事件 结束时 的回传Block*/
@property (copy, nonatomic) void(^playStoppedBlock)(void);


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
