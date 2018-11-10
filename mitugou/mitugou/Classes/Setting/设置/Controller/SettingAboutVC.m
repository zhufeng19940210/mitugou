//  SettingAboutVC.m
//  mitugou
//  Created by zhufeng on 2018/11/8.
//  Copyright © 2018 zhufeng. All rights reserved.
#import "SettingAboutVC.h"
@interface SettingAboutVC ()
@property (weak, nonatomic) IBOutlet UILabel *version_lab;
@end
@implementation SettingAboutVC
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"关于我们";
    // app build版本
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *app_build = [infoDictionary objectForKey:@"CFBundleVersion"];
    self.version_lab.text = [NSString stringWithFormat:@"当前版本:%@",app_build];
}
@end
