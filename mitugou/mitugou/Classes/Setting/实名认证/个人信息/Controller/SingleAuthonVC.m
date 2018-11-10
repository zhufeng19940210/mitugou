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
@interface SingleAuthonVC ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (nonatomic,strong)NSMutableArray *titleArray;
@end

@implementation SingleAuthonVC
-(NSMutableArray *)titleArray
{
    if (!_titleArray) {
        _titleArray = [NSMutableArray arrayWithObjects:@"基本信息",@"上传身份证照片",@"个人信息",@"工作信息",@"联系人信息", nil];
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
    return self.titleArray.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return  1;
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
    SingleAuthonCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SingleAuthonCell"];
    cell.title_lab.text = self.titleArray[indexPath.section];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
        //基本信息
        PeronsBaseVC *basevc = [[PeronsBaseVC alloc]init];
        [self.navigationController pushViewController:basevc animated:YES];
    }else if(indexPath.section == 1){
        //上传证件照片
        PersonCardVC *cardvc = [[PersonCardVC alloc]init];
        [self.navigationController pushViewController:cardvc animated:YES];
    }else if(indexPath.section == 2){
        //个人信息
        PersonVC *personvc = [[PersonVC alloc]init];
        [self.navigationController pushViewController:personvc animated:YES];
    }else if(indexPath.section == 3){
        //工作信息
        WorkVC *workvc = [[WorkVC alloc]init];
        [self.navigationController pushViewController:workvc animated:YES];
    }else if(indexPath.section == 4){
        //联系人信息
        ContactVC *contactvc = [[ContactVC alloc]init];
        [self.navigationController pushViewController:contactvc animated:YES];
    }
}

@end
