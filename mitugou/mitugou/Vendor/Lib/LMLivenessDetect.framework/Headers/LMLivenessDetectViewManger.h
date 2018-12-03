//
//  THIDMCViewManger.h
//  LMFaceDetect
//
//  Created by yj on 2017/12/11.
//  Copyright © 2017年 limuzhengxin. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef void(^LMLiveDetectSign)(NSString *sign);

typedef void(^LMLiveDetectSuccess)(NSData *imageData);

typedef void(^LMLiveDetectCancel)(NSString *error);

typedef void(^LMLiveDetectFaile)(NSString *error);


@interface LMLivenessDetectViewManger : NSObject

/**
 活体检测成功回调
 */
@property (nonatomic, copy) LMLiveDetectSuccess liveDetectSuccess;
/**
 活体检测取消回调
 */
@property (nonatomic, copy) LMLiveDetectCancel liveDetectCancel;
/**
 活体检测失败回调
 */
@property (nonatomic, copy) LMLiveDetectFaile liveDetectFaile;

//获取实例对象
+(LMLivenessDetectViewManger *)sharedManager:(UIViewController*)_vc;



/**
 启动活体检测

 @param apiServer nil默认为生产环境(上线请设置为nil)；演示环境：https://t.limuzhengxin.cn
 @param apiKey 用户申请key
 @param auth 授权回调
 */
- (void)satrtLiveDetectWithAPIServer:(NSString*)apiServer apiKey:(NSString *)apiKey auth:(void(^)(NSString *sign))auth;



/**
 用户加签

 @param newSign 用户将授权返回的sign到服务端进行加签后，发送给SDK
 */
- (void)sendSignToSDK:(NSString *)newSign;


/**
 *  退出活体
 */
-(void)dismissTakeCaptureSessionViewController;



#pragma mark -
#pragma mark 可能需要配置信息  如需配置,请设置完成后  在启动检测 getLiveDetectCompletion:cancel:failed:
/**
 *  导航栏样式       navType = 0 方式：addSubView   （默认）
 *                 navType = 1 方式：present
 *                 navType = 2 方式：push
 *
 *  @param navType 样式代号
 */
- (void)navigationType:(int)navType;

/**
 *  活体检测动作配置
 *
 *  @param liveDetectTypeArray   数组 @0 = 凝视  @1 = 摇头  @2 = 点头  @3 = 张嘴  @4 = 眨眼
 */
- (void)liveDetectTypeArray:(NSArray *)liveDetectTypeArray;

/**
 *  动作是否随机出现     NO则为liveDetectTypeArray配置的顺序
 *
 *  @param isRandom   随机
 */
- (void)isNeedRandom:(BOOL)isRandom;



/**
 *  获取算法SDK版本号
 *
 *  @return 版本号
 */
- (NSString *)getSDKVersion;
@end
