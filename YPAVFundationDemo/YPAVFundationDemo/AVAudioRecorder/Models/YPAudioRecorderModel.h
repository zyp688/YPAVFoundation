//
//  YPAudioRecoderModel.h
//  YPAVFundationDemo
//
//  Created by WorkZyp on 2018/11/1.
//  Copyright © 2018年 Zyp. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


NS_ASSUME_NONNULL_BEGIN
@class YPMemoAudiosModel;

typedef void(^recordingStopCompletionHandler)(BOOL);
typedef void(^recordingSaveCompletionHandler)(BOOL,id);

@interface YPAudioRecorderModel : NSObject

/** 实例对象*/
+ (instancetype)sharedInstance;


/** 录音*/
- (void)record;
/** 暂停录音*/
- (void)pause;
/** 停止录音*/
- (void)stopWithCompletionHandler:(recordingStopCompletionHandler)handler;

/** 保存录音*/
- (void)saveRecordingWithName:(NSString *)name completionHandler:(recordingSaveCompletionHandler)handler;

/** 播放录音*/
- (BOOL)playMemoAudio:(YPMemoAudiosModel *)model;

@end



//.........额外做个Model用来处理一下已经录完的声音记录
@interface YPMemoAudiosModel : NSObject

/** 备忘的录音名字*/
@property (strong, nonatomic) NSString *name;
/** 备忘的录音存储地址*/
@property (strong, nonatomic) NSURL *url;

//在保存完录音成功后，调用该方法记录下录音名字和保存的地址url
- (void)memoWithName:(NSString *)name url:(NSURL *)url;

@end

NS_ASSUME_NONNULL_END
