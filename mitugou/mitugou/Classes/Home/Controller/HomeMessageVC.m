//  HomeMessageVC.m
//  mitugou
//  Created by zhufeng on 2018/11/7.
//  Copyright © 2018 zhufeng. All rights reserved.
#import "HomeMessageVC.h"
#import "HomeMessageCell.h"
#import "HomeMessageModel.h"
@interface HomeMessageVC ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (nonatomic,strong)NSMutableArray *messageArray;
@property (nonatomic,assign)int page;
@end
@implementation HomeMessageVC
-(NSMutableArray *)messageArray
{
    if (!_messageArray) {
        _messageArray = [NSMutableArray array];
    }
    return _messageArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"系统消息";
    self.page = 0;
    [self setRightButtonText:@"删除全部" withColor:[UIColor whiteColor]];
    [self actionMessageNewData];
    [self setupTableView];
    [self setupRefresh];
}
-(void)refresh
{
    [self actionMessageNewData];
    [self.tableview reloadData];
}

/**
 清空全部的东西
 @param button 请求空全部的
 */
- (void)onRightBtnAction:(UIButton *)button
{
    if (self.messageArray.count > 0) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"您确定要删除全部的信息吗?" preferredStyle:UIAlertControllerStyleAlert];
        //取消按钮
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        //确定按钮
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            //TODO
            [self clearAllMessageMethod];
        }];
        [alertController addAction:cancelAction];
        [alertController addAction:okAction];
        [self presentViewController:alertController animated:YES completion:nil];
    }else{
        [SVProgressHUD showErrorWithStatus:@"当前消息列表为空"];
        return;
    }
}
/**
 清空全部的消息
 */
-(void)clearAllMessageMethod
{
    [SVProgressHUD show];
    NSString *token = [[NSUserDefaults standardUserDefaults]valueForKey:ZF_TOKEN];
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"token"] = token;
    WEAKSELF
    [[NetWorkTool shareInstacne]postWithURLString:Home_Message_Clear parameters:param success:^(id  _Nonnull responseObject) {
        [SVProgressHUD dismiss];
        NSLog(@"responeobject:%@",responseObject);
        ResponeModel *res = [ResponeModel mj_objectWithKeyValues:responseObject];
        if (res.code == 1) {
            [SVProgressHUD showSuccessWithStatus:@"删除成功"];
            [weakSelf refresh];
        }else{
            [SVProgressHUD showErrorWithStatus:@"删除失败"];
            return;
        }
    } failure:^(NSError * _Nonnull error) {
        [SVProgressHUD dismiss];
        [SVProgressHUD showErrorWithStatus:FailRequestTip];
        return;
    }];
}

-(void)setupRefresh
{
    [self setViewRefreshTableView:self.tableview withHeaderAction:@selector(actionMessageNewData) andFooterAction:@selector(actionMessageMoreData) target:self];
}
/**
 加载最新
 */
-(void)actionMessageNewData
{
    self.page = 0;
    [SVProgressHUD show];
    NSString *token = [[NSUserDefaults standardUserDefaults]valueForKey:ZF_TOKEN];
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"token"] = token;
    param[@"page"]  = [NSString stringWithFormat:@"%d",self.page];
    WEAKSELF
    [[NetWorkTool shareInstacne]postWithURLString:Home_Message_All parameters:param success:^(id  _Nonnull responseObject) {
        NSLog(@"responseObject:%@",responseObject);
        [SVProgressHUD dismiss];
        ResponeModel *res = [ResponeModel mj_objectWithKeyValues:responseObject];
        if (res.code == 1) {
            [SVProgressHUD showSuccessWithStatus:@"获取成功"];
            [weakSelf.messageArray removeAllObjects];
            weakSelf.messageArray = [HomeMessageModel mj_keyValuesArrayWithObjectArray:res.data[@"infomations"]];
        }else{
            [SVProgressHUD showErrorWithStatus:@"获取失败"];
            return;
        }
        [weakSelf.tableview reloadData];
        [weakSelf.tableview.mj_header endRefreshing];
    } failure:^(NSError * _Nonnull error) {
        [SVProgressHUD dismiss];
        [SVProgressHUD showErrorWithStatus:FailRequestTip];
        [weakSelf.tableview.mj_header endRefreshing];
        return;
    }];
}
/**
 加载更多
 */
