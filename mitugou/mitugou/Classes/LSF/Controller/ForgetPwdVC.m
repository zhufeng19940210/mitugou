//  ForgetPwdVC.m
//  aboluo
//  Created by zhufeng on 2018/11/3.
//  Copyright © 2018年 zhufeng. All rights reserved.
#import "ForgetPwdVC.h"
#import "UIButton+countDown.h"
@interface ForgetPwdVC ()
@property (weak, nonatomic) IBOutlet UITextField *phone_tf;
@property (weak, nonatomic) IBOutlet UITextField *code_tf;
@property (weak, nonatomic) IBOutlet UITextField *pwd_tf;
@property (weak, nonatomic) IBOutlet UITextField *pwd_again_tf;
@property (weak, nonatomic) IBOutlet UIButton *eye_btn;
@property (weak, nonatomic) IBOutlet UIButton *eye_btn2;
@property (nonatomic,copy) NSString  *codeStr; ///验证码的code
@property (nonatomic,copy) NSString  *currentPhone; //当前输入的手机号码
@end
@implementation ForgetPwdVC
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"忘记密码";
}
/**
 获取验证码
 @param sender 获取验证码
 */
- (IBAction)actionGetCodeBtn:(UIButton *)sender
{
    NSString *phone = self.phone_tf.text;
    if (phone.length == 0 || [phone isEqualToString:@""])
    {
        [self showHint:@"手机号码不能为空" yOffset:-200];
        return;
    }
    if (![LCUtil isMobileNumber:phone]) {
        [self showHint:@"手机号码有误" yOffset:-200];
        return;
    }
    [SVProgressHUD showWithStatus:@"获取验证码"];
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"phone"] = phone;
    WEAKSELF
    [[NetWorkTool shareInstacne]postWithURLString:User_Forget_Code parameters:param success:^(id  _Nonnull responseObject) {
        [SVProgressHUD dismiss];
        NSLog(@"获取验证码:%@",responseObject);
        ResponeModel *res = [ResponeModel mj_objectWithKeyValues:responseObject];
        if (res.code == 1) {
            weakSelf.currentPhone = phone;
            [SVProgressHUD showSuccessWithStatus:@"获取成功"];
            weakSelf.codeStr = res.data[@"verityCode"];
            NSLog(@"code_str:%@",weakSelf.codeStr);
            [sender startWithTime:59 title:@"获取验证码" countDownTitle:@"S" mainColor:MainThemeColor countColor:[UIColor clearColor]];
        }else{
            [SVProgressHUD showErrorWithStatus:res.message];
            return;
        }
    } failure:^(NSError * _Nonnull error) {
        [SVProgressHUD dismiss];
        [SVProgressHUD showErrorWithStatus:FailRequestTip];
        return;
    }];
}
/**
 完成
 @param sender 完成
 */
- (IBAction)actionCompleteBtn:(UIButton *)sender
{
    NSString *phone     = self.phone_tf.text;
    NSString *code      = self.code_tf.text;
    NSString *pwd       = self.pwd_tf.text;
    NSString *pwd_again = self.pwd_again_tf.text;
    if (phone.length == 0 || [phone isEqualToString:@""]) {
        [self showHint:@"手机号不能为空" yOffset:-200];
        return;
    }
    if (phone.length != 11) {
        [self showHint:@"手机号码有误" yOffset:-200];
        return;
    }
    if (![phone isEqualToString:self.currentPhone]) {
        [self showHint:@"手机号码和绑定手机号码不符" yOffset:-200];
        return;
    }
    if (code.length == 0 || [code isEqualToString:@""]) {
        [self showHint:@"验证码不能为空" yOffset:-200];
        return;
    }
    if (![code isEqualToString:self.codeStr]) {
        [self showHint:@"验证码有误" yOffset:-200];
        return;
    }
    if (pwd.length == 0 || [pwd isEqualToString:@""]) {
        [self showHint:@"密码不能为空" yOffset:-200];
        return;
    }
    if (pwd_again.length == 0 || [pwd_again isEqualToString:@""]) {
        [self showHint:@"请再次输入密码" yOffset:-200];
        return;
    }
    if (![pwd isEqualToString:pwd_again]) {
        [self showHint:@"两次密码不一致" yOffset:-200];
        return;
    }
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"phone"] = phone;
    param[@"password"] = pwd;
    [SVProgressHUD showWithStatus:@"正在注册"];
    [[NetWorkTool shareInstacne]postWithURLString:User_Forget_Url parameters:param success:^(id  _Nonnull responseObject) {
        [SVProgressHUD dismiss];
        NSLog(@"注册成功:data:%@",responseObject);
        ResponeModel *res = [ResponeModel mj_objectWithKeyValues:responseObject];
        if (res.code == 1) {
            [SVProgressHUD showSuccessWithStatus:@"修改成功"];
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            [SVProgressHUD showErrorWithStatus:res.message];
            return;
        }
    } failure:^(NSError * _Nonnull error) {
        [SVProgressHUD dismiss];
        [SVProgressHUD showErrorWithStatus:FailRequestTip];
        return;
    }];
}
/**
 eyeBtn
 @param sender eyeBtn
 */
- (IBAction)actionEyeBtn:(UIButton *)sender
{
    sender.selected = !sender.selected;
    if (sender.selected) {
        self.pwd_tf.secureTextEntry = NO;
        [self.eye_btn setImage:[UIImage imageNamed:@"eye_sel"] forState:UIControlStateNormal];
    }else{
        self.pwd_tf.secureTextEntry = YES;
        [self.eye_btn setImage:[UIImage imageNamed:@"eye_nor"] forState:UIControlStateNormal];
    }
}
/**
 eyeBtn2
 @param sender eyeBtn2
 */
- (IBAction)acitonEyeBtn2:(UIButton *)sender
{
    sender.selected = !sender.selected;
    if (sender.selected) {
        self.pwd_again_tf.secureTextEntry = NO;
        [self.eye_btn2 setImage:[UIImage imageNamed:@"eye_sel"] forState:UIControlStateNormal];
    }else{
        self.pwd_again_tf.secureTextEntry = YES;
        [self.eye_btn2 setImage:[UIImage imageNamed:@"eye_nor"] forState:UIControlStateNormal];
    }
}
@end
