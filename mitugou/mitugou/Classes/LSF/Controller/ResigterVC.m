//  ResigterVC.m
//  aboluo
//  Created by zhufeng on 2018/11/3.
//  Copyright © 2018年 zhufeng. All rights reserved.
#import "ResigterVC.h"
#import "AgreeVC.h"
@interface ResigterVC ()
@property (weak, nonatomic) IBOutlet UITextField *phoe_tf;
@property (weak, nonatomic) IBOutlet UITextField *code_tf;
@property (weak, nonatomic) IBOutlet UITextField *pwd_tf;
@property (weak, nonatomic) IBOutlet UIButton *agree_btn;
@property (weak, nonatomic) IBOutlet UIButton *eye_btn;

@property (nonatomic,assign)BOOL isAgree;
@end
@implementation ResigterVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"注册";
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
    //开始去注册用户
    [self RegisterWithPhone:phone WithCode:code WithPwd:pwd];
}
-(void)RegisterWithPhone:(NSString *)phone WithCode:(NSString *)code WithPwd:(NSString *)pwd
{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"phone"] = phone;
    param[@"password"] = pwd;
    [[NetWorkTool shareInstacne]postWithURLString:User_Register_URL parameters:param success:^(id  _Nonnull responseObject) {
        NSLog(@"responseObject:%@",responseObject);
    } failure:^(NSError * _Nonnull error) {
        NSLog(@"error:%@",error);
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
    if (![LCUtil isMobileNumber:phone]) {
        [self showHint:@"手机号码有误" yOffset:-200];
        return;
    }
    //获取验证码
    [self getCodeWithPhone:phone];
}
-(void)getCodeWithPhone:(NSString *)phone
{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [[NetWorkTool shareInstacne]postWithURLString:User_Get_Code parameters:param success:^(id  _Nonnull responseObject) {
        NSLog(@"responseobject:%@",responseObject);
    } failure:^(NSError * _Nonnull error) {
        NSLog(@"error:%@",error);
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