-(void)actionMessageMoreData
{
    self.page++;
    [SVProgressHUD show];
    NSString *token = [[NSUserDefaults standardUserDefaults]valueForKey:ZF_TOKEN];
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"token"] = token;
    param[@"page"]  = [NSString stringWithFormat:@"%d",self.page];
    WEAKSELF
    [[NetWorkTool shareInstacne]postWithURLString:Home_Message_All parameters:param success:^(id  _Nonnull responseObject) {
        [SVProgressHUD dismiss];
        ResponeModel *res = [ResponeModel mj_objectWithKeyValues:responseObject];
        if (res.code == 1) {
            [SVProgressHUD showSuccessWithStatus:@"获取成功"];
            NSMutableArray *array = [NSMutableArray array];
            weakSelf.messageArray = [HomeMessageModel mj_objectArrayWithKeyValuesArray:res.data[@"infomations"]];
            [weakSelf.messageArray addObjectsFromArray:array];
        }else{
            [SVProgressHUD showErrorWithStatus:@"获取失败"];
            return;
        }
        [weakSelf.tableview reloadData];
        [weakSelf.tableview.mj_footer endRefreshing];
    } failure:^(NSError * _Nonnull error) {
        [SVProgressHUD dismiss];
        [SVProgressHUD showErrorWithStatus:FailRequestTip];
        [weakSelf.tableview.mj_footer endRefreshing];
        return;
    }];
}
-(void)setupTableView
{
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    self.tableview.backgroundColor = [UIColor clearColor];
    [self.tableview registerNib:[UINib nibWithNibName:@"HomeMessageCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"HomeMessageCell"];
}
#pragma mark uitableviewdelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSLog(@"self.messageArray.count:%lu",(unsigned long)self.messageArray.count);
    return self.messageArray.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HomeMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HomeMessageCell"];
    NSDictionary *dic = self.messageArray[indexPath.row];
    NSLog(@"model:%@",dic[@"content"]);
    cell.title_lab.text   = [NSString stringWithFormat:@"%@",dic[@"header"]];
    cell.content_lab.text = [NSString stringWithFormat:@"%@",dic[@"content"]];
    cell.time_lab.text    = [NSString stringWithFormat:@"%@",[LCUtil timestampSwitchTime:dic[@"createtime"] andFormatter:@"yyyy-MM-dd HH:mm:ss"]];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}
// 定义编辑样式
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete;
}

// 进入编辑模式，按下出现的编辑按钮后,进行删除操作
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSDictionary *dic = self.messageArray[indexPath.row];
        [self deleteWithSingleId:dic[@"iid"]];
    }
}
// 修改编辑按钮文字
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
}
/**
 删除单个的消息
 @param mid
 */
-(void)deleteWithSingleId:(NSString *)mid
{
    NSLog(@"mid:%@",mid);
    [SVProgressHUD show];
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    NSString *token = [[NSUserDefaults standardUserDefaults]valueForKey:ZF_TOKEN];
    param[@"token"] = token;
    param[@"iid"] = mid;
    WEAKSELF
    [[NetWorkTool shareInstacne]postWithURLString:Home_Message_Del parameters:param success:^(id  _Nonnull responseObject) {
        [SVProgressHUD dismiss];
        NSLog(@"responseObject:%@",responseObject);
        ResponeModel *res = [ResponeModel mj_objectWithKeyValues:responseObject];
        if (res.code == 1) {
            [SVProgressHUD showSuccessWithStatus:@"删除成功"];
            [weakSelf refresh];
        }else{
            [SVProgressHUD showErrorWithStatus:@"删除失败"];
            return;
        }
    } failure:^(NSError * _Nonnull error) {
        [SVProgressHUD dismiss];
        [SVProgressHUD showErrorWithStatus:FailRequestTip];
        return;
    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
@end
