//  LogisticsVC.m
//  mitugou
//  Created by zhufeng on 2018/12/3.
//  Copyright © 2018 zhufeng. All rights reserved.
#import "LogisticsVC.h"
#import "LogisticsCell.h"
#import "LogisticModel.h"
@interface LogisticsVC () <UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (nonatomic,strong)NSMutableArray *logisArray;
@end

@implementation LogisticsVC
-(NSMutableArray *)logisArray
{
    if (!_logisArray) {
        _logisArray = [NSMutableArray array];
    }
    return _logisArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"物流管理";
    [self setupTableView];
    [self setupData];
}
-(void)setupData
{
    [SVProgressHUD show];
    NSString *token = [[NSUserDefaults standardUserDefaults]valueForKey:ZF_TOKEN];
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"token"] = token;
    WEAKSELF
    [[NetWorkTool shareInstacne]postWithURLString:Order_Logistic_Url parameters:param success:^(id  _Nonnull responseObject) {
        NSLog(@"responobject:%@",responseObject);
        ResponeModel *res = [ResponeModel mj_objectWithKeyValues:responseObject];
        if (res.code == 1  ) {
            [SVProgressHUD showSuccessWithStatus:@"请求成功"];
            [weakSelf.logisArray removeAllObjects];
            weakSelf.logisArray  = [LogisticModel mj_objectArrayWithKeyValuesArray:res.data[@""]];
        }else{
            [SVProgressHUD showErrorWithStatus:res.message];
            return ;
        }
        [weakSelf.tableview reloadData];
    } failure:^(NSError * _Nonnull error) {
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
    [self.tableview registerNib:[UINib nibWithNibName:@"LogisticsCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"LogisticsCell"];
}
#pragma mark -- uitableviewdelegate

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.logisArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LogisticsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LogisticsCell"];
    LogisticModel *model = self.logisArray[indexPath.row];
    cell.logisticmodel = model;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return  cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
