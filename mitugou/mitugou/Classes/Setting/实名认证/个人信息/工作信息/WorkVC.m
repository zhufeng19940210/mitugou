//  WorkVC.m
//  mitugou
//  Created by zhufeng on 2018/11/10.
//  Copyright © 2018 zhufeng. All rights reserved.
#import "WorkVC.h"
@interface WorkVC ()
@property (weak, nonatomic) IBOutlet UITextField *work_tyep_tf;
@property (weak, nonatomic) IBOutlet UITextField *monthlyincome_tf;
@property (weak, nonatomic) IBOutlet UITextField *total_age_tf;
@end
@implementation WorkVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"工作信息";
    [self setupData];
}
-(void)setupData
{
    [SVProgressHUD show];
    NSString *token = [[NSUserDefaults standardUserDefaults]valueForKey:ZF_TOKEN];
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"token"]= token;
    [[NetWorkTool shareInstacne]postWithURLString:Userinfo_Work_Url_Find parameters:param success:^(id  _Nonnull responseObject) {
        NSLog(@"responseObject:%@",responseObject);
        [SVProgressHUD dismiss];
        ResponeModel *res = [ResponeModel mj_objectWithKeyValues:responseObject];
        if (res.code == 1) {
                [SVProgressHUD showSuccessWithStatus:@"获取成功"];
                NSDictionary *infoData = res.data[@"infodata"];
                //什么东西都去想了
                NSString *job     = infoData[@"job"];
                NSString *income  = infoData[@"income"];
                NSString *working = infoData[@"working"];
                self.work_tyep_tf.text = job;
                self.monthlyincome_tf.text = income;
                self.total_age_tf.text = working;
        }else if (res.code == 2) {
            [SVProgressHUD showSuccessWithStatus:@"暂无数据"];
            return;
        }
        else{
            [SVProgressHUD showWithStatus:@"获取失败"];
            return;
        }
    } failure:^(NSError * _Nonnull error) {
        [SVProgressHUD dismiss];
        [ZFCustomView showWithText:FailRequestTip WithDurations:0.5];
        return;
    }];
}
/**
 保存数据
 @param sender 保存数据
 */
- (IBAction)actionSaveBtn:(UIButton *)sender
{
    NSString *work     = self.work_tyep_tf.text;
    NSString *moneth   = self.monthlyincome_tf.text;
    NSString *age      = self.total_age_tf.text;
    if (work.length == 0 || [work isEqualToString:@""] ) {
        [self showHint:@"工作类型不能为空" yOffset:-200];
        return;
    }
    if (moneth.length == 0 || [moneth isEqualToString:@""]) {
        [self showHint:@"月收入不能为空" yOffset:-200];
        return;
    }
    if (age.length == 0 || [age isEqualToString:@""]) {
        [self showHint:@"总工龄不能为空" yOffset:-200];
        return;
    }
    [SVProgressHUD show];
    NSString *token = [[NSUserDefaults standardUserDefaults]valueForKey:ZF_TOKEN];
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"token"]   = token;
    param[@"job"]     = work;
    param[@"income"]  = moneth;
    param[@"working"] = age;
    [[NetWorkTool shareInstacne]postWithURLString:Userinfo_Work_Url_Update parameters:param success:^(id  _Nonnull responseObject) {
        [SVProgressHUD dismiss];
        ResponeModel *res = [ResponeModel mj_objectWithKeyValues:responseObject];
        if (res.code ==1) {
            [SVProgressHUD showSuccessWithStatus:@"上传成功"];
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            [SVProgressHUD showErrorWithStatus:@"上传失败"];
            return;
        }
    } failure:^(NSError * _Nonnull error) {
        [SVProgressHUD dismiss];
        [SVProgressHUD showErrorWithStatus:FailRequestTip];
        return;
    }];
}
@end
