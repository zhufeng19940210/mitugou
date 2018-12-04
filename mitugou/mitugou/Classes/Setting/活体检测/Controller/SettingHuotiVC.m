//  SettingHuotiVC.m
//  mitugou
//  Created by zhufeng on 2018/12/3.
//  Copyright © 2018 zhufeng. All rights reserved.
#import "SettingHuotiVC.h"
#import <LMLivenessDetectManger/LMLivenessDetectViewManger.h>
#import "HTJCBeginView.h"
#import <CommonCrypto/CommonDigest.h>
#import "UIButton+Block.h"
@interface SettingHuotiVC ()
{
    NSTimeInterval beginTimeInterval;
}
@property (nonatomic, strong) HTJCBeginView *faceView;
@property (nonatomic, strong) UILabel *naviTitleLb;
@end

@implementation SettingHuotiVC
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self addSubView];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
}
- (void)addSubView
{
    _faceView = [[HTJCBeginView alloc]init];
    __weak typeof(self) weakSelf = self;
    [_faceView.backBtn addTaregetActionBlock:^(UIButton *btn) {
        weakSelf.navigationController.navigationBarHidden = NO;
        [weakSelf.navigationController popViewControllerAnimated:YES];
    }];
    [self.view addSubview:_faceView];

    _faceView.beginBlock = ^(){
        [weakSelf setDetect];
    };
    
    _faceView.backBlock = ^() {
        [weakSelf.faceView changeToBeginView];
        weakSelf.naviTitleLb.text = @"身份检测";
        
    };
    _faceView.quitBlock = ^() {
        [weakSelf.faceView changeToBeginView];
        weakSelf.naviTitleLb.text = @"身份检测";
        
    };
    _faceView.againBlock = ^() {
        weakSelf.faceView.beginBlock();
    };
}

#pragma mark 调用SDK
/**
 调用SDK
 */
-(void)setDetect {
    beginTimeInterval = [NSDate date].timeIntervalSince1970*1000;//毫秒
    LMLivenessDetectViewManger *manager = [LMLivenessDetectViewManger sharedManager:self];
    
    
    NSArray *detectTypes = @[@0, @1, @2, @3, @4];
    detectTypes = [self random:detectTypes withRandomNum:3];//5选3随机
    [manager liveDetectTypeArray:detectTypes];
    
    __weak typeof(self) weakSelf = self;
    
    manager.liveDetectSuccess = ^(NSData *imageData){
        NSLog(@"获取到检测数据");
        UIImage *image = [UIImage imageWithData:imageData];
        //[weakSelf.faceView changeToSuccessView:image];
        //[weakSelf writeToSandBox:imageData];
        if (weakSelf.delegate) {
            if ([weakSelf.delegate respondsToSelector:@selector(SettingLiveWithImage:)]) {
                [weakSelf.delegate SettingLiveWithImage:image];
            }
        }
        [weakSelf.navigationController popViewControllerAnimated:YES];
    };
    manager.liveDetectFaile = ^(NSString *error){
        NSLog(@"检测失败：%@",error);
        [weakSelf.faceView changeToFailView:nil failedInfo:error];
    };
    manager.liveDetectCancel = ^(NSString *error){
        NSLog(@"取消检测：%@",error);
        [weakSelf.faceView changeToBeginView];
        
    };
    // APIServer:nil表示生产环境；@“https://t.limuzhengxin.cn”：表示演示
    //请设置对应环境下的apiKey和apiSecret
    [manager satrtLiveDetectWithAPIServer:@"https://t.limuzhengxin.cn" apiKey:APIKEY auth:^(NSString *sign) {
        
        // NOTE: 获取私钥并将商户信息签名，外部商户的加签过程请务必放在服务端，防止公私钥数据泄露；
        // 模拟服务端签名
        NSString *newSign = [self sign:sign];
        
        //将服务端加签好的signString发送给SDK
        [manager sendSignToSDK:newSign];
        
    }];
}


