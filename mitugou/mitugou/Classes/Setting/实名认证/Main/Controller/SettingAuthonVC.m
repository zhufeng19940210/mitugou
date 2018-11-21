//  SettingAuthonVC.m
//  mitugou
//  Created by zhufeng on 2018/11/8.
//  Copyright © 2018 zhufeng. All rights reserved.
#import "SettingAuthonVC.h"
#import "SettingAuthonCell.h"
#import "SingleAuthonVC.h"
#import "FaceAuthonVC.h"
#import "CardAuthonVC.h"
#import "YunYinShangAuthonVC.h"
#import "ZhifubaoPayAuthonVC.h"
@interface SettingAuthonVC ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (nonatomic,strong)NSMutableArray *titleArray;
@property (nonatomic,strong)NSDictionary *responseDict;
@end
@implementation SettingAuthonVC
-(NSMutableArray *)titleArray
{
    if (!_titleArray) {
        _titleArray = [NSMutableArray arrayWithObjects:@"个人信息认证",@"人脸识别认证",@"银行卡认证",@"运营商认证",@"支付宝认证", nil];
    }
    return _titleArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"实名认证";
    self.view.backgroundColor = RGB(240, 240, 240);
    [self setupData];
    [self setupTableView];
}
/**
 这里有个状态的东西
 */
-(void)setupData
{
    [SVProgressHUD show];
    NSString *token = [[NSUserDefaults standardUserDefaults]valueForKey:ZF_TOKEN];
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"token"] = token;
    WEAKSELF
    [[NetWorkTool shareInstacne]postWithURLString:@"" parameters:param success:^(id  _Nonnull responseObject) {
        [SVProgressHUD dismiss];
        ResponeModel *res = [ResponeModel mj_objectWithKeyValues:responseObject];
        if (res.code == 1) {
            weakSelf.responseDict = res.data[@"status"];
            [weakSelf.tableview reloadData];
        }else{
            [SVProgressHUD showErrorWithStatus:@"获取失败"];
            return;
        }
    } failure:^(NSError * _Nonnull error) {
        [SVProgressHUD dismiss];
        [SVProgressHUD showInfoWithStatus:FailRequestTip];
        return;
    }];
}
-(void)setupTableView
{
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    self.tableview.backgroundColor = [UIColor clearColor];
    [self.tableview registerNib:[UINib nibWithNibName:@"SettingAuthonCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"SettingAuthonCell"];
}
#pragma mark -- uitableviewdelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.titleArray.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
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
    if (section == self.titleArray.count-1) {
        return 10;
    }else{
        return 5;
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SettingAuthonCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SettingAuthonCell"];
    cell.content_lab.text = self.titleArray[indexPath.section];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
        //个人信息
        SingleAuthonVC *uservc = [[SingleAuthonVC alloc]init];
        [self.navigationController pushViewController:uservc animated:YES];
    }else if(indexPath.section == 1){
        //人脸识别
        FaceAuthonVC *facevc = [[FaceAuthonVC alloc]init];
        [self.navigationController pushViewController:facevc animated:YES];
    }else if(indexPath.section == 2){
        //银行卡认证
        CardAuthonVC *cardvc = [[CardAuthonVC alloc]init];
        [self.navigationController pushViewController:cardvc animated:YES];
    }else if(indexPath.section == 3){
        //运营商认证
        YunYinShangAuthonVC *yunxinshangvc = [[YunYinShangAuthonVC alloc]init];
        [self.navigationController pushViewController:yunxinshangvc animated:YES];
    }else if(indexPath.section == 4){
        //支付宝认证
        ZhifubaoPayAuthonVC *zhifubaovc = [[ZhifubaoPayAuthonVC alloc]init];
        [self.navigationController pushViewController:zhifubaovc animated:YES];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
@end
