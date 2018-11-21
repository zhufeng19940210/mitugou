//  SettingRepaymentVC.m
//  mitugou
//  Created by zhufeng on 2018/11/8.
//  Copyright © 2018 zhufeng. All rights reserved.
#import "SettingRepaymentVC.h"
#import "RepayModel.h"
@interface SettingRepaymentVC ()
@property (nonatomic,strong)NSMutableArray *repayArray;
@end

@implementation SettingRepaymentVC
-(NSMutableArray *)repayArray
{
    if (!_repayArray) {
        _repayArray = [NSMutableArray array];
    }
    return _repayArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"我的还款";
    [self setupData];
}

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
        if (res.code ==1) {
            [weakSelf.repayArray removeAllObjects];
            weakSelf.repayArray = [RepayModel mj_objectArrayWithKeyValuesArray:res.data[@""]];
        }
    } failure:^(NSError * _Nonnull error) {
        [SVProgressHUD dismiss];
        [SVProgressHUD showErrorWithStatus:FailRequestTip];
        return;
    }];
}
@end
