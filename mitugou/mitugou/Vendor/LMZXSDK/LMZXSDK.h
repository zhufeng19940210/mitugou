//
//  LMZXSDK.h
//  LMZX_SDK_Develop
//
//  Created by gyjrong on 17/2/13.
//  Copyright © 2017年 lmzx. All rights reserved.
//

#import <UIKit/UIKit.h>



////////////////////////////////////////////////
////////////////////////////////////////////////
// 注意事项1:  _lmzxTestURL 在测试环境下是被注释的,生产环境下不可注释!!!!!!
// 注意事项2:  channel 内部使用, 对外可将.h 文件的channel删除即可.无影响.
////////////////////////////////////////////////
////////////////////////////////////////////////



/*
 * 状态栏状态枚举
 */
typedef enum  {
    LMZXStatusBarStyleDefault = 0,
    LMZXStatusBarStyleLightContent ,

} LMZXStatusBarStyle;

/*
 * 功能的种类
 */

////////// 和 plist 一一对应
////////// 和 内部使用的枚举:LMZXHomeSearchType 一一对应,方便回调当前查询的模块

typedef enum {
    
///////////////////////// 1期 //////////////////////////
    
    /** 公积金0 */
    LMZXSDKFunctionHousingFund = 0,
    /** 运营商1 */
    LMZXSDKFunctionMobileCarrie,
    /** 京东2 */
    LMZXSDKFunctionJD,
    /** 淘宝3 */
    LMZXSDKFunctionTaoBao,
    /** 学历学籍4 */
    LMZXSDKFunctionEducation,
    
///////////////////////// 2期 //////////////////////////
  
    /** 社保5 */
    LMZXSDKFunctionSocialSecurity,
    /** 车险6 */
    LMZXSDKFunctionAutoinsurance,
    /** 网银流水7  */
    LMZXSDKFunctionEBankBill,
    /** 央行征信8  */
    LMZXSDKFunctionCentralBank,
    /** 信用卡账单9 */
    LMZXSDKFunctionCreditCardBill,
    

///////////////////////// 3期 //////////////////////////
//    /** 失信人10 */
//    LMZXSDKFunctionDishonest,
    /** 脉脉10 */
    LMZXSDKFunctionMaimai,
    /** 领英11 */
    LMZXSDKFunctionLinkedin,
    /** 携程查询12 */
    LMZXSDKFunctionCtrip,
    /** 滴滴查询13 */
    LMZXSDKFunctionDiDiTaxi,
///////////////////////// 4期 //////////////////////////
    /** 运营商信用报告V1版14 */
    LMZXSDKFunctionMobileCreditV1,
    /** 运营商信用报告V1_2版15 */
    LMZXSDKFunctionMobileCreditV1_2,
    
    ///////////////////////// 以下暂未开发 //////////////////////////
    
//    /** 身份验证:身份证实名 15*/
//    LMZXSDKFunctionCheckIDCard,
//    /** 身份验证:手机号实名 16*/
//    LMZXSDKFunctionCheckMobile,
//    /** 身份验证:银行卡3要素 17*/
//    LMZXSDKFunctionCheckBankCard3,
//    /** 身份验证:银行卡4要素 18*/
//    LMZXSDKFunctionCheckBankCard4,
    
    
}LMZXSDKFunction;

typedef void(^LMZXResultBlock)(NSInteger code, LMZXSDKFunction function, id obj, NSString * token);

//typedef NSString* (^LMZXAuthBlock)(NSString * authInfo);

typedef void(^LMZXAuthBlock)(NSString * authInfo);



@interface LMZXSDK : NSObject




/**********************      内部使用   APP 传入 APP     *******************************/
@property (nonatomic,strong) NSString *channel;
/**********************      内部使用       *******************************/




// @property (nonatomic,strong,readonly) NSString *LMZXSDKVersion;


/**********************             *******************************/
/********************** SDK 注册信息 *******************************/
/**********************             *******************************/


/*! @brief 调试地址 
 *  用于商户在测试环境下调试用
 *  注意:生产环境下,不要设置 lmzxTestURL 否则会覆盖 SDK 中的生产 url.
 */
@property (nonatomic,strong) NSString *lmzxTestURL;

