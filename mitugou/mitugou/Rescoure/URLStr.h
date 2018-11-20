//  URLStr.h
//  mitugou
//  Created by zhufeng on 2018/11/3.
//  Copyright © 2018年 zhufeng. All rights reserved.
#ifndef URLStr_h
#define URLStr_h
#define BaseUrl @"http://47.93.238.67:9999/htshop"
/*==========================需要的字段=======================*/
#define User_AreaLeft       @"areaLeft"
#define User_AreaRight      @"areaRight"
#define User_HotLeft        @"hotLeft"
#define User_HotRightDown   @"hotRightDown"
#define User_HotRightUp     @"hotRightUp"
#define User_Recommend1     @"recommend1"
#define User_Recommend2     @"recommend2"
#define User_Recommend3     @"recommend3"
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
/*================================地址信息===============================*/
///查找全部的地址
#define Userinfo_Address_FindAll [BaseUrl stringByAppendingString:@"/address/findbyAll"]
///添加一个收货地址
#define Userinfo_Address_Add [BaseUrl stringByAppendingString:@"/address/addbyId"]
///删除收货地址
#define Userinfo_Address_Del [BaseUrl stringByAppendingString:@"/address/deletebyId"]
///修改收货地址
#define Userinfo_Address_Update [BaseUrl stringByAppendingString:@"/address/updatebyid"]
///设置默认地址
#define Userinfo_Address_Default [BaseUrl stringByAppendingString:@"/address/defaultStatus"]
/*================================商品信息===============================*/
///商品分类
#define Product_All [BaseUrl stringByAppendingString:@"/commodiry/getclassify"]
///分页查询
///tid = 1 手机  tid  == 2 机车 tid == 3 水果 tid ==4 配件
#define Userinfo_Cat_All [BaseUrl stringByAppendingString:@"/commodiry/byPages"]
///商品详情
#define Product_Detail  [BaseUrl stringByAppendingString:@"/commodiry/getdetail"]
/*================================首页信息===============================*/
///需要的图片
#define Home_Index [BaseUrl stringByAppendingString:@"/other/getuploadMap"]
///系统消息
#define Home_SystemInfo [BaseUrl stringByAppendingString:@"/other/getsystemInfo"]
///轮播图片
#define Home_Banner   [BaseUrl stringByAppendingString:@"/other/getsowingMap"]
/*================================支付方式===============================*/
///支付宝支付方法
#define Pay_Alipay [BaseUrl stringByAppendingString:@"/commodiry/showAll"]
///微信支付
#define Pay_Wechat [BaseUrl stringByAppendingString:@"/commodiry/showAll"]


#endif /* URLStr_h */
