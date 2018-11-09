//  AddressListVC.m
//  mitugou
//  Created by zhufeng on 2018/11/8.
//  Copyright © 2018 zhufeng. All rights reserved.
#import "AddressListVC.h"
#import "AddressEditVC.h"
#import "AddreeListCell.h"
#import "AddreeModel.h"
@interface AddressListVC ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (nonatomic,strong)NSMutableArray *addreeArray;
@end
@implementation AddressListVC
-(NSMutableArray *)addreeArray
{
    if (!_addreeArray) {
        _addreeArray = [NSMutableArray array];
    }
    return _addreeArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"管理收货地址";
    self.view.backgroundColor = RGB(240, 240, 240);
    [self setupData];
    [self seutpTableView];
}
//请求数据
-(void)setupData
{
    
}
-(void)seutpTableView
{
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    self.tableview.backgroundColor = [UIColor clearColor];
    [self.tableview registerNib:[UINib nibWithNibName:@"AddreeListCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"AddreeListCell"];
}
#pragma mark -- uitableviewdelgate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 5;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 140;
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
    AddreeListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AddreeListCell"];
    //AddreeModel *model = self.dataArray[indexPath.section];
    //cell.addressModel = model;
    //这里的block执行的命令
    cell.acitonBlock = ^(AddressOpertaionType type) {
        if (type == AddressOpertaionTypeDefault) {
            //设置成默认地址
            [self setupDefaultAddresWithModel:nil];
        }else if (type == AddressOpertaionTypeDelete){
            //删除地址
            [self setupDeleteAddressWithModel:nil];
        }else if (type == AddressOpertaionTypeEdit){
            //编辑地址
            [self setupEditAddressWithModel:nil];
        }
    };
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
/**
 设置成默认的地址
 @param addrssmodel 设置成默认的的地址
 */
-(void)setupDefaultAddresWithModel:(AddreeModel *)addrssmodel
{
    NSLog(@"设置成默认地址");
}
/**
 删除用户地址
 @param addressmodel 删除用户地址
 */
-(void)setupDeleteAddressWithModel:(AddreeModel *)addressmodel
{
    NSLog(@"删除用户地址");
}
/**
 编辑用户
 @param addressModel 编辑用户
 */
-(void)setupEditAddressWithModel:(AddreeModel *)addressModel
{
    NSLog(@"编辑用户");
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
