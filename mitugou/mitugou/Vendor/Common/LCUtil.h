//
//  LCUtil.h
//  Bclient
//
//  Created by niecong on 2018/3/27.
//  Copyright © 2018年 niecong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonCryptor.h>
#import <CommonCrypto/CommonDigest.h>
#import <UIKit/UIKit.h>
@interface LCUtil : NSObject

//  MD5加密
+ (NSString *)MD5:(NSString *)str;

// 利用正则表达式验证密码
+ (BOOL)isValidatPassword:(NSString *)text;

// 利用正则表达式验证全是空格
+ (BOOL)isValidateAllSpace:(NSString *)text;

// 利用正则表达式验证email
+ (BOOL)isValidateEmail:(NSString *)email;

// 判断是否有效身份证号码
+(BOOL)isValidIDNumber:(NSString*)idnumber;

// 利用正则表达式验证手机号码
+ (BOOL)isMobileNumber:(NSString *)mobileNum;

// 利用正则表达式验证电信手机号码
+ (BOOL)isCTMobileNumber:(NSString *)mobileNum;

// 3DES加密解密
+ (NSString *)tripleDES:(NSString *)plainText encryptOrDecrypt:(CCOperation)encryptOrDecrypt key:(NSString *)key;

//根据宽度求高度  content 计算的内容  width 计算的宽度 font字体大小
//+ (float)getLabelHeightWithText:(NSString *)text width:(float)width font: (float)font;

//  保存，读取用户名、密码
+ (void)savePhone:(NSString *)phone andPwd:(NSString *)pwd;
+ (NSString *)getPhone;
+ (NSString *)getPwd;
+ (void)clearPhoneAndPwd;

+ (NSString*)getDocumentPath;
+ (NSString*)getDocumentFolderByName:(NSString *)foldername;
//时间戳转换成时间
+(NSString *)timestampSwitchTime:(NSString *)timeStr andFormatter:(NSString *)format;

+(NSString *)getImagePath:(UIImage *)Image;

//计算时间的工具类
+ (NSString *)setupCreateTime:(NSString *)timeStr;
//判断上午中午下午
+(NSString *)getTimeStr;
//判断网络请求
+(BOOL)isVaildNetWorkStatus;
@end