/*! @brief ApiVersion
 */
@property (nonatomic,strong) NSString *lmzxApiVersion;

/*! @brief ApiKey
 */
@property (nonatomic,strong) NSString *lmzxApiKey;

/*! @brief 用户 ID
 *  用于回调通知时商户进行用户区分，通常填入用户在商户系统的用户名、提交流水号或其他
 */
@property (nonatomic,strong) NSString *lmzxUid;

/*! @brief 回调地址
 *  回调状态通知接口只通知查询的最终结果状态给商户，商户收到回调通知后，
 *  如果查询状态是成功的，需要调用”结果查询”接口获取查询结果
 */
@property (nonatomic,strong) NSString *lmzxCallBackUrl;




/**********************                *******************************/
/********************** SDK 任务属性设置 *******************************/
/**********************                *******************************/


/*! @brief 任务模式
 *  1\设置为YES: 查询成功自动退出,此时立木服务器已经获取到全部的数据.商户可直接从立木服务器请求结果数据
 *              获取数据方式1:结果数据出来后,立木服务器会通知商户,此时商户服务器可从立木服务器请求数据
 *              获取数据方式2:APP 将 SDK 回调的 token 传至商户服务器,商户服务器根据 token 从立木服务器请求结果数据.
 *
 *
 *  2\设置为 NO: 登录成功自动退出,不进入查询数据过程.
 *              优点:查询等待时间短,当登录成功后可继续查询其他数据.商户可在用户将其余各项数据查询完成后,再到立木服务器请求结果数据.
 *              注意:登录成功后,立木服务器仍在处理数据中,需要等待一段时间后,才能生成最终的结果数据.
 *              获取数据方式1:结果数据出来后,立木服务器会通知商户,此时商户服务器可从立木服务器请求数据
 *              获取数据方式2:APP 将 SDK 回调的 token 传至商户服务器,商户服务器根据 token 不定时从立木服务器请求结果数据.
 *
 * 3\默认 YES.
 */
@property (nonatomic,assign) BOOL lmzxQuitOnSuccess;


/*! @brief 查询失败时,自动退出SDK.
 *  默认 NO,失败后可继续查询
 */
@property (nonatomic,assign) BOOL lmzxQuitOnFail;


/*! @brief 查询结果回调,需实现用以监听,查询结果.
 * 状态码:
 * -6 用户退出
 * -5 商户信息错误
 * -4 用户输入错误
 * -3 网络异常
 * -2 系统异常
 * -1 其他异常
 * 0 查询成功
 * 1 查询中 // V1.2.2 新增
 * 2 登录成功
 */
@property (nonatomic,strong) LMZXResultBlock lmzxResultBlock;

/**
 * 请求参数回调 ,无须实现.
 */
@property (nonatomic,strong) LMZXAuthBlock lmzxAuthBlock;

/*! @brief 当前启动的 function
 */
@property (assign,nonatomic,readonly) LMZXSDKFunction lmzxFunction;

/**********************              **********************/
/********************** SDK UI 自定义 **********************/
/**********************              **********************/


/// 以下皆有默认设置.可根据需求修改


/*! @brief [A] 查询页面协议文字颜色,查询动画页面的动画/文字颜色,城市选择页面高亮颜色,搜索页面,汽车保险页面选中文字颜色,协议颜色
 */
@property (nonatomic,strong) UIColor *lmzxProtocolTextColor;

/*! @brief [B] 提交按钮颜色,验证码页面确认按钮颜色
 */
@property (nonatomic,strong) UIColor *lmzxSubmitBtnColor;

/*! @brief [C] 所有页面背景颜色
 */
@property (nonatomic,strong) UIColor *lmzxPageBackgroundColor;

/*! @brief [D] 导航条颜色
 */
@property (nonatomic,strong) UIColor *lmzxThemeColor;

/*! @brief [E] 标题栏: 返回按钮文字\图片颜色,标题颜色,刷新按钮颜色,提交按钮文字颜色
 */
@property (nonatomic,strong) UIColor *lmzxTitleColor;

/*! @brief 状态栏样式:默认白色
 */
@property (nonatomic,assign) LMZXStatusBarStyle lmzxStatusBarStyle;

