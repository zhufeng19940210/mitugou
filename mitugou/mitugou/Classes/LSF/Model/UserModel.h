//  UserModel.h
//  mitugou
//  Created by zhufeng on 2018/11/3.
//  Copyright © 2018年 zhufeng. All rights reserved.
#import <Foundation/Foundation.h>

@interface UserModel : NSObject
//存放用户的字段
@property (nonatomic,copy)NSString *F_CreatorTime;
@property (nonatomic,copy)NSString *F_Id;
@property (nonatomic,copy)NSString *mobile;
@property (nonatomic,assign)NSInteger score;
@property (nonatomic,assign)NSInteger status;

+ (void)save:(UserModel *)model;

+ (UserModel *)getInfo;

+ (BOOL)isOnline;

+ (void)logout;

@end
