//  SettingAuthonVC.m
//  mitugou
//  Created by zhufeng on 2018/11/8.
//  Copyright © 2018 zhufeng. All rights reserved.
#import "SettingAuthonVC.h"
#import "SettingAuthonCell.h"
#import "SingleAuthonVC.h"
#import "FaceAuthonVC.h"
#import "CardAuthonVC.h"
#import "YunYinShangAuthonVC.h"
#import "ZhifubaoPayAuthonVC.h"
#import "SettingLiveBodyVC.h"
@interface SettingAuthonVC ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (nonatomic,strong)NSMutableArray *titleArray;
@property (nonatomic,strong)NSDictionary *responseDict;
@property (nonatomic,strong) LMZXSDK *lmzxSDK;
@property (nonatomic,assign) LMZXSDKFunction sdkFunction;
@property (nonatomic,copy) NSString *functionType;
@end
@implementation SettingAuthonVC
-(NSMutableArray *)titleArray
{
    if (!_titleArray) {
        _titleArray = [NSMutableArray arrayWithObjects:@"个人信息认证",@"人脸识别认证",@"运营商认证",@"淘宝认证",@"央行认证", nil];
    }
    return _titleArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"实名认证";
    self.view.backgroundColor = RGB(240, 240, 240);
    [self initLIMUSDK];
    //[self setupData];
    [self setupTableView];
}
/**
 初始化的立木征信的的垃圾东西
 */
-(void)initLIMUSDK
{
    ///设置调试地址
    [LMZXSDK shared].lmzxTestURL = LIMU_SeverUrl;
    self.lmzxSDK = [LMZXSDK lmzxSDKWithApikey:APIKEY uid:UID callBackUrl:CALLBACKURL];
    ///导航栏颜色
    _lmzxSDK.lmzxThemeColor = MainThemeColor;
    // 返回按钮文字\图片颜色,标题颜色
    _lmzxSDK.lmzxTitleColor = [UIColor whiteColor];
    // 查询页面协议文字颜色,和查询动画页面的动画颜色,文字颜色相同
    _lmzxSDK.lmzxProtocolTextColor = [UIColor blackColor];
    // 提交按钮颜色
    _lmzxSDK.lmzxSubmitBtnColor = MainThemeColor;
    //  // 页面背景颜色
    _lmzxSDK.lmzxPageBackgroundColor = [UIColor whiteColor];
}
/**
 这里有个状态的东西
 */
-(void)setupData
{
    [SVProgressHUD show];
    NSString *token = [[NSUserDefaults standardUserDefaults]valueForKey:ZF_TOKEN];
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"token"] = token;
    WEAKSELF
    [[NetWorkTool shareInstacne]postWithURLString:@"" parameters:param success:^(id  _Nonnull responseObject) {
        [SVProgressHUD dismiss];
        ResponeModel *res = [ResponeModel mj_objectWithKeyValues:responseObject];
        if (res.code == 1) {
            weakSelf.responseDict = res.data[@"status"];
            [weakSelf.tableview reloadData];
        }else{
            [SVProgressHUD showErrorWithStatus:@"获取失败"];
            return;
        }
    } failure:^(NSError * _Nonnull error) {
        [SVProgressHUD dismiss];
        [SVProgressHUD showInfoWithStatus:FailRequestTip];
        return;
    }];
}
-(void)setupTableView
{
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    self.tableview.backgroundColor = [UIColor clearColor];
    [self.tableview registerNib:[UINib nibWithNibName:@"SettingAuthonCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"SettingAuthonCell"];
}
#pragma mark -- uitableviewdelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.titleArray.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 10;
    }else{
        return 5;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == self.titleArray.count-1) {
        return 10;
    }else{
        return 5;
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SettingAuthonCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SettingAuthonCell"];
    cell.content_lab.text = self.titleArray[indexPath.section];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
        //个人信息
        SingleAuthonVC *uservc = [[SingleAuthonVC alloc]init];
        [self.navigationController pushViewController:uservc animated:YES];
    }else if(indexPath.section == 1){
        //活体检测
        SettingLiveBodyVC *livebobyvc = [[SettingLiveBodyVC alloc]init];
        [self.navigationController pushViewController:livebobyvc animated:YES];
    }else if(indexPath.section == 2){
        //运营商认证
        _sdkFunction  = LMZXSDKFunctionMobileCarrie;
        _functionType = @"mobile";
        [self pushToLimuSDKMethod];
    }else if(indexPath.section == 3){
        //淘宝认证
        _sdkFunction  = LMZXSDKFunctionTaoBao;
        _functionType = @"taobao";
        [self pushToLimuSDKMethod];
    }else if(indexPath.section == 4){
        //央行认证
        _sdkFunction  =  LMZXSDKFunctionCentralBank;
        _functionType = @"credit";
        [self pushToLimuSDKMethod];
    }
}
#pragma mark -- 提交数据
/**
 运营商的的方法
 */
-(void)pushToLimuSDKMethod
{
    WEAKSELF
    [_lmzxSDK startFunction:_sdkFunction authCallBack:^(NSString *authInfo) {
        // NOTE: 获取私钥并将商户信息签名，外部商户的加签过程请务必放在服务端，防止公私钥数据泄露；
        // 模拟服务端签名
        NSString *singString = [weakSelf sign:authInfo];
        ///将服务端加前民好的signString发送给SDK
        [[LMZXSDK shared] sendReqWithSign:singString];
    }];
    ///结果回调
    [self  handleResult:_functionType];
}
#pragma mark --监听结果回调
- (void)handleResult:(NSString *)functionType {
    WEAKSELF
    _lmzxSDK.lmzxResultBlock = ^(NSInteger code, LMZXSDKFunction function, id obj, NSString *token) {
        NSLog(@"SDK结果回调:%ld,%d,%@,%@",(long)code,function,obj,token);
        if(code == 0){
            if ([functionType isEqualToString:@"mobile"]) {
                ///手机运营商
                [weakSelf postDataWithToken:token WithKey:@"phonetoken"];
            }else if([functionType isEqualToString:@"taobao"]){
                ///淘宝
                [weakSelf postDataWithToken:token WithKey:@"alitoken"];
            }else if ([functionType isEqualToString:@"credit"]){
                //央行征信
                [weakSelf postDataWithToken:token WithKey:@"banktoken"];
            }
        }else{
            [SVProgressHUD showErrorWithStatus:@"查询失败"];
            return;
        }
    };
}

-(void)postDataWithToken:(NSString *)token  WithKey:(NSString *)key
{
    [SVProgressHUD show];
    NSString *valueToken = [[NSUserDefaults standardUserDefaults]valueForKey:ZF_TOKEN];
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"token"] = valueToken;
    param[@"key"]   = key;
    param[@"value"] = token;
    [[NetWorkTool shareInstacne]postWithURLString:LIMU_SDK_URL parameters:param success:^(id  _Nonnull responseObject) {
        NSLog(@"responsebject:%@",responseObject);
        ResponeModel *res = [ResponeModel mj_objectWithKeyValues:responseObject];
        if (res.code == 1) {
            [SVProgressHUD showSuccessWithStatus:@"提交成功"];
        }
    } failure:^(NSError * _Nonnull error) {
        [SVProgressHUD showErrorWithStatus:FailRequestTip];
        return;
    }];
}
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
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
@end
