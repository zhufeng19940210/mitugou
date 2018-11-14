//  UserModel.m
//  mitugou
//  Created by zhufeng on 2018/11/3.
//  Copyright © 2018年 zhufeng. All rights reserved.
#import "UserModel.h"
static NSString *UserModelKey = @"UserModelKey";
@interface UserModel()
@end
@implementation UserModel
+ (void)save:(UserModel *)model
{
    NSDictionary *user = model.mj_keyValues;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:user forKey:UserModelKey];
    [defaults synchronize];
}
+ (UserModel *)getInfo
{
    NSDictionary *dict = [[NSUserDefaults standardUserDefaults] objectForKey:UserModelKey];
    UserModel *user =[UserModel mj_objectWithKeyValues:dict];
    return user;
}
+ (BOOL)isOnline
{
    NSDictionary *dict = [[NSUserDefaults standardUserDefaults] objectForKey:UserModelKey];
    UserModel *user =[UserModel mj_objectWithKeyValues:dict];
    if (user.phone.length>0)
        return YES;
    return NO;
}
+ (void)logout
{
    NSDictionary *dict = [[NSUserDefaults standardUserDefaults] objectForKey:UserModelKey];
    UserModel *user =[UserModel mj_objectWithKeyValues:dict];
    user.phone = nil;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:user.mj_keyValues forKey:UserModelKey];
    [defaults synchronize];
}
@end
