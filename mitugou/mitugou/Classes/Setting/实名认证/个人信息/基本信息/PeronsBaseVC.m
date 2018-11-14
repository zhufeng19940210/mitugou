//  PeronsBaseVC.m
//  mitugou
//  Created by zhufeng on 2018/11/10.
//  Copyright © 2018 zhufeng. All rights reserved.
#import "PeronsBaseVC.h"
#import "LZPickerView.h"
@interface PeronsBaseVC ()
@property (weak, nonatomic) IBOutlet UITextField *name_tf;
@property (weak, nonatomic) IBOutlet UITextField *sex_tf;
@property (weak, nonatomic) IBOutlet UITextField *card_tf;
@property (nonatomic,strong)LZPickerView *lzPickerVIew; ///选择的图片
@end
@implementation PeronsBaseVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"基本信息";
    NSArray *views = [[NSBundle mainBundle] loadNibNamed:@"LZPickerView" owner:nil options:nil];
    self.lzPickerVIew  = views[0];
    [self setupData];
}
-(void)setupData
{
    [SVProgressHUD show];
    NSString *token = [[NSUserDefaults standardUserDefaults]valueForKey:ZF_TOKEN];
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"token"] = token;
    [[NetWorkTool shareInstacne]postWithURLString:Userinfo_Base_Url_Find parameters:param success:^(id  _Nonnull responseObject) {
        [SVProgressHUD dismiss];
        NSLog(@"responseObject:%@",responseObject);
        ResponeModel *res = [ResponeModel mj_objectWithKeyValues:responseObject];
        if ([res.code isEqualToString:@"1"]) {
            [SVProgressHUD showSuccessWithStatus:@"获取成功"];
            NSDictionary *infodata = res.data[@"infodata"];
            self.name_tf.text =  infodata[@"username"];
            self.sex_tf.text  =  infodata[@"sex"];
            self.card_tf.text =  infodata[@"idcard"];
        }
        if ([res.code isEqualToString:@"2"]) {
            [SVProgressHUD showSuccessWithStatus:@"暂无数据"];
            return;
        }
        else{
            [SVProgressHUD showErrorWithStatus:@"获取失败"];
            return;
        }
    } failure:^(NSError * _Nonnull error) {
        [SVProgressHUD dismiss];
        [SVProgressHUD showErrorWithStatus:FailRequestTip];
        return;
    }];
}
/**
 保存数据
 @param sender 保存数据
 */
- (IBAction)actionSaveBtn:(UIButton *)sender
{
    NSString *name = self.name_tf.text;
    NSString *sex  = self.sex_tf.text;
    NSString *card = self.card_tf.text;
    if (name.length == 0 || [name isEqualToString:@""]) {
        [self showHint:@"姓名不能为空" yOffset:-200];
        return;
    }
    if (sex.length == 0 || [sex isEqualToString:@""]) {
        [self showHint:@"性别不能为空" yOffset:-200];
        return;
    }
    if (card.length == 0 || [card isEqualToString:@""]) {
        [self showHint:@"身份证号码不能为空" yOffset:-200];
        return;
    }
//    if (![LCUtil isValidIDNumber:card]) {
//        [self showHint:@"身份证号码有误" yOffset:-200];
//        return;
//    }
    //开始去发送请求
    [SVProgressHUD show];
    NSString *token = [[NSUserDefaults standardUserDefaults]valueForKey:ZF_TOKEN];
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"token"] = token;
    param[@"username"] = name;
    param[@"sex"] = sex;
    param[@"idcard"] = card;
    [[NetWorkTool shareInstacne]postWithURLString:Userinfo_Base_Url_update parameters:param success:^(id  _Nonnull responseObject) {
        [SVProgressHUD dismiss];
        ResponeModel *res = [ResponeModel mj_objectWithKeyValues:responseObject];
        if ([res.code isEqualToString:@"1"]) {
            [SVProgressHUD showSuccessWithStatus:@"上传成功"];
            [self.navigationController popViewControllerAnimated:YES];
        }else if ([res.code isEqualToString:@"0"]){
            [SVProgressHUD showErrorWithStatus:@"token失败"];
            return;
        }else{
            [SVProgressHUD showErrorWithStatus:@"上传失败"];
            return;
        }
    } failure:^(NSError * _Nonnull error) {
        [SVProgressHUD dismiss];
        [SVProgressHUD showErrorWithStatus:FailRequestTip];
        return;
    }];
}
/**
 选择性别
 @param sender 选择性别
 */
- (IBAction)actionSelectSexBtn:(UIButton *)sender
{
    WEAKSELF
    [self.lzPickerVIew lzPickerVIewType:LZPickerViewTypeSexAndHeight];
    self.lzPickerVIew.dataSource =@[@"男",@"女"];
    self.lzPickerVIew.titleText = @"请选择性别";
    self.lzPickerVIew.selectDefault = @"男";
    self.lzPickerVIew.selectValue  = ^(NSString *value){
        weakSelf.sex_tf.text = value;
    };
    [self.lzPickerVIew show];
}
@end
