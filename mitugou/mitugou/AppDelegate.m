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
@interface AppDelegate ()
@end
@implementation AppDelegate
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [self seutpThirdInitlation];
    self.window  = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    UIViewController *rootViewController = nil;
    BOOL isFirst = [[NSUserDefaults standardUserDefaults]boolForKey:ISFirst
                    ];
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
