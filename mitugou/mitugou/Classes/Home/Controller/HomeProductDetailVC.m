//  HomeProductDetailVC.m
//  mitugou
//  Created by zhufeng on 2018/11/8.
//  Copyright © 2018 zhufeng. All rights reserved.
#import "HomeProductDetailVC.h"
#import "CommitOrderVC.h"
#import "SettingAuthonVC.h"
@interface HomeProductDetailVC ()
@end
@implementation HomeProductDetailVC
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"商品详情";
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
/**
直接购买
 @param sender 直接购买
 */
- (IBAction)actionPaynowBtn:(UIButton *)sender
{
    CommitOrderVC *commitvc = [[CommitOrderVC alloc]init];
    [self.navigationController pushViewController:commitvc animated:YES];
}
/**
 分期购买
 @param sender 分期购买
 */
- (IBAction)actionFenjiBtn:(UIButton *)sender
{
    SettingAuthonVC *authonvc = [[SettingAuthonVC alloc]init];
    [self.navigationController pushViewController:authonvc animated:YES];
}
@end