/*! @brief 协议地址:
 */
@property (nonatomic,strong) NSString *lmzxProtocolUrl;

/*! @brief 协议名称:
 *  信用卡邮箱设置多个协议名,需要按照如下顺序,使用**进行拼接
 *  @"《163协议》**《126协议》**《qq协议》**《sina协议》**《139协议》"
 *  否则使用统一的 lmzxProtocolTitle
 */
@property (nonatomic,strong) NSString *lmzxProtocolTitle;

/*! @brief 提交按钮标题颜色.默认白色
*/
@property (nonatomic,strong) UIColor *lmzxSubmitBtnTitleColor;


/**********************     *******************************/
/********************** 方法 *******************************/
/**********************     *******************************/


/*! @brief SDK单例
 *
 */
+(LMZXSDK*)shared;


/*! @brief 1-> 注册 SDK
 *  注册 SDK , 在 application:  didFinishLaunchingWithOptions 中调用.
 */
+(void)registerLMZXSDK;

/*! @brief 2-> 初始化 SDK
 *  @param lmApikey 商户 apiKey
 *  @param lmUid 用户 ID
 *  @param callBackUrl 回调地址
 */
+(LMZXSDK *)lmzxSDKWithApikey:(NSString *)lmApikey
                              uid:(NSString *)lmUid
                      callBackUrl:(NSString *)callBackUrl;



/*! @brief 3-> 启动 SDK 功能
 *  @param function 启动的某个功能
 *  @param lmzxAuthBlock 授权回调
 */
-(void)startFunction:(LMZXSDKFunction)function authCallBack:(LMZXAuthBlock)lmzxAuthBlock;


/*! @brief 4-> 启动某个查询服务
 *  将签名信息传入 SDK.
 */
- (void)sendReqWithSign:(NSString *)sign;


/*! @brief 启动 SDK 功能
 *  @param function 启动的某个功能
 *  @param lmzxAuthBlock 加签，授权
 *  @param lmzxResultBlock 查询结果回调
 */
-(void)startFunction:(LMZXSDKFunction)function authCallBack:(LMZXAuthBlock)lmzxAuthBlock resultCallBack:(LMZXResultBlock)lmzxResultBlock;


/*! @brief 开启立木 SDK 日志
 *  默认为关闭
 */
- (void)unlockLog;


/**********************     *******************************/
/********************** 新需求 *******************************/
/**********************     *******************************/

////////////////// 运营商查询,预先传入参数 ////////////////////////
// 以下 需在初始化运营商模块之后, 启动运营商模块之前 设置

/*! @brief 预传手机号,传入前需要校验 OK.
 */
@property (nonatomic,strong) NSString * lmzxPreMobileNum;

/*! @brief 是否能修改预传的手机号, 默认YES, 可以修改
 */
@property (nonatomic,assign) BOOL lmzxAbleEditPreMobileNum;

////////////////// 运营商查询,商户可使用自定义的入参页面,启动 SDK 时,仅有动画查询页面////////////////////////
/*
 
 运营商参数约定:
 
 @{
 @"mobile":@"手机号",     //必传,不用编码加密,传入之前需校验格式正确.
 @"password":@"服务密码", //必传,不用编码加密.
 @"contentType":"all"   //必传,指定查询内容,默认all,可以指定多选,格式:sms;busi;net (sms:短信记录,busi:业务记录,net:上网记录).
 @"otherInfo":""   // 非必传,特殊城市例外: 北京移动:传入客服密码, 广西电信:传入身份证号码, 山西电信:传入身份证号码, 湖南电信:传入身份证号码
 @"identityCardNo":@"身份证号", // 非必传
 @"identityName":@"真实姓名",  // 非必传,某些特殊城市例外:山西电信,传入真实姓名
 @"mobileArea":@"格式:省+运营商(吉林电信)" //非必传,某些特殊城市例外:@"吉林电信" 必传.
 }
 
 注意: 以上非必传项若不传值, value请传入@"" 即可.
 */
-(void)startFunction:(LMZXSDKFunction)function preParameters:(NSDictionary*)paramDic authCallBack:(LMZXAuthBlock)lmzxAuthBlock;




@end








