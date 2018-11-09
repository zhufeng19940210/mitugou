//  SettingUserinfoVC.m
//  mitugou
//  Created by zhufeng on 2018/11/8.
//  Copyright © 2018 zhufeng. All rights reserved.
#import "SettingUserinfoVC.h"
#import "SettingUserinfoCell.h"
#import "SettingLogoutCell.h"
#import "SettingProblemVC.h"
#import "SettingAboutVC.h"
#import "UpdatePwdVC.h"
#import "AppDelegate.h"
#import "LoginVC.h"
@interface SettingUserinfoVC ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (nonatomic,strong) NSMutableArray *titleArray;
@end

@implementation SettingUserinfoVC
-(NSMutableArray *)titleArray
{
    if (!_titleArray) {
        _titleArray = [NSMutableArray arrayWithObjects:@"常见问题",@"关于我们",@"清理缓存",@"修改登录密码",nil];
    }
    return _titleArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"设置";
    [self setupTableView];
}
-(void)setupTableView
{
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    self.tableview.backgroundColor = [UIColor clearColor];
    [self.tableview registerNib:[UINib nibWithNibName:@"SettingUserinfoCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"SettingUserinfoCell"];
    [self.tableview registerNib:[UINib nibWithNibName:@"SettingLogoutCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"SettingLogoutCell"];
}
#pragma mark uitableviewdelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.titleArray.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{   UITableViewCell *settingCell = nil;
    SettingUserinfoCell *userinfoCell = [tableView dequeueReusableCellWithIdentifier:@"SettingUserinfoCell"];
    userinfoCell.title_lab.text = self.titleArray[indexPath.row];
    settingCell = userinfoCell;
    settingCell.selectionStyle = UITableViewCellSelectionStyleNone;
    return settingCell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
        if (indexPath.row == 0 ) {
            //常见问题
            SettingProblemVC *problevc = [[SettingProblemVC alloc]init];
            [self.navigationController pushViewController:problevc animated:YES];
        }else if (indexPath.row == 1){
            //关于我们
            SettingAboutVC *aboutvc = [[SettingAboutVC alloc]init];
            [self.navigationController pushViewController:aboutvc animated:YES];
        }else if(indexPath.row == 2){
            //清理缓存
        }else if(indexPath.row == 3){
            //修改登录密码
            UpdatePwdVC *updatevc = [[UpdatePwdVC alloc]init];
            [self.navigationController pushViewController:updatevc animated:YES];
        }
    }
}
/**
  退出登录
 */
-(void)logoutMethod
{
    //情况数据
    [UserModel logout];
    LoginVC *loginVC = [[LoginVC alloc]init];
    AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:loginVC];
    app.window.backgroundColor = [UIColor whiteColor];
    app.window.rootViewController = nav;
    [app.window makeKeyAndVisible];
    [SVProgressHUD showSuccessWithStatus:@"退出成功"];
}
/**
 退出登录
 @param sender 退出登录
 */
- (IBAction)actionLogoutBtn:(UIButton *)sender {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"您确定退出登录吗?" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        [self logoutMethod];
    }];
    [alertController addAction:cancelAction];
    [alertController addAction:okAction];
    [self presentViewController:alertController animated:YES completion:nil];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
@end
