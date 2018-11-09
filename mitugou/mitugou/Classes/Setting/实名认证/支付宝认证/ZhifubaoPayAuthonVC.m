//  ZhifubaoPayAuthonVC.m
//  mitugou
//  Created by zhufeng on 2018/11/8.
//  Copyright © 2018 zhufeng. All rights reserved.
#import "ZhifubaoPayAuthonVC.h"

@interface ZhifubaoPayAuthonVC ()

@end

@implementation ZhifubaoPayAuthonVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"支付宝认证";
    [self setRightButtonText:@"上传" withColor:MainThemeColor];
}
/**
 RightButton
 @param button RightButton
 */
- (void)onRightBtnAction:(UIButton *)button
{
    NSLog(@"上传界面");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
@end
