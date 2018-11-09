//  CommitOrderVC.m
//  mitugou
//  Created by zhufeng on 2018/11/8.
//  Copyright © 2018 zhufeng. All rights reserved.
#import "CommitOrderVC.h"
#import "AddressListVC.h"
@interface CommitOrderVC ()
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (weak, nonatomic) IBOutlet UILabel *total_lab;
@end
@implementation CommitOrderVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"支付确认";
    self.view.backgroundColor = RGB(240, 240, 240);
    [self setRightButtonText:@"选择地址" withColor:[UIColor blackColor]];
}
/**
 右边的Button
 @param button 右边的按钮
 */
- (void)onRightBtnAction:(UIButton *)button
{
    AddressListVC *addresslistvc = [[AddressListVC alloc]init];
    [self.navigationController pushViewController:addresslistvc animated:YES];
}
/**
 提交订单
 @param sender 提交订单
 */
- (IBAction)acitonCommitVC:(UIButton *)sender
{

}
@end