-(NSString *)movementWithType:(NSString *)movementType{
    NSString *movement = @"";
    if ([movementType isEqualToString:@"0"]) {
        movement = @"凝视";
    }else if ([movementType isEqualToString:@"1"]){
        movement = @"摇头";
    }else if ([movementType isEqualToString:@"2"]){
        movement = @"点头";
    }else if ([movementType isEqualToString:@"3"]){
        movement = @"张嘴";
    }else if ([movementType isEqualToString:@"4"]){
        movement = @"眨眼";
    }else{
        movement = @"监测中";// 在动作切换之间的时间段
    }
    return movement;
    
}
-(NSString *)errorToMessage:(NSError *)error{
    NSString *errorInfo = error.domain;//错误信息: 包括 错误描述 和 具体的错误动作,以":"分开,请注意分开来取
    NSInteger errorCode = error.code;//错误码(可选)
    NSTimeInterval currentTimerval = [NSDate date].timeIntervalSince1970*1000;
    float time = currentTimerval - beginTimeInterval;//检测耗时(可选)
    NSRange range = [errorInfo rangeOfString:@":"];
    if (range.length>0) {
        NSString *movementType = [errorInfo substringFromIndex:range.location+1];
        movementType = [self movementWithType:movementType];//具体的错误动作(可选)
        NSString *failedStr = [errorInfo substringToIndex:range.location];//错误描述(可选)
        //错误描述 + 错误码 + 具体的错误动作 + 检测耗时. 需要如何显示可自行调整.
        errorInfo = [NSString stringWithFormat:@"%@:%ld\n失败动作是:%@\n总耗时:%.f毫秒",failedStr,errorCode,movementType,time];
    }else{
        //错误描述 + 错误码
        errorInfo = [NSString stringWithFormat:@"%@:%ld",errorInfo,errorCode];
    }
    return errorInfo;
}
//存入沙盒
-(void)writeToSandBox:(NSData *)imageData{
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *testDirectory = [documentsDirectory stringByAppendingPathComponent:@"/HTJCLiveDetect/unDownLoad"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL res=[fileManager createDirectoryAtPath:testDirectory withIntermediateDirectories:YES attributes:nil error:nil];
    if (!res) NSLog(@"文件夹创建失败");
    else {
        NSString *name = [self GetTimeInterval];
        NSString *testPath = [testDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.jpg",name]];
        NSLog(@"--------testPath:%@----------",testPath);
        BOOL res = [imageData writeToFile:testPath atomically:YES];
        if (!res){
            NSLog(@"文件写入失败");
        }
    }
}
// 将NSlog打印信息保存到Document目录下的文件中
- (void)redirectNSlogToDocumentFolder
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [paths objectAtIndex:0];
    NSString *fileName = [NSString stringWithFormat:@"blinkEyesCrash.log"];// 注意不是NSData!
    NSString *logFilePath = [documentDirectory stringByAppendingPathComponent:fileName];
    // 先删除已经存在的文件
    NSFileManager *defaultManager = [NSFileManager defaultManager];
    [defaultManager removeItemAtPath:logFilePath error:nil];
    
    // 将log输入到文件
    freopen([logFilePath cStringUsingEncoding:NSASCIIStringEncoding], "a+", stdout);
    freopen([logFilePath cStringUsingEncoding:NSASCIIStringEncoding], "a+", stderr);
}

//获取当前时间
-(NSString *)GetTimeInterval{
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"YYYYMMddHHmmss"];
    NSString *currentTime = [formatter stringFromDate:[NSDate date]];
    return currentTime;
}

//随机数组
- (NSMutableArray *)random:(NSArray *)array withRandomNum:(NSInteger)num
{
    NSMutableArray *startArray = [[NSMutableArray alloc] initWithArray:array];
    //随机数产生结果
    NSMutableArray *resultArray=[[NSMutableArray alloc] initWithCapacity:0];
    //随机数个数
    NSInteger m=num;
    for (int i=0; i<m; i++) {
        int t=arc4random()%startArray.count;
        resultArray[i]=startArray[t];
        startArray[t]=[startArray lastObject]; //为更好的乱序，故交换下位置
        [startArray removeLastObject];
    }
    return resultArray;
}


#pragma mark - 签名
#pragma mark - 模拟服务端签名
//签名算法如下：
//1. 将立木回调参数 authInfo 和 APISECRET 直接拼接；
//2. 将上述拼接后的字符串进行SHA-1计算，并转换成16进制小写编码；
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
    //    NSLog(@"====2.newsign:%@",newsign);
    return newsign;
    
}

- (NSString *)base64Encode:(NSString *)string {
    NSData *nsdata = [string
                      dataUsingEncoding:NSUTF8StringEncoding];
    return [nsdata base64EncodedStringWithOptions:0];
}
/**
 获取当前时间毫秒
 
 @return 毫秒
 */
- (NSString *)getCurrentDateMS
{
    NSString *ms = [NSString stringWithFormat:@"%lld",(long long)[[NSDate date] timeIntervalSince1970]*1000];
    
    return ms;
}
@end
