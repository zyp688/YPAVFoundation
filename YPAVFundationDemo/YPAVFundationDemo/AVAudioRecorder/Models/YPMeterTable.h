//
//  YPMeterTable.h
//  YPAVFundationDemo
//
//  Created by WorkZyp on 2018/11/5.
//  Copyright © 2018年 Zyp. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <AVFoundation/AVFoundation.h>

/** Audio Metering->声音计量：能捕捉声音信号，对音频进行测量
 AVAudioRecorder和AVAudioPlayer中最强大和最实用的功能就是对音频进行测量。
Audio Metering可以让开发者读取音频的平均分贝和峰值分贝数据，并实用这些数据
以可视化的方式将声音的大小呈现给最终用户。
 
 两个类中使用的方法都是averagePowerForChannel: 和 peakPowerForChannel:
两个方法都会返回一个用于表示声音分贝(dB)等级的浮点值。这个值的范围从表示最大分贝
0Db(full scale)到表示最小分贝/静音的-160dB。
 
 在可以读取这些值之前，需要首先通过设置录音器的meteringEnabled属性为YES才可以
支持对音频进行测量。这就使得录音器可以对捕捉到的音频样本进行分贝计算。每当需要读取
值时，首先需要调用updateMeters方法才能获取最新的值。
 */

/** 通过averagePowerForChannel: 和 peakPowerForChannel: 方法提供的读数，
可以得到一个表示分贝等级的浮点值，这是一个描述音量等级的 对数单位！！！
 
一般用于表示录制过程中的平均分贝和峰值分贝的都是一个基于Quartz级别的计量视图，在
使用该视图前，分贝值需要先从 对数形式的-160到0范围-> 转换为-> 线性的0到1的形式。
 */
//!!!!!  关于声音计量展示需要注意的一点是,会增加系统开销。启用计量功能会导致一些额外计算，会影响设备的耗电量。此外，当使用基于Quartz的计量绘制时，虽然Quartz是一个卓越的框架，但是会占用CPU资源，所以不断的计算音量数据会产生一定的开销。所以如果要录制长时间的音频内容，可能需要考虑禁用音频计量功能，或者选择一种更高效的绘制方法，不如使用OpenGL ES。


/** YPMeterTable
 简化类，是基于Apple的C++的MeterTable类的Objective-C端口
 
 该类创建了一个内部数组，用于保存从计算前的分贝数到使用一定级别分贝解析之后的
转换结果。这里使用的解析率为-0.2dB。解析等级可以通过修改 MIN_DB 和 TABLE_SIZE
值进行调整。
 每个分贝值都通过调用dbToAmp函数转换为线性范围内的值，使其处于范围0(-60dB)到1之间，
之后得到一条由这些范围内的值构成的平滑曲线，开平方计算并保存到内部查找表格中。这些值
在之后需要时都可以通过valueForPower:方法来获取。
 */



NS_ASSUME_NONNULL_BEGIN

@interface YPMeterTable : NSObject

- (float)valueForPower:(float)power;

@end


@interface YPLevelPair : NSObject

@property (assign, nonatomic) float level;
@property (assign, nonatomic) float peakLevel;

+ (YPLevelPair *)levelsWithLevel:(float)linearLevel peakLevel:(float)peakLevel;

@end



NS_ASSUME_NONNULL_END
