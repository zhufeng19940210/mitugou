//  NetWorkTool.m
//  xiaochacha
//  Created by apple on 2018/10/31.
//  Copyright © 2018 HuiC. All rights reserved.

#import "NetWorkTool.h"
static NetWorkTool *tool = nil;
AFHTTPSessionManager *session = nil;
@implementation NetWorkTool
+(instancetype)shareInstacne{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        tool = [[NetWorkTool alloc]init];
        session = [AFHTTPSessionManager manager];
        // 设置超时时间
        [session.requestSerializer willChangeValueForKey:@"timeoutInterval"];
        session.requestSerializer.timeoutInterval = 10.0f;
        [session.requestSerializer didChangeValueForKey:@"timeoutInterval"];
        // 接收的输入类型
        session.responseSerializer = [AFHTTPResponseSerializer serializer];
        session.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/html", @"text/html",@"image/jpeg",@"image/png",@"application/octet-stream",@"text/json", nil];
        AFJSONResponseSerializer *response = [AFJSONResponseSerializer serializer];
        response.removesKeysWithNullValues = YES;//去除空值
        session.responseSerializer = response;//申明返回的结果是json
    });
    return tool;
}
/**
 *  发送get请求
 *
 *  @param url  请求的网址字符串
 *  @param soapStr 请求的参数
 *  @param success    请求成功的回调
 *  @param failure    请求失败的回调
 */

- (void)getWithURLString:(NSString *)url
              parameters:(NSDictionary *)soapStr
                 success:(void (^)(id responseObject))success
                 failure:(void (^)(NSError *error))failure
{
    [session GET:url parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (error) {
            failure(error);
        }
    }];
}
/**
 *  发送post请求
 *
 *  @param url  请求的网址字符串
 *  @param soapStr 请求的参数
 *  @param success    请求成功的回调
 *  @param failure    请求失败的回调
 */
- (void)postWithURLString:(NSString *)url
               parameters:(NSDictionary *)soapStr
                  success:(void (^)(id responseObject))success
                  failure:(void (^)(NSError *error))failure
{
    [session POST:url parameters:soapStr progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (error) {
            failure(error);
        }
    }];
}
/**
 *  发送网络请求
 *
 *  @param url   请求的网址字符串
 *  @param soapStr  请求的参数
 *  @param type        请求的类型
 *  @param failure 请求的结果
 */
- (void)requestWithURLString:(NSString *)url
                  parameters:(NSDictionary *)soapStr
                        type:(HttpRequestType)type
                     success:(void (^)(NSDictionary *dic))success
                     failure:(void (^)(NSError * error))failure
{
    NSMutableDictionary *patrmDic = [NSMutableDictionary dictionaryWithDictionary:soapStr];
    NSString *jsonStr = [JsonTool dictionaryToJson:patrmDic];
    NSLog(@"jsonStr:%@",jsonStr);
    switch (type) {
        case HttpRequestTypeGet:
        {
            [ZFCustomView showWithStatus:@""];
            [session GET:url parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                [ZFCustomView dismiss];
                if (success) {
                    success(responseObject);
                }
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                [ZFCustomView dismiss];
                if (error) {
                    failure(error);
                }
            }];
        }
            break;
        case HttpRequestTypePost:
        {   [ZFCustomView showWithStatus:@""];
            [session POST:url parameters:@{@"json":jsonStr} progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//                NSDictionary *dic1 = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers | NSJSONReadingMutableLeaves error:nil];
//                NSString *Str = [JsonTool dictionaryToJson:dic1];
//                NSLog(@"jsonStr:%@",Str);
                [ZFCustomView dismiss];
                if (success) {
                    success(responseObject);
                }
                
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                [ZFCustomView dismiss];
                if (failure) {
                    failure(error);
                }
            }];
        }
            break;
        default:
            break;
    }
}

@end
