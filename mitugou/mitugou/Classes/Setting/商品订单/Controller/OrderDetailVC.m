//  OrderDetailVC.m
//  mitugou
//  Created by zhufeng on 2018/11/8.
//  Copyright © 2018 zhufeng. All rights reserved.
#import "OrderDetailVC.h"
#import "OrderContentCell.h"
#import "OrderStatusModel.h"
#import "LogisticsVC.h"
#import "OrderPinjiaVC.h"
@interface OrderDetailVC ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (nonatomic,strong)NSMutableArray *orderlistArray;
@property (nonatomic,assign)int page;
@end
@implementation OrderDetailVC
-(NSMutableArray *)orderlistArray
{
    if (!_orderlistArray) {
        _orderlistArray = [NSMutableArray array];
    }
    return _orderlistArray;
}

-(instancetype)init
{
    self = [super init];
    if (self) {
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(pinjiaSuccessAction:) name:PINJIASUCCESS object:nil];
    }return self;
}
/**
 评价成功的通知
 @param noti 评价成功的通知
 */
-(void)pinjiaSuccessAction:(NSNotification *)noti
{
    NSLog(@"评价通知的东西");
    [[NSNotificationCenter defaultCenter]removeObserver:self name:PINJIASUCCESS object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = RGB(240, 240, 240);
    self.page = 0;
    [self actionOrderNewData];
    [self setupTableView];
    [self setViewRefreshTableView:self.tableview withHeaderAction:@selector(actionOrderNewData) andFooterAction:@selector(actionOrderMoreData) target:self];
}
/**
 加载最新数据
 */
-(void)actionOrderNewData
{
    self.page = 0;
    [SVProgressHUD show];
    NSString *token = [[NSUserDefaults standardUserDefaults]valueForKey:ZF_TOKEN];
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"token"] = token;
    param[@"state"] = self.status;
    param[@"page"] = [NSString stringWithFormat:@"%d",self.page];
    WEAKSELF
    [[NetWorkTool shareInstacne]postWithURLString:Order_Status parameters:param success:^(id  _Nonnull responseObject) {
        [SVProgressHUD dismiss];
        NSLog(@"responseobject:%@",responseObject);
        ResponeModel *res = [ResponeModel mj_objectWithKeyValues:responseObject];
        if (res.code == 1) {
            [weakSelf.orderlistArray removeAllObjects];
            weakSelf.orderlistArray = [OrderStatusModel mj_objectArrayWithKeyValuesArray:res.data[@"orders"]];
        }else{
            [SVProgressHUD showErrorWithStatus:res.message];
            return;
        }
        [weakSelf.tableview reloadData];
        [weakSelf.tableview.mj_header endRefreshing];
    } failure:^(NSError * _Nonnull error) {
        [weakSelf.tableview.mj_header endRefreshing];
        [SVProgressHUD dismiss];
        [SVProgressHUD showErrorWithStatus:FailRequestTip];
        return;
    }];
}
/**
 加载更多的数据
 */
