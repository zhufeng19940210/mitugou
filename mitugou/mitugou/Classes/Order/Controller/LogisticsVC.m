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
    [self setupRefresh];
}
//集成刷新功能
-(void)setupRefresh
{
    //[self setViewRefreshTableView:self.tableview withHeaderAction:@selector(actionNewData) andFooterAction:@selector(actionNewData) target:self];
}


-(void)setupData
{
    [SVProgressHUD show];
    NSString *token = [[NSUserDefaults standardUserDefaults]valueForKey:ZF_TOKEN];
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    NSLog(@"self.statusmodel.express:%@",self.statusmodel.express);
    NSLog(@"self.statusmodel.company:%@",self.statusmodel.company);
    param[@"token"] = token;
    param[@"express"] = self.statusmodel.express;
    param[@"company"] = self.statusmodel.company;
    WEAKSELF
    [[NetWorkTool shareInstacne]postWithURLString:Express_Url parameters:param success:^(id  _Nonnull responseObject) {
        NSLog(@"responobject:%@",responseObject);
        ResponeModel *res = [ResponeModel mj_objectWithKeyValues:responseObject];
        if (res.code == 1  ) {
            [SVProgressHUD showSuccessWithStatus:@"请求成功"];
            NSString *expressStr = responseObject[@"data"][@"express"];
            NSDictionary *dicStr =  [self dictionaryWithJsonString:expressStr];
            NSLog(@"dicStr:%@",dicStr);
            [weakSelf.logisArray removeAllObjects];
            weakSelf.logisArray  = [LogisticModel mj_objectArrayWithKeyValuesArray:dicStr[@"Traces"]];
        }else{
            [SVProgressHUD showErrorWithStatus:@"请求失败"];
            return ;
        }
        [weakSelf.tableview reloadData];
    } failure:^(NSError * _Nonnull error) {
        [SVProgressHUD dismiss];
        [SVProgressHUD showErrorWithStatus:FailRequestTip];
        return;
    }];
}

- (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString
{
    if (jsonString == nil) {
        return nil;
    }
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err)
    {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
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
    return 80;
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
