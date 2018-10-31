//
//  AppDelegate.m
//  YPAVFundationDemo
//
//  Created by WorkZyp on 2018/10/29.
//  Copyright © 2018年 Zyp. All rights reserved.
//

#import "AppDelegate.h"
#import <AVFoundation/AVFoundation.h>
#import "RootVC.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window.backgroundColor = [UIColor whiteColor];
    
    
    /** 配置音频回话  这里AVAudioSession为全局的单例
        工程角度上来说在该声明周期中设置最为合适
     */
    AVAudioSession *session = [AVAudioSession sharedInstance];
    NSError *error;
    /** Categorys: 音频会话分类说明：AVFoundation定义了7种分类来描述应用程序所
     使用的音频行为
     -AVAudioSessionCategoryAmbient:
        ->游戏、效率应用程序, 支持混音, 不支持音频输入, 支持音频输出
     
     -AVAudioSessionCategorySoloAmbient:
        ->游戏、效率应用程序, 不支持混音, 不支持音频输入, 支持音频输出
     
     -AVAudioSessionCategoryPlayback:
        ->音频和视频播放器, 支持混音(可选), 不支持音频输入, 支持音频输出
     
     -AVAudioSessionCategoryRecord:
        ->录音机、音频捕捉, 不支持混音, 支持音频输入, 不支持音频输出
     
     -AVAudioSessionCategoryPlayAndRecord:
        ->VoIP、语音聊天, 支持混音(可选), 支持音频输入, 支持音频输出
     
     -AVAudioSessionCategoryAudioProcessing:
        ->离线会话处理, 不支持混音, 不支持音频输入, 不支持音频输出
     
     -AVAudioSessionCategoryMultiRoute:
        ->使用外部硬件的高级A/V应用程序, 不支持混音, 支持音频输入, 支持音频输出
     
     更复杂的应用通过使用options和modes方法进一步自定义开发
     */
    if (![session setCategory:AVAudioSessionCategoryPlayback error:&error]) {
        DLog(@"Category error is %@",[error localizedDescription]);
    }
    if (![session setActive:YES error:&error]) {
        DLog(@"Activation error is %@",[error localizedDescription]);
    }

    self.window.rootViewController = [[UINavigationController alloc] initWithRootViewController:[RootVC new]];
    
    [self.window makeKeyAndVisible];
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
