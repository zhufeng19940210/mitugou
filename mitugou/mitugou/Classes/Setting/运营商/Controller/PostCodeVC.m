//  PostCodeVC.m
//  WuY_Build
//  Created by Apple on 2018/4/2.
//  Copyright © 2018年 HuiC. All rights reserved.
#import "PostCodeVC.h"
@interface PostCodeVC ()
@property (weak, nonatomic) IBOutlet UITextField *codeTF;
@property (nonatomic, copy) NSString *atoken;
@end

@implementation PostCodeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"输入短信验证码";
}
- (IBAction)next:(id)sender {
    [self.view endEditing:YES];
    if (!self.codeTF.text.length) {
        [self showHint:@"请输入短信验证码"];
        return;
    }
    NSDictionary *dic = @{@"apiKey":APIKEY,
                          @"sign":self.sign,
                          @"token":self.token,
                          @"input":self.codeTF.text
                          };
    NSString *url = [NSString stringWithFormat:@"%@/mobile_report/v1/task/input",LIMU_SeverUrl];
    WEAKSELF
    [SVProgressHUD show];
    [[NetWorkTool shareInstacne]postWithURLString:url parameters:dic success:^(id  _Nonnull responseObject) {
        NSLog(@"responseObject:%@",responseObject);
        if ([responseObject[@"code"] isEqualToString:@"0009"]) {
            weakSelf.atoken = responseObject[@"token"];
            [weakSelf nextPostData:weakSelf.atoken];
        }else{
            [weakSelf showHint:responseObject[@"msg"] yOffset:-250];
        }
    } failure:^(NSError * _Nonnull error) {
        [SVProgressHUD dismiss];
        [SVProgressHUD showErrorWithStatus:FailRequestTip];
        return;
    }];
}

//状态轮循
-(void)nextPostData:(NSString *)token
{
    NSDictionary *dic = @{@"apiKey":APIKEY,
                          @"sign":self.sign,
                          @"token":token
                          };
    NSString *url = [NSString stringWithFormat:@"%@/mobile_report/v1/task/status",LIMU_SeverUrl];
    WEAKSELF
    [[NetWorkTool shareInstacne]postWithURLString:url parameters:dic success:^(id  _Nonnull responseObject) {
        NSLog(@"responobject:%@",responseObject);
        if ([responseObject[@"code"] isEqualToString:@"0100"]) {
            [weakSelf nextPostData:responseObject[@"token"]];
        }else if([responseObject[@"code"] isEqualToString:@"0000"]){
            [SVProgressHUD dismiss];
            [weakSelf commitToke:responseObject[@"token"]];
        }else if([responseObject[@"code"] isEqualToString:@"0006"]){
            [SVProgressHUD dismiss];
            [weakSelf showHint:@"请再次输入验证码" yOffset:-250];
            weakSelf.codeTF.text = @"";
        }else if([responseObject[@"code"] isEqualToString:@""]){
            [weakSelf performSelector:@selector(afterPost) withObject:nil afterDelay:5];
        }else{
            [SVProgressHUD dismiss];
            [weakSelf showHint:responseObject[@"msg"] yOffset:-250];
        }
    } failure:^(NSError * _Nonnull error) {
        [SVProgressHUD dismiss];
        [SVProgressHUD showErrorWithStatus:FailRequestTip];
        return;
    }];
}
//提交token
-(void)commitToke:(NSString *)token
{
    [SVProgressHUD show];
    NSString *valueToken = [[NSUserDefaults standardUserDefaults]valueForKey:ZF_TOKEN];
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"token"] = valueToken;
    param[@"key"]   = @"phonetoken";
    param[@"value"] = token;
    [[NetWorkTool shareInstacne]postWithURLString:LIMU_SDK_URL parameters:param success:^(id  _Nonnull responseObject) {
        NSLog(@"responsebject:%@",responseObject);
        ResponeModel *res = [ResponeModel mj_objectWithKeyValues:responseObject];
        if (res.code == 1) {
            [SVProgressHUD showSuccessWithStatus:@"提交成功"];
        }else{
            [SVProgressHUD showErrorWithStatus:@"提示失败"];
            return ;
        }
    } failure:^(NSError * _Nonnull error) {
        [SVProgressHUD showErrorWithStatus:FailRequestTip];
        return;
    }];
}
-(void)afterPost
{
    [self nextPostData:self.token];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
