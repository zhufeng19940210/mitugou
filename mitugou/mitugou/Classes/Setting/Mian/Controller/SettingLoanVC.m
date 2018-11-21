//  SettingLoanVC.m
//  mitugou
//  Created by zhufeng on 2018/11/8.
//  Copyright © 2018 zhufeng. All rights reserved.
#import "SettingLoanVC.h"
#import "LoanModel.h"
@interface SettingLoanVC ()
@property (nonatomic,strong)NSMutableArray *loanArray;
@end

@implementation SettingLoanVC
-(NSMutableArray *)loanArray
{
    if (!_loanArray) {
        _loanArray = [NSMutableArray array];
    }
    return _loanArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"我的借款";
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
        if (res.code == 1 ) {
            [weakSelf.loanArray removeAllObjects];
            weakSelf.loanArray = [LoanModel mj_objectArrayWithKeyValuesArray:res.data[@""]];
        }
    } failure:^(NSError * _Nonnull error) {
        [SVProgressHUD dismiss];
        [SVProgressHUD showErrorWithStatus:FailRequestTip];
        return;
    }];
}
@end
