//
//  YPAVAudioPlayerVC.m
//  YPAVFundationDemo
//
//  Created by WorkZyp on 2018/10/29.
//  Copyright © 2018年 Zyp. All rights reserved.
//

#import "YPAVAudioPlayerVC.h"
#import "YPAudioPlayerModel.h"

@interface YPAVAudioPlayerVC ()

@property (strong, nonatomic) YPAudioPlayerModel *playerModel;

@end

@implementation YPAVAudioPlayerVC

#pragma mark – ⬇️ 💖 Life Cycle 💖 ⬇️

#pragma mark -
#pragma mark - viewWillAppear:
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
}

#pragma mark -
#pragma mark - viewDidLoad
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.playerModel = [YPAudioPlayerModel sharedInstance];
    
    //根据播放进度的捕捉Block回调 刷新一些UI  业务层处理~~~
    __weak typeof(self)weakself = self;
    self.playerModel.updateProgressBlock = ^(CGFloat playProgress, NSString * _Nonnull playingTimeStr) {
        weakself.playProgressSlider.value = playProgress;
        weakself.progressTimeLbl.text = playingTimeStr;
    };
    
}





#pragma mark -
#pragma mark - viewWillDisappear:
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
}

#pragma mark -
#pragma mark - dealloc
- (void)dealloc {
    
}

#pragma mark – ⬇️ 💖 Events 💖 ⬇️
- (IBAction)volumeChanged:(UIStepper *)sender {
    [self.playerModel setVolumeChangedWithValue:sender.value];
}

- (IBAction)playAction:(UIButton *)sender {
    [self.playerModel play];
}

- (IBAction)pauseAction:(UIButton *)sender {
    [self.playerModel pause];
}

- (IBAction)stopAction:(UIButton *)sender {
    [self.playerModel stop];
}

- (IBAction)sliderValueChanged:(UISlider *)sender {
    //是否允许进度条实时更新
    sender.continuous = YES;
    [self.playerModel setPlayProgressWithValue:sender.value];
}

- (IBAction)stereoSetSliderValueChanged:(UISlider *)sender {
    [self.playerModel setPanChangedWithValue:sender.value];
    
}

- (IBAction)rateChanged:(UIStepper *)sender {
    [self.playerModel setRateChangedWithValue:sender.value];
    self.rateLbl.text = [NSString stringWithFormat:@"当前速率%.2f倍",sender.value];
    
}

#pragma mark – ⬇️ 💖 Methods 💖 ⬇️

- (void)backAction {
    if (self.playerModel.isPlaying) {
        __weak typeof(self)weakself = self;
        UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"" message:@"检测到音乐正在播放\n，需要停止么播放么？" preferredStyle: UIAlertControllerStyleAlert];
        UIAlertAction *continueAction = [UIAlertAction actionWithTitle:@"任性听直接返回" style:UIAlertActionStyleCancel handler:^void(UIAlertAction *action){
            [super backAction];
        }];
        
        UIAlertAction *stopAction = [UIAlertAction actionWithTitle:@"停止播放后返回" style:  UIAlertActionStyleDestructive handler:^void(UIAlertAction *action){
            [weakself.playerModel stop];
            [super backAction];
        }];
        
        [alertVC addAction:continueAction];
        [alertVC addAction:stopAction];
        
        [self presentViewController:alertVC animated:YES completion:nil];
    }else {
        [super backAction];
    }
}

#pragma mark – ⬇️ 💖 Delegate 💖 ⬇️


#pragma mark – ⬇️ 💖 Getters / Setters 💖 ⬇️


@end
