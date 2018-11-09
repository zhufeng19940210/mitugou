//  AddressListVC.m
//  mitugou
//  Created by zhufeng on 2018/11/8.
//  Copyright © 2018 zhufeng. All rights reserved.
#import "AddressListVC.h"
#import "AddressEditVC.h"
@interface AddressListVC ()
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@end
@implementation AddressListVC
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"管理收货地址";
}
/**
 添加收货地址
 @param sender 添加收货地址
 */
-(IBAction)actionAddressageBtn:(UIButton *)sender
{
    AddressEditVC *addressvc = [[AddressEditVC alloc]init];
    addressvc.isEdit = NO;
    [self.navigationController pushViewController:addressvc animated:YES];
}

@end
