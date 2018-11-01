//
//  YPBaseVC.m
//  YPAVFundationDemo
//
//  Created by WorkZyp on 2018/10/29.
//  Copyright © 2018年 Zyp. All rights reserved.
//

#import "YPBaseVC.h"

@interface YPBaseVC ()

@end

@implementation YPBaseVC

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
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(0, 0, 45, 45);
    [backBtn setTitle:@"<Back" forState:UIControlStateNormal];
    [backBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    backBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [backBtn addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    
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
#pragma mark -
#pragma mark - backAction
- (void)backAction {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark – ⬇️ 💖 Methods 💖 ⬇️


#pragma mark – ⬇️ 💖 Delegate 💖 ⬇️


#pragma mark – ⬇️ 💖 Getters / Setters 💖 ⬇️




@end
