//
//  YPAudioRecorderVC.m
//  YPAVFundationDemo
//
//  Created by WorkZyp on 2018/11/1.
//  Copyright © 2018年 Zyp. All rights reserved.
//
/**
    AVAudioRecorder同AVAudioPlayer一样，构建于Audio Queue Services之上，是一个
 功能强大且代码简单易用的Objective-C接口。我们可以在Mac机器和iOS设备上使用这个类来从
 内置的麦克风录制音频，也可以从外部音频设备进行录制，比如数字音频接口或者USB麦克风等。
 */


#import "YPAVAudioRecorderVC.h"
#import "YPAudioRecorderModel.h"

#import "YPAudioPlayerModel.h"

@interface YPAVAudioRecorderVC () <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) YPAudioRecorderModel *recorderModel;

/** 备忘的录制完的音频*/
@property (strong, nonatomic) NSMutableArray <YPMemoAudiosModel *>*memoAudiosArr;

@end

@implementation YPAVAudioRecorderVC

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
    
    self.recorderModel = [YPAudioRecorderModel sharedInstance];
    self.tbv.delegate = self;
    self.tbv.dataSource = self;
    
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


#pragma mark – ⬇️ 💖 Methods 💖 ⬇️


#pragma mark – ⬇️ 💖 Delegate 💖 ⬇️
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.memoAudiosArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 45.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellID = @"memoAudioCellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    cell.textLabel.text = ((YPMemoAudiosModel *)self.memoAudiosArr[indexPath.row]).name;

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.recorderModel playMemoAudio:self.memoAudiosArr[indexPath.row]];
}

#pragma mark – ⬇️ 💖 Getters / Setters 💖 ⬇️




- (IBAction)recordBtnAction:(UIButton *)sender {
    [self.recorderModel record];
    
}


- (IBAction)stopBtnAction:(UIButton *)sender {
    [self.recorderModel stopWithCompletionHandler:^(BOOL flag) {
        if (flag) {
            [self.recorderModel saveRecordingWithName:@"" completionHandler:^(BOOL success, id _Nonnull obj) {
                if (success) {
                    NSArray *objArr = (NSArray *)obj;
                    YPMemoAudiosModel *model = [[YPMemoAudiosModel alloc] init];
                    [model memoWithName:objArr[0] url:objArr[1]];
                    [self.memoAudiosArr addObject:model];
                    
                    [self.tbv reloadData];
                }
            }];
        }
    }];
}


- (NSMutableArray<YPMemoAudiosModel *> *)memoAudiosArr {
    if (!_memoAudiosArr) {
        _memoAudiosArr = [NSMutableArray array];
    }
    
    return _memoAudiosArr;
}

@end
