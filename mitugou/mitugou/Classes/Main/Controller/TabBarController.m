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
    [self setupChildViewVC:homevc title:@"" norImage:@"tab-home_nor" selectImage:@"tab-home_sel"];
    //申请
    ApplicationVC *applicationvc = [[ApplicationVC alloc]init];
    [self setupChildViewVC:applicationvc title:@"" norImage:@"tab-application_nor" selectImage:@"tab-application_sel"];
    //我的
    SettingVC  *settingvc = [[SettingVC alloc]init];
    [self setupChildViewVC:settingvc title:@"" norImage:@"tab-setting_nor" selectImage:@"tab-setting_sel"];
}
/**
 *  初始化一个子控制的方法
 */
- (void)setupChildViewVC:(UIViewController *)childVC title:(NSString *)title norImage:(NSString *)norName selectImage:(NSString *)selectImage
{   // 标题
    //childVC.title = title;
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
