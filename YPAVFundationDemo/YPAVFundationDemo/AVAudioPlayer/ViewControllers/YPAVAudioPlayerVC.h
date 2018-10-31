//
//  YPAVAudioPlayerVC.h
//  YPAVFundationDemo
//
//  Created by WorkZyp on 2018/10/29.
//  Copyright © 2018年 Zyp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YPBaseVC.h"

@interface YPAVAudioPlayerVC : YPBaseVC

/** 播放进度的slider*/
@property (weak, nonatomic) IBOutlet UISlider *playProgressSlider;
/** 播放时间的显示*/
@property (weak, nonatomic) IBOutlet UILabel *progressTimeLbl;
/** 播放进度的slider被手动滑动更改值...*/
- (IBAction)sliderValueChanged:(UISlider *)sender;

/** 立体声设置*/
- (IBAction)stereoSetSliderValueChanged:(UISlider *)sender;

/** 播放速率设置时的响应事件*/
- (IBAction)rateChanged:(UIStepper *)sender;
/** 显示当前的播放速率*/
@property (weak, nonatomic) IBOutlet UILabel *rateLbl;


/** 音量调节*/
- (IBAction)volumeChanged:(UIStepper *)sender;









- (IBAction)playAction:(UIButton *)sender;

- (IBAction)pauseAction:(UIButton *)sender;

- (IBAction)stopAction:(UIButton *)sender;

@end
