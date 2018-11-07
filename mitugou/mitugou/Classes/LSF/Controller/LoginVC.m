//  LoginVC.m
//  aboluo
//  Created by zhufeng on 2018/11/3.
//  Copyright © 2018年 zhufeng. All rights reserved.
#import "LoginVC.h"
#import "ResigterVC.h"
#import "ForgetPwdVC.h"
#import "TabBarController.h"
#import "AppDelegate.h"
#import "BindVC.h"
@interface LoginVC ()
@property (weak, nonatomic) IBOutlet UITextField *phone_tf;
@property (weak, nonatomic) IBOutlet UITextField *pwd_tf;
@property (weak, nonatomic) IBOutlet UIButton *eye_btn;
@end
@implementation LoginVC
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}
-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}
/**
 眼睛改变颜色
 @param sender 眼睛改变颜色
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
 注册方法
 @param sender 注册方法
 */
- (IBAction)actionRegisterBtn:(UIButton *)sender
{
    ResigterVC *registervc = [[ResigterVC alloc]init];
    [self.navigationController pushViewController:registervc animated:YES];
}
/**
 登录方法
 @param sender 登录方法
 */
- (IBAction)actionLoginBtn:(UIButton *)sender
{
    [self.phone_tf resignFirstResponder];
    [self.pwd_tf resignFirstResponder];
    NSString *phone = self.phone_tf.text;
    NSString *pwd   = self.pwd_tf.text;
    if (phone.length == 0 || [phone isEqualToString:@""]) {
        [self showHint:@"手机号码不能为空" yOffset:-200];
        return;
    }
    if (phone.length != 11) {
        [self showHint:@"手机号码有误" yOffset:-200];
        return;
    }
    if (pwd.length == 0 || [pwd isEqualToString:@""]) {
        [self showHint:@"密码不能为空" yOffset:-200];
        return;
    }
    AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    app.window.backgroundColor = [UIColor whiteColor];
    TabBarController *tabbar = [[TabBarController alloc]init];
    app.window.backgroundColor = [UIColor whiteColor];
    app.window.rootViewController = tabbar;
    [app.window makeKeyAndVisible];
    //开始去登录
    //[self loginWithPhone:phone withPwd:pwd];
}

-(void)loginWithPhone:(NSString *)phone withPwd:(NSString *)pwd
{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"phone"] = phone;
    param[@"password"] = pwd;
    [[NetWorkTool shareInstacne]postWithURLString:User_Login_URL parameters:param success:^(id  _Nonnull responseObject) {
        NSLog(@"resoponseObject:%@",responseObject);
        
    } failure:^(NSError * _Nonnull error) {
        NSLog(@"error:%@",error);
    }];
}
/**
 用户忘记密码
 @param sender 用户忘记密码
 */
- (IBAction)actionForgetPwdBtn:(UIButton *)sender
{
    ForgetPwdVC *forgetpwdvc = [[ForgetPwdVC alloc]init];
    [self.navigationController pushViewController:forgetpwdvc animated:YES];
}
/**
 三方登录
 @param sender 三方登录
 */
- (IBAction)actionWeChatBtn:(UIButton *)sender
{
    int tag = (int)sender.tag;
    int platform;
    NSString *platformType = nil;
    if (tag == 0) {
        //微信登录
        platform = SSDKPlatformTypeWechat;
        platformType = @"wx";
    }else{
        //qq登录
        platform = SSDKPlatformTypeQQ;
        platformType = @"qq";
    }
     [self ThirdAuthorMethodWithPlatform:platform WithType:platformType];
}
/**
 三方登录的方法
 */
-(void)ThirdAuthorMethodWithPlatform:(int)platform WithType:(NSString *)platformType
{
    [SVProgressHUD showWithStatus:@"请求中"];
    [ShareSDK authorize:platform settings:nil onStateChanged:^(SSDKResponseState state, SSDKUser *user, NSError *error) {
        [SVProgressHUD dismiss];
        switch (state) {
            case SSDKResponseStateSuccess:
            {
                NSLog(@"授权成功");
                NSLog(@"userid:%@",user.uid);
                NSLog(@"usericon:%@",user.icon);
                NSLog(@"username:%@",user.nickname);
                BindVC *bindvc = [[BindVC alloc]init];
                [self.navigationController pushViewController:bindvc animated:YES];
            }
                break;
            case SSDKResponseStateFail:
            {
                NSLog(@"授权失败");
            }
                 break;
            case SSDKResponseStateCancel:
            {
                NSLog(@"授权取消了");
            }
                break;
            default:
                break;
        }
    }];
}
@end
