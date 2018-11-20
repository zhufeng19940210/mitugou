//  PersonVC.m
//  mitugou
//  Created by zhufeng on 2018/11/10.
//  Copyright © 2018 zhufeng. All rights reserved.
#import "PersonVC.h"
#import "LZPickerView.h"
@interface PersonVC ()
@property (weak, nonatomic) IBOutlet UITextField *address_tf;
@property (weak, nonatomic) IBOutlet UITextField *xueli_tf;
@property (weak, nonatomic) IBOutlet UITextField *marrige_tf;
@property (nonatomic,strong)LZPickerView *lzPickerVIew; ///选择的图片
@end
@implementation PersonVC
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"个人信息";
    NSArray *views = [[NSBundle mainBundle] loadNibNamed:@"LZPickerView" owner:nil options:nil];
    self.lzPickerVIew  = views[0];
    //获取数据
    [self setupData];
}
-(void)setupData
{
    [SVProgressHUD show];
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    NSString *token = [[NSUserDefaults standardUserDefaults]valueForKey:ZF_TOKEN];
    param[@"token"] = token;
    [[NetWorkTool shareInstacne]postWithURLString:Userinfo_Sigle_Url_Find parameters:param success:^(id  _Nonnull responseObject) {
        NSLog(@"responseObject:%@",responseObject);
        [SVProgressHUD dismiss];
        ResponeModel *res = [ResponeModel mj_objectWithKeyValues:responseObject];
        if (res.code ==1) {
                [SVProgressHUD showSuccessWithStatus:@"获取成功"];
                NSDictionary *infodata = res.data[@"infodata"];
                NSString *address   = infodata[@"address"];
                NSString *education = infodata[@"education"];
                NSString *marriage  = infodata[@"marriage"];
                self.address_tf.text = address;
                self.xueli_tf.text   = education;
                self.marrige_tf.text = marriage;
        }
        else if (res.code == 2) {
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
 学历btn
 @param sender 学历btn
 */
- (IBAction)actionXueliBtn:(UIButton *)sender
{
    WEAKSELF
    [self.lzPickerVIew lzPickerVIewType:LZPickerViewTypeSexAndHeight];
    self.lzPickerVIew.dataSource =@[@"初中",@"高中",@"大专",@"本科",@"研究生",@"硕士",@"博士",];
    self.lzPickerVIew.titleText = @"请选择学历";
    self.lzPickerVIew.selectDefault = @"初中";
    self.lzPickerVIew.selectValue  = ^(NSString *value){
        weakSelf.xueli_tf.text = value;
    };
    [self.lzPickerVIew show];
}
/**
 婚姻btn
 @param sender 婚姻btn
 */
- (IBAction)actionMarigeBtn:(UIButton *)sender
{
    WEAKSELF
    [self.lzPickerVIew lzPickerVIewType:LZPickerViewTypeSexAndHeight];
    self.lzPickerVIew.dataSource =@[@"未婚",@"已婚"];
    self.lzPickerVIew.titleText = @"请选择婚姻状况";
    self.lzPickerVIew.selectDefault = @"未婚";
    self.lzPickerVIew.selectValue  = ^(NSString *value){
        weakSelf.marrige_tf.text = value;
    };
    [self.lzPickerVIew show];
}
/**
 保存btn
 @param sender 保存btn
 */
- (IBAction)actionSaveBtn:(UIButton *)sender
{   NSString *address = self.address_tf.text;
    NSString *xueli   = self.xueli_tf.text;
    NSString *marrige = self.marrige_tf.text;
    if (address.length == 0 || [address isEqualToString:@""]) {
        [self showHint:@"地址不能为空" yOffset:-200];
        return;
    }
    if (xueli.length == 0 || [xueli isEqualToString:@""]) {
        [self showHint:@"学历不能为空" yOffset:-200];
        return;
    }
    if (marrige.length == 0 || [marrige isEqualToString:@""]) {
        [self showHint:@"婚姻状况不能为空" yOffset:-200];
        return;
    }
    //开始去上传
    [SVProgressHUD show];
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    NSString *token = [[NSUserDefaults standardUserDefaults]valueForKey:ZF_TOKEN];
    param[@"token"]     = token;
    param[@"address"]   = address;
    param[@"education"] = xueli;
    param[@"marriage"]  = marrige;
    [[NetWorkTool shareInstacne]postWithURLString:Userinfo_Sigle_Url_Update parameters:param success:^(id  _Nonnull responseObject) {
        [SVProgressHUD dismiss];
        NSLog(@"responseObject:%@",responseObject);
        ResponeModel *res = [ResponeModel mj_objectWithKeyValues:responseObject];
        if (res.code == 1) {
            [SVProgressHUD showSuccessWithStatus:@"上传成功"];
            [self.navigationController popViewControllerAnimated:YES];
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

@end

