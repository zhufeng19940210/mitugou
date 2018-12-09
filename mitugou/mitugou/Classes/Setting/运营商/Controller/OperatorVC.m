//
//  OperatorVC.m
//  WuY_Build
//
//  Created by Apple on 2018/3/29.
//  Copyright © 2018年 HuiC. All rights reserved.
//

#import "OperatorVC.h"
#import<CommonCrypto/CommonDigest.h>
#import "UserModel.h"
#import "PostCodeVC.h"
@interface OperatorVC ()
@property (weak, nonatomic) IBOutlet UITextField *nameTF;
@property (weak, nonatomic) IBOutlet UITextField *cardNumberTF;
@property (weak, nonatomic) IBOutlet UITextField *phoneTF;
@property (weak, nonatomic) IBOutlet UITextField *serveWordTF;
@property (nonatomic, copy) NSString *sign;
@property (nonatomic, copy) NSString *token;

@end

@implementation OperatorVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"手机运营商认证";
}

- (IBAction)postData:(id)sender {
    
    NSString *name  = self.nameTF.text;
    NSString *card  = self.cardNumberTF.text;
    NSString *phone = self.phoneTF.text;
    NSString *server= self.serveWordTF.text;
    if (name.length ==0 || [name isEqualToString:@""]) {
        [self showHint:@"姓名不能为空" yOffset:-200];
        return;
    }
    if (card.length ==0 || [card isEqualToString:@""]) {
        [self showHint:@"身份证不能为空" yOffset:-200];
        return;
    }
    if (phone.length ==0 || [phone isEqualToString:@""]) {
        [self showHint:@"手机号码不能为空" yOffset:-200];
        return;
    }
    if (phone.length != 11) {
        [self showHint:@"手机号码为11位" yOffset:-200];
        return;
    }
    if (server.length == 0 || [server isEqualToString:@""]) {
        [self showHint:@"手机服务密码不能为空"];
        return;
    }
    //签名
    NSData *data = [self.serveWordTF.text dataUsingEncoding:NSUTF8StringEncoding];
    NSString *base64String = [data base64EncodedStringWithOptions:0];
    NSDictionary *params = @{@"apiKey":APIKEY,
                          @"identityCardNo":self.cardNumberTF.text,
                          @"identityName":self.nameTF.text,
                          @"username":self.phoneTF.text,
                          @"password":base64String,
                          };
    NSString *singstr = [[self signStr:params] stringByAppendingString:APISECRET];
    singstr = [singstr stringByReplacingOccurrencesOfString:@":"withString:@"="];
    NSString *sign = [self sha1:singstr];
    self.sign = sign;
    NSString *url = [NSString stringWithFormat:@"%@/mobile_report/v1/task",LIMU_SeverUrl];
    NSDictionary *dic = @{@"apiKey":APIKEY,
                          @"sign":sign,
                          @"identityCardNo":self.cardNumberTF.text,
                          @"identityName":self.nameTF.text,
                          @"username":self.phoneTF.text,
                          @"password":base64String,
                          };
    WEAKSELF
    [SVProgressHUD show];
    [[NetWorkTool shareInstacne]postWithURLString:url parameters:dic success:^(id  _Nonnull responseObject) {
        NSLog(@"responseobject:%@",responseObject);
        if ([responseObject[@"code"] isEqualToString:@"1109"]) {
        }else if ([responseObject[@"code"] isEqualToString:@"0010"]) {
            weakSelf.token = responseObject[@"token"];
            [weakSelf nextPostData:responseObject[@"token"]];
        }else if([responseObject[@"code"] isEqualToString:@"0100"]){
            weakSelf.token = responseObject[@"token"];
            [weakSelf nextPostData:responseObject[@"token"]];
        }else {
            [SVProgressHUD dismiss];
            [weakSelf showHint:responseObject[@"msg"]];
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
    [SVProgressHUD show];
    [[NetWorkTool shareInstacne]postWithURLString:url parameters:dic success:^(id  _Nonnull responseObject) {
        NSLog(@"responseObject:%@",responseObject);
        if ([responseObject[@"code"] isEqualToString:@"0006"]) {
            [SVProgressHUD dismiss];
            [ZJCustomHud showWithSuccess:@"请输入验证码！"];
            PostCodeVC *vc = [PostCodeVC new];
            vc.sign = weakSelf.sign;
            vc.token = responseObject[@"token"];
            [weakSelf.navigationController pushViewController:vc animated:YES];
        }else if([responseObject[@"code"] isEqualToString:@""]){
            [weakSelf performSelector:@selector(afterPost) withObject:nil afterDelay:5];
        }else if([responseObject[@"code"] isEqualToString:@"0100"]){
            weakSelf.token = responseObject[@"token"];
            [weakSelf nextPostData:responseObject[@"token"]];
        }else if([responseObject[@"code"] isEqualToString:@"0000"]){
            NSLog(@"成功了");
            [weakSelf commitToke:responseObject[@"token"]];
            
        }else{
            [SVProgressHUD dismiss];
            [weakSelf showHint:responseObject[@"msg"]];
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
@end
