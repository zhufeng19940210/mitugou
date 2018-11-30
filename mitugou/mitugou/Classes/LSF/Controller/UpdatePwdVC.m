//  UpdatePwdVC.m
//  mitugou
//  Created by zhufeng on 2018/11/8.
//  Copyright © 2018 zhufeng. All rights reserved.
#import "UpdatePwdVC.h"
@interface UpdatePwdVC ()
@property (weak, nonatomic) IBOutlet UITextField *pwd_tf;
@end
@implementation UpdatePwdVC
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"修改密码";
}
/**
 提交用户
 @param sender 提交用户
 */
- (IBAction)actionCommitBtn:(UIButton *)sender
{
    [self.pwd_tf resignFirstResponder];
    NSString *pwd     = self.pwd_tf.text;
    if (pwd.length == 0 || [pwd isEqualToString:@""]) {
        [self showHint:@"新密码不能为空" yOffset:-200];
        return;
    }
    [SVProgressHUD show];
    NSString *token = [[NSUserDefaults standardUserDefaults]valueForKey:ZF_TOKEN];
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"token"]         = token;
    param[@"password"]      =  pwd;
    WEAKSELF
    [[NetWorkTool shareInstacne]postWithURLString:User_Change_Pwd parameters:param success:^(id  _Nonnull responseObject) {
        NSLog(@"responseobject:%@",responseObject);
        ResponeModel *res = [ResponeModel mj_objectWithKeyValues:responseObject];
        if (res.code == 1) {
            [SVProgressHUD showSuccessWithStatus:@"修改成功"];
            [weakSelf.navigationController popViewControllerAnimated:YES];
        }
    } failure:^(NSError * _Nonnull error) {
        [SVProgressHUD showErrorWithStatus:FailRequestTip];
        return;
    }];
}

@end
