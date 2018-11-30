//  ContactVC.m
//  mitugou
//  Created by zhufeng on 2018/11/10.
//  Copyright © 2018 zhufeng. All rights reserved.
#import "ContactVC.h"
@interface ContactVC ()
@property (weak, nonatomic) IBOutlet UITextField *name_tf;
@property (weak, nonatomic) IBOutlet UITextField *phone_tf;
@property (weak, nonatomic) IBOutlet UITextField *society_tf;
@end
@implementation ContactVC
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"联系人信息";
    [self setupData];
}
/**
 请求数据
 */
-(void)setupData
{
    [SVProgressHUD show];
    NSString *token = [[NSUserDefaults standardUserDefaults]valueForKey:ZF_TOKEN];
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"token"] = token;
    [[NetWorkTool shareInstacne]postWithURLString:Userinfo_Contact_Url_Find parameters:param success:^(id  _Nonnull responseObject) {
        NSLog(@"responseObject:%@",responseObject);
        [SVProgressHUD dismiss];
        ResponeModel *res = [ResponeModel mj_objectWithKeyValues:responseObject];
        if (res.code==1) {
                [SVProgressHUD showSuccessWithStatus:@"获取成功"];
                NSDictionary *infodata = res.data[@"infodata"];
                NSString *name     = infodata[@"contactname"];
                NSString *phone    = infodata[@"contactphone"];
                NSString *relation = infodata[@"relation"];
                self.name_tf.text = name;
                self.phone_tf.text = phone;
                self.society_tf.text = relation;
        }else if (res.code==2) {
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
 保存方法
 @param sender 保存方法
 */
- (IBAction)actionSaveBtn:(UIButton *)sender
{
    NSString *name     = self.name_tf.text;
    NSString *phone    = self.phone_tf.text;
    NSString *society  = self.society_tf.text;
    if (name.length == 0 || [name isEqualToString:@""]) {
        [self showHint:@"联系人姓名不能为空" yOffset:-200];
        return;
    }
    if (phone.length == 0 || [phone isEqualToString:@""]) {
        [self showHint:@"联系人号码不能为空" yOffset:-200];
        return;
    }
    if (society.length == 0 || [society isEqualToString:@""]) {
        [self showHint:@"联系人社会关系不能为空" yOffset:-200];
        return;
    }
    [SVProgressHUD show];
    NSString *token = [[NSUserDefaults standardUserDefaults]valueForKey:ZF_TOKEN];
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"token"] = token;
    param[@"contactname"] = name;
    param[@"contactphone"] = phone;
    param[@"relation"] = society;
    [[NetWorkTool shareInstacne]postWithURLString:Userinfo_Contact_Url_Update parameters:param success:^(id  _Nonnull responseObject) {
        [SVProgressHUD dismiss];
        ResponeModel *res = [ResponeModel mj_objectWithKeyValues:responseObject];
        if (res.code == 1) {
            [[NSUserDefaults standardUserDefaults]setBool:YES forKey:User_Authon5];
            [[NSUserDefaults standardUserDefaults]synchronize];
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
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
@end
