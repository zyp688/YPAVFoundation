//
//  YPAudioRecorderVC.h
//  YPAVFundationDemo
//
//  Created by WorkZyp on 2018/11/1.
//  Copyright © 2018年 Zyp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YPBaseVC.h"

NS_ASSUME_NONNULL_BEGIN

@interface YPAVAudioRecorderVC : YPBaseVC
/** 时间显示00:00:00*/
@property (weak, nonatomic) IBOutlet UILabel *timeLbl;
/** 开始录制/暂停录制 按钮*/
@property (weak, nonatomic) IBOutlet UIButton *recordBtn;
/** 停止按钮*/
@property (weak, nonatomic) IBOutlet UIButton *stopBtn;
/** 显示一段一段的录音tbv*/
@property (weak, nonatomic) IBOutlet UITableView *tbv;


/** 开始录制/暂停录制 按钮点击事件*/
- (IBAction)recordBtnAction:(UIButton *)sender;
/** 体制按钮  点击事件*/
- (IBAction)stopBtnAction:(UIButton *)sender;

@end




NS_ASSUME_NONNULL_END
