//  TaobaoVC.m
//  mitugou
//  Created by zhufeng on 2018/12/6.
//  Copyright © 2018 zhufeng. All rights reserved.
#import "TaobaoVC.h"
#import <CoreImage/CoreImage.h>
@interface TaobaoVC ()
@property (nonatomic,copy)NSString *sign;
@property (nonatomic,copy)NSString *token;
@property (weak, nonatomic) IBOutlet UIImageView *imageview;
@property (weak, nonatomic) IBOutlet UILabel *content_lab;
@end
@implementation TaobaoVC
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"淘宝认证";
    [self createQR];
}
-(void)createQR{
    //签名
    NSDictionary *params = @{@"apiKey":APIKEY,
                             @"method":@"api.taobao.get",
                             @"version":@"1.3.0",
                             @"loginType":@"qr"
                             };
    NSString *singstr = [[self signStr:params] stringByAppendingString:APISECRET];
    singstr = [singstr stringByReplacingOccurrencesOfString:@":"withString:@"="];
    
    NSString *sign = [self sha1:singstr];
    self.sign = sign;
    
    NSString *url = [NSString stringWithFormat:@"%@/api/gateway",LIMU_SeverUrl];
    NSLog(@"url:%@",url);
    NSDictionary *dic = @{@"apiKey":APIKEY,
                          @"method":@"api.taobao.get",
                          @"sign":sign,
                          @"version":@"1.3.0",
                          @"loginType":@"qr"
                          };
    WEAKSELF
    [SVProgressHUD show];
    [[NetWorkTool shareInstacne]postWithURLString:url parameters:dic success:^(id  _Nonnull responseObject) {
        NSLog(@"responseObject:%@",responseObject);
        if ([responseObject[@"code"] isEqualToString:@"0010"]) {
            weakSelf.token = responseObject[@"token"];
            [weakSelf nextPostDataWithToken:responseObject[@"token"]];
        }else if([responseObject[@"code"] isEqualToString:@""]){
            [weakSelf createQR];
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
/**
 轮询操纵
 @param token 轮询操作
 */
-(void)nextPostDataWithToken:(NSString *)token
{
    NSLog(@"token:%@",token);
    NSDictionary *params = @{@"apiKey":APIKEY,
                             @"method":@"api.common.getStatus",
                             @"version":@"1.3.0",
                             @"token":token,
                             @"bizType":@"taobao"
                             };
    NSString *singstr = [[self signStr:params] stringByAppendingString:APISECRET];
    singstr = [singstr stringByReplacingOccurrencesOfString:@":"withString:@"="];
    NSString *sign = [self sha1:singstr];
    NSDictionary *dic = @{@"apiKey":APIKEY,
                          @"method":@"api.common.getStatus",
                          @"sign":sign,
                          @"version":@"1.3.0",
                          @"token":token,
                          @"bizType":@"taobao"
                          };
    NSString *url = [NSString stringWithFormat:@"%@/api/gateway",LIMU_SeverUrl];
    WEAKSELF
    [[NetWorkTool shareInstacne]postWithURLString:url parameters:dic success:^(id  _Nonnull responseObject) {
        NSLog(@"responseObject:%@",responseObject);
        if ([responseObject[@"code"] isEqualToString:@"0006"]) {
            NSDictionary *dic = responseObject[@"input"];
            if ([dic[@"type"] isEqualToString:@"qr"]) {
                [SVProgressHUD dismiss];
                //二维码展示
                weakSelf.imageview.hidden = NO;
                weakSelf.content_lab.hidden = NO;
                NSData *decodedData = [[NSData alloc] initWithBase64EncodedString:dic[@"value"] options:0];
                UIImage *_decodedImage    = [UIImage imageWithData:decodedData];
                weakSelf.imageview.image = _decodedImage;
                //进入轮询操作
                [weakSelf nextPostDataWithToken:responseObject[@"token"]];
            }else if([dic[@"type"] isEqualToString:@"sms"]){
                //短信接收
                [weakSelf ShowInputMethod];
            }
        }else if([responseObject[@"code"] isEqualToString:@"0008"]){
            [SVProgressHUD showSuccessWithStatus:@"扫描登录成功"];
        }else if ([responseObject[@"code"] isEqualToString:@""]){
            [self nextPostDataWithToken:responseObject[@"token"]];
        }else if([responseObject[@"code"] isEqualToString:@"0100"]){
            [SVProgressHUD show];
            [self nextPostDataWithToken:responseObject[@"token"]];
        }else if ([responseObject[@"code"] isEqualToString:@"0000"]){
            [SVProgressHUD dismiss];
            [weakSelf postDataWithToken:responseObject[@"token"]];
        }else{
            [SVProgressHUD showErrorWithStatus:responseObject[@"msg"]];
            return ;
        }
    } failure:^(NSError * _Nonnull error) {
        [SVProgressHUD dismiss];
        [SVProgressHUD showErrorWithStatus:FailRequestTip];
        return ;
    }];
}
/**
 显示输入验证码的东西
 */
-(void)ShowInputMethod{
    UIAlertController *alert2 = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"提示" preferredStyle:UIAlertControllerStyleAlert];
    [alert2 addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"请输入验证码";
    }];
    //确定按钮
    UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UITextField *tf_username = alert2.textFields.firstObject;
        if ([tf_username.text isEqualToString:@""]) {
            [SVProgressHUD showErrorWithStatus:@"验证码不能为空"];
            return;
        }
        [self nextPostDataWithToken:self.token];
    }];
    //取消按钮
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }];
    [alert2 addAction:sureAction];
    [alert2 addAction:cancelAction];
    [self presentViewController:alert2 animated:YES completion:^{
    }];
}
//提交成服务
-(void)postDataWithToken:(NSString *)token
{
    [SVProgressHUD show];
    NSString *valueToken = [[NSUserDefaults standardUserDefaults]valueForKey:ZF_TOKEN];
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"token"] = valueToken;
    param[@"key"]   = @"alitoken";
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
//    //创建过滤器
//    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
//    //过滤器恢复默认
//    [filter setDefaults];
//    //给过滤器添加数据
//    NSString *string = content;
//    //将NSString格式转化成NSData格式
//    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
//    [filter setValue:data forKeyPath:@"inputMessage"];
//    //获取二维码过滤器生成的二维码
//    CIImage *image = [filter outputImage];
//    //将获取到的二维码添加到imageview上
//    self.imageview.image =[self createNonInterpolatedUIImageFormCIImage:image withSize:150];
//- (UIImage *)createNonInterpolatedUIImageFormCIImage:(CIImage *)image withSize:(CGFloat) size
// {
//         CGRect extent = CGRectIntegral(image.extent);
//         CGFloat scale = MIN(size/CGRectGetWidth(extent), size/CGRectGetHeight(extent));
//
//         // 1.创建bitmap;
//         size_t width = CGRectGetWidth(extent) * scale;
//         size_t height = CGRectGetHeight(extent) * scale;
//         CGColorSpaceRef cs = CGColorSpaceCreateDeviceGray();
//         CGContextRef bitmapRef = CGBitmapContextCreate(nil, width, height, 8, 0, cs, (CGBitmapInfo)kCGImageAlphaNone);
//         CIContext *context = [CIContext contextWithOptions:nil];
//         CGImageRef bitmapImage = [context createCGImage:image fromRect:extent];
//         CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
//         CGContextScaleCTM(bitmapRef, scale, scale);
//         CGContextDrawImage(bitmapRef, extent, bitmapImage);
//
//         // 2.保存bitmap到图片
//         CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);
//         CGContextRelease(bitmapRef);
//         CGImageRelease(bitmapImage);
//         return [UIImage imageWithCGImage:scaledImage];
//
// }
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
@end
