//  AppDelegate.m
//  mitugou
//  Created by zhufeng on 2018/11/3.
//  Copyright © 2018年 zhufeng. All rights reserved.
#import "AppDelegate.h"
#import "LoginVC.h"
#import "ResigterVC.h"
#import "TabBarController.h"
#import "MyNavigationController.h"
#import "GuideVC.h"
#import "WXApi.h"
#import <AlipaySDK/AlipaySDK.h>
@interface AppDelegate ()<WXApiDelegate>
@end
@implementation AppDelegate
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [self seutpThirdInitlation];
    self.window  = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    UIViewController *rootViewController = nil;
    BOOL isFirst = [[NSUserDefaults standardUserDefaults]boolForKey:ISFirst];
    if (isFirst) {
        if ([UserModel isOnline]) {
            //登录成功
            TabBarController *tabbarvc = [[TabBarController alloc]init];
            rootViewController = tabbarvc;
        }else{
            //没有登录
            LoginVC *loginVC = [[LoginVC alloc]init];
            MyNavigationController *nav = [[MyNavigationController alloc]initWithRootViewController:loginVC];
            rootViewController = nav;
        }
    }else{
        //引导页
        GuideVC *guidevc = [[GuideVC alloc]init];
        MyNavigationController *nav = [[MyNavigationController alloc]initWithRootViewController:guidevc];
        rootViewController = nav;
    }
    self.window.rootViewController = rootViewController;
    [self.window makeKeyAndVisible];
    return YES;
}
//三方初始化
-(void)seutpThirdInitlation
{
    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = YES;
    //这里设置下样式
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleCustom];
    //设置背景颜色
    [SVProgressHUD setBackgroundColor:[UIColor blackColor]];
    //设置前景色
    [SVProgressHUD setForegroundColor:[UIColor whiteColor]];
    //遮罩的颜色
    //[SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeCustom];
    //设置遮罩的颜色
    //[SVProgressHUD setBackgroundLayerColor:[UIColor yellowColor]];
    //动画的样式(菊花)|默认是圆圈
    //[SVProgressHUD setDefaultAnimationType:SVProgressHUDAnimationTypeNative];
    //显示时间
    [SVProgressHUD setMinimumDismissTimeInterval:1.0];//显示的时间
    ///三方登录的东西
    [ShareSDK registPlatforms:^(SSDKRegister *platformsRegister) {
        [platformsRegister setupQQWithAppId:MOBSSDKQQAppID appkey:MOBSSDKQQAppKey];
        [platformsRegister setupWeChatWithAppId:MOBSSDKWeChatAppID appSecret:MOBSSDKWeChatAppSecret];
        [platformsRegister setupSinaWeiboWithAppkey:MOBSSDKSinaWeiBoAppKey appSecret:MOBSSDKWeChatAppSecret redirectUrl:MOBSSDKSinaWeiBoDirecUrl];
    }];
    //立木征信的东西
    //1.注册立木征信的东西
    [LMZXSDK registerLMZXSDK];
    //2.开启日志的打印
    //[[LMZXSDK shared] unlockLog];
}

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString *,id> *)options
{
    /*! @brief 处理微信通过URL启动App时传递的数据
     *
     * 需要在 application:openURL:sourceApplication:annotation:或者application:handleOpenURL中调用。
     * @param url 微信启动第三方应用时传递过来的URL
     * @param delegate  WXApiDelegate对象，用来接收微信触发的消息。
     * @return 成功返回YES，失败返回NO。
     */
    
    if ([url.host isEqualToString:@"safepay"]) {
        //跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            
            NSLog(@"result = %@",resultDic);
            
            if ([resultDic[@"resultStatus"] isEqualToString:@"9000"]) {
                if (self.PayDelegate&&[self.PayDelegate respondsToSelector:@selector(AppPayResultSuccess:)]) {
                    [self.PayDelegate AppPayResultSuccess:YES];
                }
            }else{
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:resultDic[@"memo"] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil ];
                [alert show];
            }
        }];
        return YES;
    }else{
        return [WXApi handleOpenURL:url delegate:self];
        
    }
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    
    if ([url.host isEqualToString:@"safepay"]) {
        //跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"result = %@",resultDic);
            if ([resultDic[@"resultStatus"] isEqualToString:@"9000"]) {
                if (self.PayDelegate &&[self.PayDelegate respondsToSelector:@selector(AppPayResultSuccess:)]) {
                    [self.PayDelegate AppPayResultSuccess:YES];
                    
                }
            }else{
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:resultDic[@"memo"] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil ];
                [alert show];
            }
        }];
        
        return YES;
    }else{
        return [WXApi handleOpenURL:url delegate:self];
    }
}
#pragma mark -- WXApiDelegate
- (void)onResp:(BaseResp *)resp
{
    //支付返回结果，实际支付结果需要去微信服务器端查询
    NSString *strMsg = [NSString stringWithFormat:@"支付结果"];
    switch (resp.errCode) {
        case WXSuccess:
        {
            
            strMsg = @"支付结果：成功！";
            NSLog(@"支付成功－PaySuccess，retcode = %d", resp.errCode);
            
            if (self.PayDelegate &&[self.PayDelegate respondsToSelector:@selector(AppPayResultSuccess:)]) {
                [self.PayDelegate AppPayResultSuccess:YES];
            }
        }
            break;
        default:
            strMsg = [NSString stringWithFormat:@"支付结果：失败！retcode = %d, retstr = %@", resp.errCode,resp.errStr];
            NSLog(@"错误，retcode = %d, retstr = %@", resp.errCode,resp.errStr);
            UIAlertView *alet = [[UIAlertView alloc]initWithTitle:@"支付失败！" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alet show];
            break;
    }
}

- (void)applicationWillResignActive:(UIApplication *)application {

}
- (void)applicationDidEnterBackground:(UIApplication *)application {

}
- (void)applicationWillEnterForeground:(UIApplication *)application {
  
}
- (void)applicationDidBecomeActive:(UIApplication *)application {
  
}
- (void)applicationWillTerminate:(UIApplication *)application {
    
}
@end
