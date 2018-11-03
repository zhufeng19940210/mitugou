//  TabBarController.m
//  mitugou
//  Created by zhufeng on 2018/11/3.
//  Copyright © 2018年 zhufeng. All rights reserved.

#import "TabBarController.h"
#import "HomeVC.h"
#import "ApplicationVC.h"
#import "SettingVC.h"
#import "MyNavigationController.h"
@implementation TabBarController

+(void)initialize{
    [super initialize];
    NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
    attrs[NSFontAttributeName] = [UIFont systemFontOfSize:12];
    attrs[NSForegroundColorAttributeName] = [UIColor colorWithRed:(122.0f/255.0f) green:(126.0f/255.0) blue:(131.0f/255.0f) alpha:1  ];
    
    NSMutableDictionary *selectAttrs = [NSMutableDictionary dictionary];
    selectAttrs[NSFontAttributeName] = [UIFont systemFontOfSize:12];
    selectAttrs[NSForegroundColorAttributeName] =  [  UIColor colorWithRed:(133.0f/255.0f) green:(160.0f/255.0f) blue:(38.0/255.0f) alpha:1];
    UITabBarItem *item = [UITabBarItem appearance];
    [item setTitleTextAttributes:attrs forState:UIControlStateNormal];
    [item setTitleTextAttributes:selectAttrs forState:UIControlStateSelected];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // 初始化子控制器
    [self setupAllControllers];
}

#pragma mark - 初始化界面的方法
/**
 *  初始化所有子控制器
 */
- (void)setupAllControllers
{
    //首页
    HomeVC *homevc = [[HomeVC alloc]init];
    [self setupChildViewVC:homevc title:@"首页" norImage:@"home_home" selectImage:@"home_xz_home"];
    //订单
    ApplicationVC *applicationvc = [[ApplicationVC alloc]init];
    [self setupChildViewVC:applicationvc title:@"订单" norImage:@"" selectImage:@""];
    //我的
    SettingVC  *settingvc = [[SettingVC alloc]init];
    [self setupChildViewVC:settingvc title:@"设置" norImage:@"home_my" selectImage:@"home_xz_my"];
}
/**
 *  初始化一个子控制的方法
 */
- (void)setupChildViewVC:(UIViewController *)childVC title:(NSString *)title norImage:(NSString *)norName selectImage:(NSString *)selectImage
{   // 标题
    childVC.title = title;
    UIImage *norImage = [UIImage imageNamed:norName];
    // 普通状态下得图片
    childVC.tabBarItem.image = [norImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    childVC.tabBarItem.imageInsets = UIEdgeInsetsMake(6, 0, -6, 0);
    // 设置选中状态下得图片
    UIImage *selectedImage = [UIImage imageNamed:selectImage];
    selectedImage = [selectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    childVC.tabBarItem.selectedImage = selectedImage;
    // 添加导航控制器
    MyNavigationController *nav = [[MyNavigationController alloc]initWithRootViewController:childVC];
    // 添加tarBarController的子控制器
    [self addChildViewController:nav];
}
@end
