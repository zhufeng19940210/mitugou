//  AddressEditVC.m
//  mitugou
//  Created by zhufeng on 2018/11/8.
//  Copyright © 2018 zhufeng. All rights reserved.
#import "AddressEditVC.h"
#import "IQTextView.h"
@interface AddressEditVC ()
@property (weak, nonatomic) IBOutlet UITextField *name_tf;
@property (weak, nonatomic) IBOutlet UITextField *phone_lab;
@property (weak, nonatomic) IBOutlet IQTextView *address_lab;
@property (weak, nonatomic) IBOutlet UIButton *default_btn;
@property (nonatomic,assign)NSInteger default_type; //默认地址
@end
@implementation AddressEditVC

- (void)viewDidLoad {
    [super viewDidLoad];
    if (self.isEdit) {
        //是编辑
        self.navigationItem.title = @"编辑地址";
        self.name_tf.text     =  self.addressmodel.receName;
        self.phone_lab.text   =  self.addressmodel.phone;
        self.address_lab.text =  self.addressmodel.detailAddr;
        if (self.addressmodel.isDefault  == 1) {
            //是默认地址
            [self.default_btn setImage:[UIImage imageNamed:@"address_select"] forState:UIControlStateNormal];
        }else{
            //不是默认地址
            [self.default_btn setImage:[UIImage imageNamed:@"address_normal"] forState:UIControlStateNormal];
        }
    }else{
      //添加地址
        self.navigationItem.title = @"添加地址";
        self.address_lab.placeholder = @"请输入详细地址信息,如道路、门牌号、小区、楼栋号、单元等";
        self.address_lab.font = [UIFont systemFontOfSize:15];
        //默认不是
        self.default_type = 0;
    }
}
/**
 保存用户
 @param sender 保存用户
 */
- (IBAction)actionSaveBtn:(UIButton *)sender
{
    NSString *name   = self.name_tf.text;
    NSString *phone  = self.phone_lab.text;
    NSString *addres = self.address_lab.text;
    if (name.length == 0 || [name isEqualToString:@""]) {
        [self showHint:@"姓名不能为空" yOffset:-200];
        return;
    }
    if (phone.length == 0 || [phone isEqualToString:@""]) {
        [self showHint:@"手机号码不能为空" yOffset:-200];
        return;
    }
    if (phone.length != 11) {
        [self showHint:@"手机号码有误" yOffset:-200];
        return;
    }
    if (addres.length == 0 || [addres isEqualToString:@""]) {
        [self showHint:@"详细地址不能为空" yOffset:-200];
        return;
    }
    [SVProgressHUD show];
    NSString *token = [[NSUserDefaults standardUserDefaults]valueForKey:ZF_TOKEN];
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"token"] = token;
    param[@"receName"] = name;
    param[@"phone"] = phone;
    param[@"detailAddr"] = addres;
    param[@"isDefault"] = [NSString stringWithFormat:@"%ld",(long)self.default_type];
    [[NetWorkTool shareInstacne]postWithURLString:Userinfo_Address_Add parameters:param success:^(id  _Nonnull responseObject) {
        [SVProgressHUD dismiss];
        ResponeModel *res = [ResponeModel mj_objectWithKeyValues:responseObject];
        if (res.code==1) {
            if (self.isEdit) {
                ///编辑成功
                [[NSNotificationCenter defaultCenter]postNotificationName:UPDATESUCCESS object:nil];
                [SVProgressHUD showSuccessWithStatus:@"修改成功"];
                [self.navigationController popViewControllerAnimated:YES];
            }else{
                ///添加成功
                [[NSNotificationCenter defaultCenter]postNotificationName:UPDATESUCCESS object:nil];
                [SVProgressHUD showSuccessWithStatus:@"添加成功"];
                [self.navigationController popViewControllerAnimated:YES];
            }
        }else{
            if (self.isEdit) {
                [SVProgressHUD showErrorWithStatus:@"修改失败"];
                return;
            }else{
                [SVProgressHUD showErrorWithStatus:@"添加失败"];
                return;
            }
        }
    } failure:^(NSError * _Nonnull error) {
        [SVProgressHUD dismiss];
        [SVProgressHUD showErrorWithStatus:FailRequestTip];
        return;
    }];
}
/**
 设置默认地址
 @param sender 设置默认地址
 */
- (IBAction)actionDefaultBtn:(UIButton *)sender
{
    sender.selected = !sender.selected;
    if (sender.selected) {
        self.default_type = 1;
        [self.default_btn setImage:[UIImage imageNamed:@"address_select"] forState:UIControlStateNormal];
    }else{
        self.default_type = 0;
        [self.default_btn setImage:[UIImage imageNamed:@"address_normal"] forState:UIControlStateNormal];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
@end
