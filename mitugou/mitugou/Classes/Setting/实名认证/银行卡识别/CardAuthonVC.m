//  CardAuthonVC.m
//  mitugou
//  Created by zhufeng on 2018/11/8.
//  Copyright © 2018 zhufeng. All rights reserved.
#import "CardAuthonVC.h"
@interface CardAuthonVC ()
@end
@implementation CardAuthonVC
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"银行卡认证";
    [self setRightButtonText:@"上传" withColor:MainThemeColor];
}
/**
 上传的方法
 @param button 上传的方法
 */
- (void)onRightBtnAction:(UIButton *)button
{
    NSLog(@"上传的方法");
}
@end
