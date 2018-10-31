//
//  ViewController.m
//  YPAVFundationDemo
//
//  Created by WorkZyp on 2018/10/29.
//  Copyright © 2018年 Zyp. All rights reserved.
//

#import "RootVC.h"

#import "YPAVAudioPlayerVC.h"


@interface RootVC () <UITableViewDelegate, UITableViewDataSource>

/** 功能列表*/
@property (strong, nonatomic) UITableView *itemsTbv;
/** 功能数组*/
@property (strong, nonatomic) NSArray *itemsArr;
/** 跳转页数组*/
@property (strong, nonatomic) NSArray *jumpPages;

@end

@implementation RootVC

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
    
    
    [self uiConfig];
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
#pragma mark -
#pragma mark - uiConfig
- (void)uiConfig {
    
    self.title = @"AVFoundation";
    
    [self.view addSubview:self.itemsTbv];
}

#pragma mark – ⬇️ 💖 Delegate 💖 ⬇️
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.itemsArr.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 45.f;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellID = @"CellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.textLabel.text = self.itemsArr[indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    id vc = [[NSClassFromString(self.jumpPages[indexPath.row]) alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}


#pragma mark – ⬇️ 💖 Getters / Setters 💖 ⬇️
- (NSArray *)itemsArr {
    if (!_itemsArr) {
        _itemsArr = @[@"AVAudioPlayer实战"];
    }
    
    return _itemsArr;
}

- (UITableView *)itemsTbv {
    if (!_itemsTbv) {
        _itemsTbv = [[UITableView alloc] initWithFrame:CGRectMake(0, 100, kScreenWidth, kScreenHeight - 100) style:UITableViewStylePlain];
        _itemsTbv.delegate = self;
        _itemsTbv.dataSource = self;
        
    }
    
    return _itemsTbv;
}

- (NSArray *)jumpPages {
    if (!_jumpPages) {
        _jumpPages = @[@"YPAVAudioPlayerVC"];
    }
    
    return _jumpPages;
}


@end
