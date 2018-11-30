//  UserModel.h
//  mitugou
//  Created by zhufeng on 2018/11/3.
//  Copyright © 2018年 zhufeng. All rights reserved.
#import <Foundation/Foundation.h>
@interface UserModel : NSObject
///创建时间
@property (nonatomic,copy)NSString *createtime;
///邀请人
@property (nonatomic,copy)NSString *inviter;
///登录密码
@property (nonatomic,copy)NSString *loginpassword;
///支付密码
@property (nonatomic,copy)NSString *palypassword;
///电话
@property (nonatomic,copy)NSString *phone;
///头像
@property (nonatomic,copy)NSString *photo;
///状态
@property (nonatomic,copy)NSString *state;
///uid
@property (nonatomic,copy)NSString *uid;
///用户名
@property (nonatomic,copy)NSString *username;

+ (void)save:(UserModel *)model;

+ (UserModel *)getInfo;

+ (BOOL)isOnline;

+ (void)logout;



@end
