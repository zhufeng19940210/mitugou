//  URLStr.h
//  mitugou
//  Created by zhufeng on 2018/11/3.
//  Copyright © 2018年 zhufeng. All rights reserved.
#ifndef URLStr_h
#define URLStr_h
#define BaseUrl @"http://47.93.238.67:9999/htshop"
/*========================用户登录注册=====================*/
///登录注册接口
#define User_Login_URL [BaseUrl stringByAppendingString:@"/userAuthentication/login"]
///注册接口
#define User_Register_URL [BaseUrl stringByAppendingString:@"/userAuthentication/register"]
///获取验证码
#define User_Get_Code [BaseUrl stringByAppendingString:@"/userAuthentication/Veritycode"]
/*========================用户的基本信息=====================*/
///修改用户基本信息
#define Userinfo_Base_Url_update [BaseUrl stringByAppendingString:@"/userInfoForm/modifybaseinfo"]
///查找用户基本信息
#define Userinfo_Base_Url_Find [BaseUrl stringByAppendingString:@"/userInfoForm/findbaseinfo"]
///修改个人信息
#define Userinfo_Sigle_Url_Update [BaseUrl stringByAppendingString:@"/userInfoForm/modifypersonal"]
///查找个人信息
#define Userinfo_Sigle_Url_Find [BaseUrl stringByAppendingString:@"/userInfoForm/findpersonalinfo"]
///修改用户工作信息
#define Userinfo_Work_Url_Update [BaseUrl stringByAppendingString:@"/userInfoForm/modifyjob"]
///查找用户工作信息
#define Userinfo_Work_Url_Find [BaseUrl stringByAppendingString:@"/userInfoForm/findJobinfo"]
///修改用户联系信息
#define Userinfo_Contact_Url_Update [BaseUrl stringByAppendingString:@"/userInfoForm/modifycontact"]
///查找用户联系信息
#define Userinfo_Contact_Url_Find [BaseUrl stringByAppendingString:@"/userInfoForm/findcontactinfo"]
///修改用户身份证相片
#define Userinfo_Card_Url_Update [BaseUrl stringByAppendingString:@"/userInfoForm/saveIdcard"]
///查找用户身份证相片
#define Userinfo_Card_Url_Find [BaseUrl stringByAppendingString:@"/userInfoForm/byIdcardimg"]
///修改阿里支付信息
#define Userinfo_Ali_Url_Update [BaseUrl stringByAppendingString:@"/borrowAuthentication/modifyalipayAuth"]
///查找阿里支付信息
#define Userinfo_Ali_Url_Find [BaseUrl stringByAppendingString:@"/borrowAuthentication/findalipay"]
///修改银行卡信息
#define Userinfo_bankAuthen_Url_Update [BaseUrl stringByAppendingString:@"/borrowAuthentication/modifybankAuthen"]
///查找银行卡信息
#define Userinfo_bankAuthen_Url_Find [BaseUrl stringByAppendingString:@"/borrowAuthentication/findbank"]
///修改运营商信息
#define Userinfo_PersonalAuth_Url_Update [BaseUrl stringByAppendingString:@"/borrowAuthentication/modifypersonalAuth"]
///查找运营商信息
#define Userinfo_PersonalAuth_Url_Find [BaseUrl stringByAppendingString:@"/borrowAuthentication/findpersonal"]
#endif /* URLStr_h */
