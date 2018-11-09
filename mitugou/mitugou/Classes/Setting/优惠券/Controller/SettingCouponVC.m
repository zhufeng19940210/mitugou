//  SettingCouponVC.m
//  mitugou
//  Created by zhufeng on 2018/11/8.
//  Copyright © 2018 zhufeng. All rights reserved.
#import "SettingCouponVC.h"
#import "SettingCouponCell.h"
@interface SettingCouponVC ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (nonatomic,strong)NSMutableArray *couponArray;
@end
@implementation SettingCouponVC
-(NSMutableArray *)couponArray
{
    if (!_couponArray) {
        _couponArray = [NSMutableArray array];
    }
    return _couponArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"优惠券";
   // [self actionCouponNewData];
   // [self setupRefresh];
      [self setupTableView];
}
-(void)setupRefresh
{
    [self setViewRefreshTableView:self.tableview withHeaderAction:@selector(actionCouponNewData) andFooterAction:@selector(actionCouponMoreData) target:self];
}
/**
 加载最新的数据
 */
-(void)actionCouponNewData
{
    
}
/**
 加载更多的数据
 */
-(void)actionCouponMoreData
{
    
}
/**
 setuptableview
 */
-(void)setupTableView
{
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    self.tableview.backgroundColor = [UIColor clearColor];
    [self.tableview  registerNib:[UINib nibWithNibName:@"SettingCouponCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"SettingCouponCell"];
}
#pragma mark -- uitableviewdelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SettingCouponCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SettingCouponCell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}
@end
