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
    [self setupData];
    [self setupTableView];
}
-(void)setupData
{
    
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
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.titleArray.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SettingAuthonCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SettingAuthonCell"];
    cell.content_lab.text = self.titleArray[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 0) {
        //个人信息
        SingleAuthonVC *uservc = [[SingleAuthonVC alloc]init];
        [self.navigationController pushViewController:uservc animated:YES];
    }else if(indexPath.row == 1){
        //人脸识别
        FaceAuthonVC *facevc = [[FaceAuthonVC alloc]init];
        [self.navigationController pushViewController:facevc animated:YES];
    }else if(indexPath.row == 2){
        //银行卡认证
        CardAuthonVC *cardvc = [[CardAuthonVC alloc]init];
        [self.navigationController pushViewController:cardvc animated:YES];
    }else if(indexPath.row == 3){
        //运营商认证
        YunYinShangAuthonVC *yunxinshangvc = [[YunYinShangAuthonVC alloc]init];
        [self.navigationController pushViewController:yunxinshangvc animated:YES];
    }else if(indexPath.row == 4){
        //支付宝认证
        ZhifubaoPayAuthonVC *zhifubaovc = [[ZhifubaoPayAuthonVC alloc]init];
        [self.navigationController pushViewController:zhifubaovc animated:YES];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
@end
