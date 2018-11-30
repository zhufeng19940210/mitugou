//  SettingTestLimuEducationVC.m
//  mitugou
//  Created by zhufeng on 2018/11/29.
//  Copyright © 2018 zhufeng. All rights reserved.
#import "SettingTestLimuEducationVC.h"
@interface SettingTestLimuEducationVC ()
@property (weak, nonatomic) IBOutlet UITextField *username_tf;
@property (weak, nonatomic) IBOutlet UITextField *userpwd_tf;
@property (nonatomic,strong) LMZXSDK *lmzxSDK;
@end
@implementation SettingTestLimuEducationVC
- (void)viewDidLoad {
    [super viewDidLoad];
    // 设置调试地址
    [LMZXSDK shared].lmzxTestURL = LIMU_SeverUrl;
    self.lmzxSDK = [LMZXSDK lmzxSDKWithApikey:APIKEY uid:UID callBackUrl:CALLBACKURL];
    //启动服务,授权查询
    LMZXSDKFunction sdkFunction;
    sdkFunction = LMZXSDKFunctionEducation;
    WEAKSELF
    [_lmzxSDK startFunction:sdkFunction authCallBack:^(NSString *authInfo) {
        // NOTE: 获取私钥并将商户信息签名，外部商户的加签过程请务必放在服务端，防止公私钥数据泄露；
        // 模拟服务端签名
        NSString *singString = [weakSelf sign:authInfo];
        ///将服务端加前民好的signString发送给SDK
        [[LMZXSDK shared] sendReqWithSign:singString];
    }];
    //结果回调
    [self handleResult:@"education"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)actionCommitBtn:(UIButton *)sender
{
}
#pragma mark --监听结果回调
- (void)handleResult:(NSString *)functionType {
    WEAKSELF
    _lmzxSDK.lmzxResultBlock = ^(NSInteger code, LMZXSDKFunction function, id obj, NSString *token) {
        NSLog(@"SDK结果回调:%ld,%d,%@,%@",(long)code,function,obj,token);
        if(code >= 0){
            [weakSelf postData:token];
        }else{
            [SVProgressHUD showErrorWithStatus:@"查询失败"];
            return;
        }
    };
}

-(void)postData:(NSString *)token
{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    NSString *token2 = [[NSUserDefaults standardUserDefaults]valueForKey:ZF_TOKEN];
    param[@"token"] = token2;
    param[@"key"] = @"alitoken";
    param[@"value"] = token;
    [[NetWorkTool shareInstacne]postWithURLString:LIMU_SDK_URL parameters:param success:^(id  _Nonnull responseObject) {
        NSLog(@"responseobject:%@",responseObject);
    } failure:^(NSError * _Nonnull error) {
        [SVProgressHUD showErrorWithStatus:FailRequestTip];
        return ;
    }];
}
#pragma mark - 签名
#pragma mark - 模拟服务端签名
//签名算法如下：
//1. 将立木回调参数 authInfo 和 APISECRET 直接拼接；
//2. 将上述拼接后的字符串进行SHA-1计算，并转换成16进制编码；
//3. 将上述字符串转换为全小写形式后即获得签名串
- (NSString *)sign:(NSString*)string
{
    NSString *sign = [string stringByAppendingString:APISECRET];
    NSMutableString *mString = [NSMutableString stringWithString:sign];
    NSString *newsign ;
    // 3、对该字符串进行SHA-1计算，得到签名，并转换成16进制小写编码,得到签名串
    unsigned char digest[CC_SHA1_DIGEST_LENGTH];
    NSData *stringBytes = [mString dataUsingEncoding: NSUTF8StringEncoding];
    
    if (CC_SHA1([stringBytes bytes], (unsigned int)[stringBytes length], digest)) {
        NSMutableString *digestString = [NSMutableString stringWithCapacity:
                                         CC_SHA1_DIGEST_LENGTH];
        for (int i=0; i<CC_SHA1_DIGEST_LENGTH; i++) {
            unsigned char aChar = digest[i];
            [digestString appendFormat:@"%02X", aChar];
        }
        newsign =[digestString lowercaseString];
        
    }
    NSLog(@"====2.newsign:%@",newsign);
    return newsign;
}
@end
