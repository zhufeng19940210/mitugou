//  OrderPinjiaVC.m
//  mitugou
//  Created by zhufeng on 2018/12/3.
//  Copyright © 2018 zhufeng. All rights reserved.
#import "OrderPinjiaVC.h"
#import "IQTextView.h"
@interface OrderPinjiaVC ()
@property (weak, nonatomic) IBOutlet IQTextView *textview;
@end
@implementation OrderPinjiaVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"评价";
    self.textview.font = [UIFont systemFontOfSize:15];
    self.textview.placeholder = @"请输入你的评价,我们将提供更优质的服务";
}
/**
 提交评价
 @param sender 提交评价
 */
- (IBAction)actionCommitBtn:(UIButton *)sender
{
    NSString *placher_txt = self.textview.text;
    if (placher_txt.length == 0 || [placher_txt isEqualToString:@""]) {
        [SVProgressHUD showErrorWithStatus:@"请输入评价"];
        return;
    }
    [SVProgressHUD show];
    NSString *token = [[NSUserDefaults standardUserDefaults]valueForKey:ZF_TOKEN];
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"token"] = token;
    param[@"content"] = placher_txt;
    [[NetWorkTool shareInstacne]postWithURLString:Order_Evaluation_Url parameters:param success:^(id  _Nonnull responseObject) {
        NSLog(@"resposeobject:%@",responseObject);
        ResponeModel *res = [ResponeModel mj_objectWithKeyValues:responseObject];
        if (res.code == 1) {
            [SVProgressHUD showSuccessWithStatus:@"评价成功"];
            [[NSNotificationCenter defaultCenter]postNotificationName:PINJIASUCCESS object:nil];
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            [SVProgressHUD showErrorWithStatus:res.message];
            return;
        }
    } failure:^(NSError * _Nonnull error) {
        [SVProgressHUD dismiss];
        [SVProgressHUD showErrorWithStatus:FailRequestTip];
        return;
    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
@end
