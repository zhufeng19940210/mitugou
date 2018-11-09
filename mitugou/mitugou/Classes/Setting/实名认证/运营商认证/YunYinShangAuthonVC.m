//  YunYinShangAuthonVC.m
//  mitugou
//  Created by zhufeng on 2018/11/8.
//  Copyright © 2018 zhufeng. All rights reserved.
#import "YunYinShangAuthonVC.h"

@interface YunYinShangAuthonVC ()
@property (weak, nonatomic) IBOutlet UITextField *phone_tf;
@property (weak, nonatomic) IBOutlet UITextField *serverpwd_tf;
@property (weak, nonatomic) IBOutlet UITextField *card_tf;
@property (weak, nonatomic) IBOutlet UITextField *name_lab;
@property (weak, nonatomic) IBOutlet UIButton *agree_btn;
@property (weak, nonatomic) IBOutlet UIButton *save_btn;
@property (nonatomic,assign)BOOL isAgree; //是否是同意按钮
@end
@implementation YunYinShangAuthonVC
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"运营商认证";
}
/**
 忘记密码
 @param sender 忘记密码
 */
- (IBAction)actionForgePwdBtn:(UIButton *)sender
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"您可以拨打人工服务查询对应的服务密码?" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
    [alertController addAction:cancelAction];
    [self presentViewController:alertController animated:YES completion:nil];
}
/**
 完成按钮
 @param sender 完成按钮
 */
- (IBAction)acitonSaveBtn:(UIButton *)sender
{
    NSString *phone     = self.phone_tf.text;
    NSString *serverpwd = self.serverpwd_tf.text;
    NSString *card      = self.card_tf.text;
    NSString *name      = self.name_lab.text;
    if (phone.length == 0 || [phone isEqualToString:@""]) {
        [self showHint:@"手机号码不能为空" yOffset:-200];
        return;
    }
    if(phone.length != 11){
        [self showHint:@"手机号码有误 " yOffset:-200];
        return;
    }
    if (serverpwd.length == 0 || [serverpwd isEqualToString:@""]) {
        [self showHint:@"服务密码不能为空" yOffset:-200];
        return;
    }
    if (card.length == 0 || [card isEqualToString:@""]) {
        [self showHint:@"身份证不能为空" yOffset:-200];
        return;
    }
    if (name.length == 0 || [name isEqualToString:@""]) {
        [self showHint:@"姓名不能为空 " yOffset:-200];
        return;
    }
    //开始去上传资料
}
/**
 同意按钮
 @param sender 同意按钮
 */
- (IBAction)actionAgreeBtn:(UIButton *)sender
{
    sender.selected = !sender.selected;
    if (sender.selected) {
        [self.agree_btn setImage:[UIImage imageNamed:@"aregree_sel.png"] forState:UIControlStateNormal];
        self.save_btn.enabled = YES;
        [self.save_btn setBackgroundImage:[UIImage imageNamed:@"bg"] forState:UIControlStateNormal];

    }else{
        [self.agree_btn setImage:[UIImage imageNamed:@"aregree_nor.png"] forState:UIControlStateNormal];
        self.save_btn.enabled = NO;
        [self.save_btn setBackgroundImage:[UIImage imageNamed:@"bg_gary"] forState:UIControlStateNormal];
    
    }
}

@end
