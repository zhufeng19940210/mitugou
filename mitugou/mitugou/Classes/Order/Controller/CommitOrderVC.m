//  CommitOrderVC.m
//  mitugou
//  Created by zhufeng on 2018/11/8.
//  Copyright © 2018 zhufeng. All rights reserved.
#import "CommitOrderVC.h"
#import "AddressListVC.h"
#import "AddSelectCell.h"
#import "ProductDetailCell.h"
#import "StagingTypeCell.h"
#import "DistributionTypeCell.h"
#import "AddressListVC.h"
@interface CommitOrderVC ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (weak, nonatomic) IBOutlet UILabel *total_lab;
@property (nonatomic,strong)NSMutableArray *addressArray;
@end
@implementation CommitOrderVC
-(NSMutableArray *)addressArray
{
    if (!_addressArray) {
        _addressArray = [NSMutableArray array];
    }
    return _addressArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"支付确认";
    self.view.backgroundColor = RGB(240, 240, 240);
    [self setupData];
    [self setupTableView];
}
//请求数据
-(void)setupData
{
    NSLog(@"请求数据");
}
//设置tableview
-(void)setupTableView
{
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    self.tableview.backgroundColor = [UIColor clearColor];
    [self.tableview registerNib:[UINib nibWithNibName:@"AddSelectCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"AddSelectCell"];
    [self.tableview registerNib:[UINib nibWithNibName:@"ProductDetailCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"ProductDetailCell"];
    [self.tableview registerNib:[UINib nibWithNibName:@"StagingTypeCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"StagingTypeCell"];
    [self.tableview registerNib:[UINib nibWithNibName:@"DistributionTypeCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"DistributionTypeCell"];
}
#pragma mark -- uitableviewdelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 90;
    }else if (indexPath.section == 1){
        return 180;
    }else if (indexPath.section == 2){
        return 50;
    }else if (indexPath.section == 3){
        return 50;
    }else{
        return 0;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 10;
    }else{
        return 5;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 5;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *commitCell = nil;
    if (indexPath.section == 0) {
        AddSelectCell *addressCell = [tableView dequeueReusableCellWithIdentifier:@"AddSelectCell"];
        commitCell = addressCell;
    }else if (indexPath.section == 1){
        ProductDetailCell *detailCell = [tableView dequeueReusableCellWithIdentifier:@"ProductDetailCell"];
        commitCell = detailCell;
    }else if (indexPath.section == 2){
        StagingTypeCell *staginCell = [tableView dequeueReusableCellWithIdentifier:@"StagingTypeCell"];
        commitCell = staginCell;
    }else if (indexPath.section == 3){
        DistributionTypeCell *distrubitionCell = [tableView dequeueReusableCellWithIdentifier:@"DistributionTypeCell"];
        commitCell = distrubitionCell;
    }
    commitCell.selectionStyle = UITableViewCellSelectionStyleNone;
    return commitCell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
        AddressListVC *addresslistvc = [[AddressListVC alloc]init];
        addresslistvc.addressBlock = ^(AddreeModel *model) {
            NSLog(@"model:%@",model);
        };
        [self.navigationController pushViewController:addresslistvc animated:YES];
    }
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
    NSLog(@"支付宝");
}
@end
