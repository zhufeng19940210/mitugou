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
#import "AddreeModel.h"
@interface CommitOrderVC ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (weak, nonatomic) IBOutlet UILabel *total_lab;
@property (nonatomic,strong)NSMutableArray *addressArray;
@property (nonatomic,strong)AddreeModel *addressmodel;
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
    [SVProgressHUD show];
    NSString *token = [[NSUserDefaults standardUserDefaults]valueForKey:ZF_TOKEN];
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"token"] = token;
    WEAKSELF
    [[NetWorkTool shareInstacne]postWithURLString:Userinfo_Address_FindAll parameters:param success:^(id  _Nonnull responseObject) {
        [SVProgressHUD dismiss];
        ResponeModel *res = [ResponeModel mj_objectWithKeyValues:responseObject];
        if (res.code == 1) {
            [weakSelf.addressArray removeAllObjects];
            weakSelf.addressArray = [AddreeModel mj_objectArrayWithKeyValuesArray:res.data[@"address"]];
            for (int i = 0; i < weakSelf.addressArray.count;i++) {
                AddreeModel *model = weakSelf.addressArray[i];
                if (model.isDefault == 1) {
                    //是默认的
                    weakSelf.addressmodel = model;
                    break;
                }
                [weakSelf.tableview reloadData];
            }
        }else{
        }
    } failure:^(NSError * _Nonnull error) {
        [SVProgressHUD dismiss];
        [SVProgressHUD showErrorWithStatus:FailRequestTip];
        return;
    }];
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
        addressCell.nameandphone_lab.text = [NSString stringWithFormat:@"%@ %@",self.addressmodel.receName,self.addressmodel.phone];
        addressCell.detail_lab.text = [NSString stringWithFormat:@"%@",self.addressmodel.detailAddr];
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
        WEAKSELF
        addresslistvc.addressBlock = ^(AddreeModel *model) {
            weakSelf.addressmodel = model;
            [weakSelf.tableview reloadData];
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
    UIAlertController *sheet = [UIAlertController alertControllerWithTitle:@"请选择支付方式" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    //取消按钮
    UIAlertAction *cancle = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    //支付宝支付
    UIAlertAction *sure = [UIAlertAction actionWithTitle:@"支付宝支付" style:UIAlertActionStyleDefault  handler:^(UIAlertAction * _Nonnull action) {
        //TODO
        [self PayWithAlipayBtn];
    }];
    //微信支付方式
    UIAlertAction *delete = [UIAlertAction actionWithTitle:@"微信支付" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        //TODO
        [self PayWithWechatBtn];
    }];
    [sheet addAction:sure];
    [sheet addAction:cancle];
    [sheet addAction:delete];
    [self presentViewController:sheet animated:YES completion:^{
    }];
}
/**
  支付宝支付方式
 */
-(void)PayWithAlipayBtn
{
    NSLog(@"支付宝支付");
    [SVProgressHUD dismiss];
    NSString *token = [[NSUserDefaults standardUserDefaults]valueForKey:ZF_TOKEN];
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"token"] = token;
    [[NetWorkTool shareInstacne]postWithURLString:Pay_Alipay parameters:param success:^(id  _Nonnull responseObject) {
        [SVProgressHUD dismiss];
        ResponeModel *res = [ResponeModel mj_objectWithKeyValues:responseObject];
        if (res.code == 1) {
            // NOTE: 调用支付结果开始支付
            [[AlipaySDK defaultService] payOrder:@"" fromScheme:@"" callback:^(NSDictionary *resultDic) {
                NSLog(@"reslut = %@",resultDic);
                
            }];
        }else{
            [SVProgressHUD showErrorWithStatus:@"请求失败"];
            return;
        }
    } failure:^(NSError * _Nonnull error) {
        [SVProgressHUD dismiss];
        [SVProgressHUD showErrorWithStatus:FailRequestTip];
        return;
    }];
}
/**
 微信支付方式
 */
-(void)PayWithWechatBtn
{
    NSLog(@"微信支付");
    [SVProgressHUD dismiss];
    NSString *token = [[NSUserDefaults standardUserDefaults]valueForKey:ZF_TOKEN];
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"token"] = token;
    WEAKSELF
    [[NetWorkTool shareInstacne]postWithURLString:Pay_Wechat parameters:param success:^(id  _Nonnull responseObject) {
        [SVProgressHUD dismiss];
        ResponeModel *res = [ResponeModel mj_objectWithKeyValues:responseObject];
        if (res.code == 1) {
            [weakSelf weixinPayBtn];
        }else{
            [SVProgressHUD showErrorWithStatus:@"请求失败"];
            return;
        }
    } failure:^(NSError * _Nonnull error) {
        [SVProgressHUD dismiss];
        [SVProgressHUD showErrorWithStatus:FailRequestTip];
        return;
    }];
}
-(void)weixinPayBtn
{
//    PayReq *request = [[PayReq alloc] init];
//    /** 商家向财付通申请的商家id */
//    request.partnerId = model.partnerid;
//    /** 预支付订单 */
//    request.prepayId= model.prepayid;
//    /** 商家根据财付通文档填写的数据和签名 */
//    request.package = model.package;
//    /** 随机串，防重发 */
//    request.nonceStr= model.noncestr;
//    /** 时间戳，防重发 */
//    request.timeStamp= model.timestamp;
//    /** 商家根据微信开放平台文档对数据做的签名 */
//    request.sign= model.sign;
//    /*! @brief 发送请求到微信，等待微信返回onResp
//     *
//     * 函数调用后，会切换到微信的界面。第三方应用程序等待微信返回onResp。微信在异步处理完成后一定会调用onResp。支持以下类型
//     * SendAuthReq、SendMessageToWXReq、PayReq等。
//     * @param req 具体的发送请求，在调用函数后，请自己释放。
//     * @return 成功返回YES，失败返回NO。
//     */
//     */
//    [WXApi sendReq: request];
}
//缴费完成后的结果回调
-(void)thePayresults:(BOOL)isSucces
{
    if (isSucces == YES) {
        [ZJCustomHud showWithSuccess:@"付款成功！"];
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}
@end
