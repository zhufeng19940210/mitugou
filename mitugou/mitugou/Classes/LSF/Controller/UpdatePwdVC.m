//  UpdatePwdVC.m
//  mitugou
//  Created by zhufeng on 2018/11/8.
//  Copyright © 2018 zhufeng. All rights reserved.
#import "UpdatePwdVC.h"
@interface UpdatePwdVC ()
@property (weak, nonatomic) IBOutlet UITextField *old_pwd_tf;
@property (weak, nonatomic) IBOutlet UITextField *pwd_tf;
@end
@implementation UpdatePwdVC
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"修改密码";
}
/**
 提交用户
 @param sender 提交用户
 */
- (IBAction)actionCommitBtn:(UIButton *)sender
{
    NSString *old_pwd = self.old_pwd_tf.text;
    NSString *pwd     = self.pwd_tf.text;
    if (old_pwd.length == 0 || [old_pwd isEqualToString:@""]) {
        [self showHint:@"旧密码不能为空" yOffset:-200];
        return;
    }
    if (pwd.length == 0 || [pwd isEqualToString:@""]) {
        [self showHint:@"新密码不能为空" yOffset:-200];
        return;
    }
    //TODO这里去发送请求
}

@end
