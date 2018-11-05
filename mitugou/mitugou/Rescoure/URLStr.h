//  URLStr.h
//  mitugou
//  Created by zhufeng on 2018/11/3.
//  Copyright © 2018年 zhufeng. All rights reserved.

#ifndef URLStr_h
#define URLStr_h
#define BaseUrl @"http://106.12.192.149:8080"
///登录注册接口
#define User_Login_URL [BaseUrl stringByAppendingString:@"/Single/user/login"]
///注册接口
#define User_Register_URL [BaseUrl stringByAppendingString:@"/Single/user/register"]
///获取验证码
#define User_Get_Code [BaseUrl stringByAppendingString:@"/Single/user/code"]

#endif /* URLStr_h */
