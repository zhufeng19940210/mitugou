//  CardAuthonVC2.m
//  mitugou
//  Created by zhufeng on 2018/12/5.
//  Copyright © 2018 zhufeng. All rights reserved.
#import "CardAuthonVC2.h"
@interface CardAuthonVC2 ()
@property (weak, nonatomic) IBOutlet UITextField *card_tf;
@property (weak, nonatomic) IBOutlet UITextField *phone_tf;
@end
@implementation CardAuthonVC2
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"银行卡认证";
    [self setupData];
}
/**
 获取信息
 */
-(void)setupData
{
    [SVProgressHUD show];
    NSString *token = [[NSUserDefaults standardUserDefaults]valueForKey:ZF_TOKEN];
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"token"] = token;
    WEAKSELF
    [[NetWorkTool shareInstacne]postWithURLString:Userinfo_Card_Find parameters:param success:^(id  _Nonnull responseObject) {
        NSLog(@"responobject:%@",responseObject);
        [SVProgressHUD dismiss];
        ResponeModel *res = [ResponeModel mj_objectWithKeyValues:responseObject];
        if (res.code == 1) {
            [SVProgressHUD showSuccessWithStatus:@"获取成功"];
            weakSelf.card_tf.text = res.data[@"bankinfo"][@"bankNumber"];
            weakSelf.phone_tf.text = res.data[@"bankinfo"][@"bankPhone"];
        }else if (res.code == 2 ){
            [SVProgressHUD showSuccessWithStatus:@"暂无数据"];
            return;
        }else{
            [SVProgressHUD showErrorWithStatus:@"获取失败"];
            return;
        }
    } failure:^(NSError * _Nonnull error) {
        [SVProgressHUD dismiss];
        [SVProgressHUD showErrorWithStatus:FailRequestTip];
        return;
    }];
}
/**
 上传
 @param sender upload
 */
- (IBAction)actionCommitBtn:(UIButton *)sender
{
    NSString *card  = self.card_tf.text;
    NSString *phone = self.phone_tf.text;
    if (card.length == 0 || [card isEqualToString:@""]) {
        [self showHint:@"银行卡不能为空" yOffset:-200];
        return;
    }
    if (phone.length == 0 || [phone isEqualToString:@""]) {
        [self showHint:@"手机号码不能为空" yOffset:-200];
        return;
    }
    if (phone.length != 11) {
        [self showHint:@"手机号码为11位" yOffset:-200];
        return;
    }
    [SVProgressHUD show];
    NSString *token = [[NSUserDefaults standardUserDefaults]valueForKey:ZF_TOKEN];
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"token"] = token;
    param[@"bankphone"] = phone;
    param[@"banknumber"] = card;
    WEAKSELF
    [[NetWorkTool shareInstacne]postWithURLString:Userinfo_Card_Upload parameters:param success:^(id  _Nonnull responseObject) {
        NSLog(@"responobject:%@",responseObject);
        [SVProgressHUD dismiss];
        ResponeModel *res = [ResponeModel mj_objectWithKeyValues:responseObject];
        if (res.code == 1) {
            [SVProgressHUD showSuccessWithStatus:@"上传成功"];
            [weakSelf.navigationController popViewControllerAnimated:YES];
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
- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
}

@end
