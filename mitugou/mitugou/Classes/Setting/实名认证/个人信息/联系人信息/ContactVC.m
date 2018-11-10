//  ContactVC.m
//  mitugou
//  Created by zhufeng on 2018/11/10.
//  Copyright © 2018 zhufeng. All rights reserved.
#import "ContactVC.h"
@interface ContactVC ()
@property (weak, nonatomic) IBOutlet UITextField *name_tf;
@property (weak, nonatomic) IBOutlet UITextField *phone_tf;
@property (weak, nonatomic) IBOutlet UITextField *society_tf;
@end
@implementation ContactVC
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"联系人信息";
    [self setupData];
}
/**
 请求数据
 */
-(void)setupData
{
    
}
/**
 保存方法
 @param sender 保存方法
 */
- (IBAction)actionSaveBtn:(UIButton *)sender
{
    NSString *name     = self.name_tf.text;
    NSString *phone    = self.phone_tf.text;
    NSString *society  = self.society_tf.text;
    if (name.length == 0 || [name isEqualToString:@""]) {
        [self showHint:@"联系人姓名不能为空" yOffset:-200];
        return;
    }
    if (phone.length == 0 || [phone isEqualToString:@""]) {
        [self showHint:@"联系人号码不能为空" yOffset:-200];
        return;
    }
    if (society.length == 0 || [society isEqualToString:@""]) {
        [self showHint:@"联系人社会关系不能为空" yOffset:-200];
        return;
    }
    //开始去发送请求了
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
@end
