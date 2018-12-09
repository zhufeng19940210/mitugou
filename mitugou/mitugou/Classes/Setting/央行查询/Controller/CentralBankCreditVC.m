//  CentralBankCreditVC.m
//  mitugou
//  Created by zhufeng on 2018/12/6.
//  Copyright © 2018 zhufeng. All rights reserved.
#import "CentralBankCreditVC.h"
@interface CentralBankCreditVC ()
@property (weak, nonatomic) IBOutlet UITextField *name_tf;
@property (weak, nonatomic) IBOutlet UITextField *pwd_tf;
@property (weak, nonatomic) IBOutlet UITextField *code_tf;
@property (weak, nonatomic) IBOutlet UIButton *eye_btn;
@property (nonatomic,copy) NSString *sign;
@property (nonatomic,strong)NSString *token;
@end
@implementation CentralBankCreditVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"央行征信认证";
}
/**
 眼睛的点击
 @param sender  眼睛的点击
 */
- (IBAction)actionEyeBtn:(UIButton *)sender
{
    sender.selected = !sender.selected;
    if (sender.selected) {
        self.pwd_tf.secureTextEntry = NO;
        [self.eye_btn setImage:[UIImage imageNamed:@"eye_sel"] forState:UIControlStateNormal];
    }else{
        self.pwd_tf.secureTextEntry = YES;
        [self.eye_btn setImage:[UIImage imageNamed:@"eye_nor"] forState:UIControlStateNormal];
    }
}
/**
 提交btn
 @param sender 提交btn
 */
