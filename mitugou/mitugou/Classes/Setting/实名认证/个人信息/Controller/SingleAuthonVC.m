//  SingleAuthonVC.m
//  mitugou
//  Created by zhufeng on 2018/11/8.
//  Copyright © 2018 zhufeng. All rights reserved.
#import "SingleAuthonVC.h"
#import "SingleAuthonCell.h"
#import "ContactVC.h"    //联系人信息
#import "WorkVC.h"       //工作信息
#import "PersonVC.h"     //个人信息
#import "PersonCardVC.h" //上传身份证照片
#import "PeronsBaseVC.h" //基本信息
#import "CardAuthonVC.h" //银行卡信息
#import "ZhifubaoPayAuthonVC.h" ///支付宝信用
#import "CardAuthonVC2.h"
@interface SingleAuthonVC ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (nonatomic,strong)NSMutableArray *titleArray;
@end

@implementation SingleAuthonVC
-(NSMutableArray *)titleArray
{
    if (!_titleArray) {
        _titleArray = [NSMutableArray arrayWithObjects:@"基本信息",@"上传身份证照片",@"个人信息",@"工作信息",@"联系人信息",@"银行卡信息",@"支付宝信用", nil];
    }
    return _titleArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"个人信息";
    self.view.backgroundColor = RGB(240, 240, 240);
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
    [self.tableview registerNib:[UINib nibWithNibName:@"SingleAuthonCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"SingleAuthonCell"];
}
#pragma mark -- uitableviewdelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return  self.titleArray.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}
//-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
//{
//    if (section == 0) {
//        return 10;
//    }else{
//        return 5;
//    }
//}
//- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
//{
//    if (section == self.titleArray.count-1) {
//        return 10;
//    }else{
//        return 5;
//    }
//}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SingleAuthonCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SingleAuthonCell"];
    cell.title_lab.text = self.titleArray[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 0) {
        //基本信息
        PeronsBaseVC *basevc = [[PeronsBaseVC alloc]init];
        [self.navigationController pushViewController:basevc animated:YES];
    }else if(indexPath.row == 1){
        //上传证件照片
        PersonCardVC *cardvc = [[PersonCardVC alloc]init];
        [self.navigationController pushViewController:cardvc animated:YES];
    }else if(indexPath.row == 2){
        //个人信息
        PersonVC *personvc = [[PersonVC alloc]init];
        [self.navigationController pushViewController:personvc animated:YES];
    }else if(indexPath.row == 3){
        //工作信息
        WorkVC *workvc = [[WorkVC alloc]init];
        [self.navigationController pushViewController:workvc animated:YES];
    }else if(indexPath.row == 4){
        //联系人信息
        ContactVC *contactvc = [[ContactVC alloc]init];
        [self.navigationController pushViewController:contactvc animated:YES];
    }else if (indexPath.row == 5){
        //银行卡信息
        CardAuthonVC2 *cardauthovc = [[CardAuthonVC2 alloc]init];
        [self.navigationController pushViewController:cardauthovc animated:YES];
        //CardAuthonVC *cardauthovc = [[CardAuthonVC alloc]init];
        //[self.navigationController pushViewController:cardauthovc animated:YES];
    }else if (indexPath.row){
        //支付宝信用
        ZhifubaoPayAuthonVC *zhifubaovc = [[ZhifubaoPayAuthonVC alloc]init];
        [self.navigationController pushViewController:zhifubaovc animated:YES];
    }
}
@end
