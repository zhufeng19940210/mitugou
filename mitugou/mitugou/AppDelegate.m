//  AppDelegate.m
//  mitugou
//  Created by zhufeng on 2018/11/3.
//  Copyright © 2018年 zhufeng. All rights reserved.
#import "AppDelegate.h"
#import "LoginVC.h"
#import "ResigterVC.h"
#import "TabBarController.h"
#import "MyNavigationController.h"
#import "GuiideVC.h"
@interface AppDelegate ()
@end
@implementation AppDelegate
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [self seutpThirdInitlation];
    self.window  = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    UIViewController *rootViewController = nil;
    BOOL isFirst = [[NSUserDefaults standardUserDefaults]boolForKey:@"isFirst"];
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
        LoginVC *loginVC = [[LoginVC alloc]init];
        MyNavigationController *nav = [[MyNavigationController alloc]initWithRootViewController:loginVC];
        rootViewController = nav;
    }
    self.window.rootViewController = rootViewController;
    [self.window makeKeyAndVisible];
    return YES;
}

//三方初始化
-(void)seutpThirdInitlation
{
    ///三方登录的东西
    [ShareSDK registPlatforms:^(SSDKRegister *platformsRegister) {
        [platformsRegister setupQQWithAppId:MOBSSDKQQAppID appkey:MOBSSDKQQAppKey];
        [platformsRegister setupWeChatWithAppId:MOBSSDKWeChatAppID appSecret:MOBSSDKWeChatAppSecret];
        [platformsRegister setupSinaWeiboWithAppkey:MOBSSDKSinaWeiBoAppKey appSecret:MOBSSDKWeChatAppSecret redirectUrl:MOBSSDKSinaWeiBoDirecUrl];
    }];
}
- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