- (IBAction)actionCommitBtn:(UIButton *)sender
{
    NSString *name = self.name_tf.text;
    NSString *pwd  = self.pwd_tf.text;
    NSString *code = self.code_tf.text;
    if (name.length == 0 || [name isEqualToString:@""]) {
        [self showHint:@"用户名不能为空" yOffset:-200];
        return;
        
    }if (pwd.length == 0 || [pwd isEqualToString:@""]) {
        [self showHint:@"密码不能为空" yOffset:-200];
        return;
    }
    if (code.length == 0 || [code isEqualToString:@""]) {
        [self showHint:@"身份验证码不能为空" yOffset:-200];
        return;
    }
    //签名
    NSData *data = [pwd dataUsingEncoding:NSUTF8StringEncoding];
    NSString *base64String = [data base64EncodedStringWithOptions:0];
    NSDictionary *params = @{@"apiKey":APIKEY,
                             @"method":@"api.credit.get",
                             @"version":@"1.3.0",
                             @"username":self.name_tf.text,
                             @"password":base64String,
                             @"middleAuthCode":code
                             };
    NSString *singstr = [[self signStr:params] stringByAppendingString:APISECRET];
    singstr = [singstr stringByReplacingOccurrencesOfString:@":"withString:@"="];
    
    NSString *sign = [self sha1:singstr];
    self.sign = sign;
    
    NSString *url = [NSString stringWithFormat:@"%@/api/gateway",LIMU_SeverUrl];
    NSLog(@"url:%@",url);
    NSDictionary *dic = @{@"apiKey":APIKEY,
                          @"method":@"api.credit.get",
                          @"version":@"1.3.0",
                          @"sign":sign,
                          @"username":name,
                          @"password":base64String,
                          @"middleAuthCode":code
                          };
    WEAKSELF
    [SVProgressHUD show];
    [[NetWorkTool shareInstacne]postWithURLString:url parameters:dic success:^(id  _Nonnull responseObject) {
        NSLog(@"responseObject:%@",responseObject);
        if ([responseObject[@"code"] isEqualToString:@"0010"]) {
            weakSelf.token = responseObject[@"token"];
            [weakSelf nextPostData:responseObject[@"token"]];
        }else{
            [SVProgressHUD showErrorWithStatus:responseObject[@"msg"]];
            return;
        }
    } failure:^(NSError * _Nonnull error) {
        [SVProgressHUD dismiss];
        [SVProgressHUD showErrorWithStatus:FailRequestTip];
        return;
    }];
}
//轮询查询
-(void)nextPostData:(NSString *)token
{
    NSLog(@"token:%@",token);
    [SVProgressHUD show];
    NSDictionary *params = @{@"apiKey":APIKEY,
                             @"method":@"api.common.getStatus",
                             @"version":@"1.3.0",
                             @"token":token,
                             @"bizType":@"credit"
                             };
    NSString *singstr = [[self signStr:params] stringByAppendingString:APISECRET];
    singstr = [singstr stringByReplacingOccurrencesOfString:@":"withString:@"="];
    
    NSString *sign = [self sha1:singstr];
    
    NSDictionary *dic = @{@"apiKey":APIKEY,
                          @"method":@"api.common.getStatus",
                          @"sign":sign,
                          @"version":@"1.3.0",
                          @"token":token,
                          @"bizType":@"credit"
                          };
    NSString *url = [NSString stringWithFormat:@"%@/api/gateway",LIMU_SeverUrl];
    WEAKSELF
    [[NetWorkTool shareInstacne]postWithURLString:url parameters:dic success:^(id  _Nonnull responseObject) {
        NSLog(@"responseObject:%@",responseObject);
        if ([responseObject[@"code"] isEqualToString:@"0000"]) {
            [SVProgressHUD dismiss];
            [weakSelf postBankDataWithToken:responseObject[@"token"]];
        }else if([responseObject[@"code"] isEqualToString:@"0100"]){
            //登录成功
            [weakSelf nextPostData:responseObject[@"token"]];
        }
        else if([responseObject[@"code"] isEqualToString:@""]){
            [weakSelf performSelector:@selector(afterPost) withObject:nil afterDelay:5];
        }else{
            [SVProgressHUD showErrorWithStatus:responseObject[@"msg"]];
            return ;
        }
    } failure:^(NSError * _Nonnull error) {
        [SVProgressHUD dismiss];
        [SVProgressHUD showErrorWithStatus:FailRequestTip];
        return;
    }];
}
//提交服务
-(void)postBankDataWithToken:(NSString *)token
{
    [SVProgressHUD show];
    NSString *valueToken = [[NSUserDefaults standardUserDefaults]valueForKey:ZF_TOKEN];
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"token"] = valueToken;
    param[@"key"]   = @"banktoken";
    param[@"value"] = token;
    WEAKSELF
    [[NetWorkTool shareInstacne]postWithURLString:LIMU_SDK_URL parameters:param success:^(id  _Nonnull responseObject) {
        NSLog(@"responsebject:%@",responseObject);
        ResponeModel *res = [ResponeModel mj_objectWithKeyValues:responseObject];
        if (res.code == 1) {
            [SVProgressHUD showSuccessWithStatus:@"提交成功"];
            [weakSelf.navigationController popViewControllerAnimated:YES];
        }else{
            [SVProgressHUD showErrorWithStatus:@"提示失败"];
            return ;
        }
    } failure:^(NSError * _Nonnull error) {
        [SVProgressHUD showErrorWithStatus:FailRequestTip];
        return;
    }];
}
///再次去轮询
-(void)afterPost
{
    [self nextPostData:self.token];
}
//字典升序排序
-(NSString *)signStr:(NSDictionary *)params
{
    NSArray *keyArray = [params allKeys];
    NSArray *sortArray = [keyArray sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        return [obj1 compare:obj2 options:NSNumericSearch];
    }];
    NSMutableArray *valueArray = [NSMutableArray array];
    for (NSString *sortString in sortArray) {
        [valueArray addObject:[params objectForKey:sortString]];
    }
    NSMutableArray *signArray = [NSMutableArray array];
    for (int i = 0; i < sortArray.count; i++) {
        NSString *keyValueStr = [NSString stringWithFormat:@"%@:%@",sortArray[i],valueArray[i]];
        [signArray addObject:keyValueStr];
    }
    NSString *sign = [signArray componentsJoinedByString:@"&"];
    return sign;
}

- (NSString *)sha1:(NSString *)input
{
    //const char *cstr = [input cStringUsingEncoding:NSUTF8StringEncoding];
    //NSData *data = [NSData dataWithBytes:cstr length:input.length];
    
    NSData *data = [input dataUsingEncoding:NSUTF8StringEncoding];
    
    uint8_t digest[CC_SHA1_DIGEST_LENGTH];
    
    CC_SHA1(data.bytes, (unsigned int)data.length, digest);
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];
    for(int i=0; i<CC_SHA1_DIGEST_LENGTH; i++) {
        [output appendFormat:@"%02x", digest[i]];
    }
    return output;
}
@end
