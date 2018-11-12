//  ResigterVC.m
//  aboluo
//  Created by zhufeng on 2018/11/3.
//  Copyright © 2018年 zhufeng. All rights reserved.
#import "ResigterVC.h"
#import "AgreeVC.h"
#import "UIButton+countDown.h"
@interface ResigterVC ()
@property (weak, nonatomic) IBOutlet UITextField *phoe_tf;
@property (weak, nonatomic) IBOutlet UITextField *code_tf;
@property (weak, nonatomic) IBOutlet UITextField *pwd_tf;
@property (weak, nonatomic) IBOutlet UIButton *agree_btn;
@property (weak, nonatomic) IBOutlet UIButton *eye_btn;
@property (nonatomic,assign)BOOL isAgree;
@property (nonatomic,copy)NSString *code_str; //获取验证码code_str
@end
@implementation ResigterVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"注册";
    self.isAgree = NO;
}
/**
 显示眼睛出来
 @param sender 显示眼睛出来
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
 注册的方法
 @param sender 注册的方法
 */
- (IBAction)actionResigsterBtn:(UIButton *)sender
{
    NSString *phone = self.phoe_tf.text;
    NSString *code  = self.code_tf.text;
    NSString *pwd   = self.pwd_tf.text;
    if ([phone isEqualToString:@""] || phone.length == 0) {
        [self showHint:@"手机号码不能为空" yOffset:-200];
        return;
    }
    if (![LCUtil isMobileNumber:phone]) {
        [self showHint:@"手机号码有误" yOffset:-200];
        return;
    }
    if ([code isEqualToString:@""] || code.length == 0) {
        [self showHint:@"验证码不能为空" yOffset:-200];
        return;
    }
    if ([pwd isEqualToString:@""] || pwd.length == 0) {
        [self showHint:@"密码不能为空" yOffset:-200];
        return;
    }
    if (!self.isAgree) {
        [self showHint:@"请先同意协议" yOffset:-200];
        return;
    }
    //开始去注册用户
    [self RegisterWithPhone:phone WithCode:code WithPwd:pwd];
}
-(void)RegisterWithPhone:(NSString *)phone WithCode:(NSString *)code WithPwd:(NSString *)pwd
{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"phone"] = phone;
    param[@"password"] = pwd;
    param[@"verifyCode"] = code;
    [SVProgressHUD showWithStatus:@"正在注册"];
    [[NetWorkTool shareInstacne]postWithURLString:User_Register_URL parameters:param success:^(id  _Nonnull responseObject) {
        [SVProgressHUD dismiss];
        NSLog(@"注册成功:data:%@",responseObject);
    } failure:^(NSError * _Nonnull error) {
        [SVProgressHUD dismiss];
        [ZFCustomView showWithError:FailRequestTip];
        return;
    }];
}
/**
 获取验证码
 @param sender 获取验证码
 */
- (IBAction)actionCodeBtn:(UIButton *)sender
{
    NSString *phone = self.phoe_tf.text;
    if (phone.length == 0 || [phone isEqualToString:@""])
    {
        [self showHint:@"手机号码不能为空" yOffset:-200];
        return;
    }
    if (phone.length != 11) {
        [self showHint:@"手机号码有误" yOffset:-200];
        return;
    }
    [SVProgressHUD showWithStatus:@"获取验证码中"];
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"phone"] = phone;
    [[NetWorkTool shareInstacne]postWithURLString:User_Get_Code parameters:param success:^(id  _Nonnull responseObject) {
        [SVProgressHUD dismiss];
        NSLog(@"获取验证码:%@",responseObject);
        ResponeModel *res = [ResponeModel mj_objectWithKeyValues:responseObject];
        if ([res.code isEqualToString:@"1"]) {
            [ZFCustomView showWithSuccess:@"获取成功"];
            self.code_str = res.data[@"msg"];
            NSLog(@"code_str:%@",self.code_str);
            [sender startWithTime:59 title:@"获取验证码" countDownTitle:@"S" mainColor:MainThemeColor countColor:[UIColor clearColor]];
        }else{
            [ZFCustomView showWithError:@"获取失败"];
            return;
        }
    } failure:^(NSError * _Nonnull error) {
        [SVProgressHUD dismiss];
        [SVProgressHUD showErrorWithStatus:FailRequestTip];
        return;
    }];

}
/**
 同意按钮
 @param sender 同意按钮
 */
- (IBAction)actionAgreeBtn:(UIButton *)sender
{
    sender.selected = !sender.selected;
    if (sender.selected) {
        [self.agree_btn setImage:[UIImage imageNamed:@"aregree_sel"] forState:UIControlStateNormal];
        self.isAgree = YES;
    }else{
        [self.agree_btn setImage:[UIImage imageNamed:@"aregree_nor"] forState:UIControlStateNormal];
        self.isAgree = NO;
    }
}
/**
 协议详情按钮
 @param sender 协议详情按钮
 */
- (IBAction)actionDetailBtn:(UIButton *)sender
{
    AgreeVC *agreevc =  [[AgreeVC alloc]init];
    [self.navigationController pushViewController:agreevc animated:YES];
}

@end