-(void)actionOrderMoreData
{
    self.page++;
    [SVProgressHUD show];
    NSString *token = [[NSUserDefaults standardUserDefaults]valueForKey:ZF_TOKEN];
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"token"] = token;
    param[@"state"] = self.status;
    param[@"page"] = [NSString stringWithFormat:@"%d",self.page];
    WEAKSELF
    [[NetWorkTool shareInstacne]postWithURLString:Order_Status parameters:param success:^(id  _Nonnull responseObject) {
        [SVProgressHUD dismiss];
        NSLog(@"responseobject:%@",responseObject);
        ResponeModel *res = [ResponeModel mj_objectWithKeyValues:responseObject];
        if (res.code == 1) {
            NSMutableArray *array = [NSMutableArray array];
            array = [OrderStatusModel mj_objectArrayWithKeyValuesArray:res.data[@"orders"]];
            [weakSelf.orderlistArray addObjectsFromArray:array];
        }else{
            [SVProgressHUD showErrorWithStatus:res.message];
            return;
        }
        [weakSelf.tableview reloadData];
        [weakSelf.tableview.mj_footer endRefreshing];
    } failure:^(NSError * _Nonnull error) {
        [weakSelf.tableview.mj_footer endRefreshing];
        [SVProgressHUD dismiss];
        [SVProgressHUD showErrorWithStatus:FailRequestTip];
        return;
    }];
}
-(void)setupTableView
{
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    self.tableview.backgroundColor = [UIColor clearColor];
    [self.tableview registerNib:[UINib nibWithNibName:@"OrderContentCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"OrderContentCell"];
}

#pragma mark -- uitableviewdelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.orderlistArray.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 250;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    OrderContentCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OrderContentCell"];
    OrderStatusModel *ordermodel = self.orderlistArray[indexPath.row];
    cell.orderModel = ordermodel;
    cell.tixingfahuoblock = ^(NSString *tagStr, OrderStatusModel *orderModel) {
        //提醒发货
        NSLog(@"提醒发货");
        if ([tagStr isEqualToString:@"提醒发货"]) {
            [SVProgressHUD showSuccessWithStatus:@"尽快发货"];
        }else if ([tagStr isEqualToString:@"确认收货"]){
            NSLog(@"确认收货");
            NSLog(@"orderModel:%@",orderModel);
            [SVProgressHUD show];
            NSString *token = [[NSUserDefaults standardUserDefaults]valueForKey:ZF_TOKEN];
            NSMutableDictionary *param = [NSMutableDictionary dictionary];
            param[@"token"] = token;
            param[@"cstate"] = @"3";
            param[@"oid"]   = orderModel.oid;
            WEAKSELF
            [[NetWorkTool shareInstacne]postWithURLString:User_Order_Update parameters:param success:^(id  _Nonnull responseObject) {
                NSLog(@"responseObject:%@",responseObject);
                [SVProgressHUD dismiss];
                ResponeModel *res = [ResponeModel mj_objectWithKeyValues:responseObject];
                if (res.code ==1) {
                    [SVProgressHUD showSuccessWithStatus:@"确认收货成功"];
                    [weakSelf RefreshWithView];
                }else{
                    [SVProgressHUD showErrorWithStatus:@"修改失败"];
                    return;
                }
            } failure:^(NSError * _Nonnull error) {
                [SVProgressHUD dismiss];
                [SVProgressHUD showErrorWithStatus:FailRequestTip];
                return;
            }];
        }
    };
    cell.chakanwuliublock = ^(NSString *tagStr, OrderStatusModel *orderModel) {
        //查看物流
        NSLog(@"查看物流");
        if ([tagStr isEqualToString:@"查看物流"]) {
            LogisticsVC *logisticvc = [[LogisticsVC alloc]init];
            logisticvc.statusmodel = orderModel;
            [self.navigationController pushViewController:logisticvc animated:YES];
        }
    };
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
//刷新界面
-(void)RefreshWithView
{
    self.page = 0;
    [SVProgressHUD show];
    NSString *token = [[NSUserDefaults standardUserDefaults]valueForKey:ZF_TOKEN];
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"token"] = token;
    param[@"state"] = self.status;
    param[@"page"] = [NSString stringWithFormat:@"%d",self.page];
    WEAKSELF
    [[NetWorkTool shareInstacne]postWithURLString:Order_Status parameters:param success:^(id  _Nonnull responseObject) {
        [SVProgressHUD dismiss];
        NSLog(@"responseobject:%@",responseObject);
        ResponeModel *res = [ResponeModel mj_objectWithKeyValues:responseObject];
        if (res.code == 1) {
            [weakSelf.orderlistArray removeAllObjects];
            weakSelf.orderlistArray = [OrderStatusModel mj_objectArrayWithKeyValuesArray:res.data[@"orders"]];
        }else{
            [SVProgressHUD showErrorWithStatus:res.message];
            return;
        }
        [weakSelf.tableview reloadData];
        [weakSelf.tableview.mj_header endRefreshing];
    } failure:^(NSError * _Nonnull error) {
        [weakSelf.tableview.mj_header endRefreshing];
        [SVProgressHUD dismiss];
        [SVProgressHUD showErrorWithStatus:FailRequestTip];
        return;
    }];
}
-(void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:PINJIASUCCESS object:nil];
}
@end
