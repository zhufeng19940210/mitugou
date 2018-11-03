//  LCUtil.m
//  Bclient
//  Created by niecong on 2018/3/27.
//  Copyright © 2018年 niecong. All rights reserved.
#import "LCUtil.h"
#include <sys/sysctl.h>
#import <CoreText/CoreText.h>
#import <QuartzCore/QuartzCore.h>
#import <CoreTelephony/CTCarrier.h>
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import "Reachability.h"
static NSString *tripleDESKey = @"TripleKey";
static BOOL _isReachable = NO;
@implementation LCUtil
//  MD5加密
+ (NSString *)MD5:(NSMutableString *)str
{
    if (str == nil || [str length] <= 0) {
        return nil;
    }
    
    const char *cStr = [str UTF8String];
    unsigned char result[32];
    CC_MD5( cStr, strlen(cStr), result);
    return [NSString stringWithFormat:@"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];
}

// 利用正则表达式验证密码
+ (BOOL)isValidatPassword:(NSString *)text
{
    NSString *pwdRegex = @"(?=.*[\\d]+)(?=.*[a-zA-Z]+)(?=.*[^a-zA-Z0-9]+).{8,20}";
    NSPredicate *pwdTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pwdRegex];
    return [pwdTest evaluateWithObject:text];
}

// 利用正则表达式验证全是空格
+ (BOOL)isValidateAllSpace:(NSString *)text
{
    NSString *allSpaceRegex = @"^\\s+$";
    NSPredicate *allSpaceTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", allSpaceRegex];
    return [allSpaceTest evaluateWithObject:text];
}

// 利用正则表达式验证email
+ (BOOL)isValidateEmail:(NSString *)email
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}

// 判断是否有效身份证号码
+ (BOOL)isValidIDNumber:(NSString*)idnumber
{
    if ([idnumber length] != 15 &&
        [idnumber length] != 18)
    {
        return NO;
    }
    
    NSLog(@"%@",idnumber);
    int provCode = [[idnumber substringToIndex:2] intValue];
    if ( provCode < 11  ||
        (provCode > 15    &&    provCode < 21)    ||
        (provCode > 23    &&    provCode < 31)    ||
        (provCode > 37    &&    provCode < 41)    ||
        (provCode > 46    &&    provCode < 50)    ||
        (provCode > 54    &&    provCode < 61)    ||
        (provCode > 65)    )
    {
        // 行政区码错误
        NSLog(@"province code error");
        return NO;
    }
    
    int len = [idnumber length];
    int year = 0;
    int month = 0;
    int day = 0;
    if (len == 15)
    {
        year = [[idnumber substringWithRange:NSMakeRange(6, 2)] intValue];
        if (year > 20)
        {
            year = 1900 + year;
        }
        else
        {
            year = 2000 + year;
        }
        
        month = [[idnumber substringWithRange:NSMakeRange(8, 2)] intValue];
        day = [[idnumber substringWithRange:NSMakeRange(10, 2)] intValue];
    }
    else if (len == 18)
    {
        year = [[idnumber substringWithRange:NSMakeRange(6, 4)] intValue];
        month = [[idnumber substringWithRange:NSMakeRange(10, 2)] intValue];
        day = [[idnumber substringWithRange:NSMakeRange(12, 2)] intValue];
    }
    if (year < 1900 ||
        year > 2200)
    {
        // 年份错误
        NSLog(@"year error");
        return NO;
    }
    
    if (month < 1 ||
        month > 12)
    {
        // 月份错误
        NSLog(@"month error");
        return NO;
    }
    
    if (day < 1 ||
        day > 31)
    {
        // 日期错误
        NSLog(@"day error");
        return NO;
    }
    
    // 检查最后一位
    NSRange xrange = [idnumber rangeOfString:@"x"];
    NSRange Xrange = [idnumber rangeOfString:@"X"];
    if ((xrange.length == 1 && xrange.location != len - 1)    ||
        (Xrange.length == 1 && Xrange.location != len - 1))
    {
        NSLog(@"x position error");
        return NO;
    }
    
    if (len == 15)
    {
        return YES;
    }
    
    int Wi[17] = {7, 9, 10, 5, 8 ,4, 2, 1, 6, 3, 7, 9, 10, 5, 8, 4, 2};
    int lastBit[11] = {1, 0, 'x', 9, 8, 7, 6, 5, 4, 3, 2};
    int sum = 0;
    NSMutableString * idnum18 = [[NSMutableString alloc] initWithString:idnumber];
    
    for (int i = 0; i < 17; i++)
    {
        int nVal = [[idnum18 substringWithRange:NSMakeRange(i, 1)] intValue];
        sum += nVal*Wi[i];
    }
    
    int ret = sum%11;
    NSLog(@"ret=%d",ret);
    if ((ret == 2 && [[[idnum18 substringWithRange:NSMakeRange(17, 1)] lowercaseString] isEqualToString:@"x"])    ||
        lastBit[ret] == [[idnum18 substringWithRange:NSMakeRange(17, 1)] intValue])
    {
        //        [idnum18 release];
        return YES;
    }
    else
    {
        // 校验码错误
        NSLog(@"verify code error");
        //        [idnum18 release];
        return NO;
    }
    
    //    [idnum18 release];
    return NO;
}

// 利用正则表达式验证手机号码
+ (BOOL)isMobileNumber:(NSString *)mobileNum
{
    /**
     * 手机号码
     * 移动：134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     * 联通：130,131,132,152,155,156,185,186
     * 电信：133,1349,153,180,181,189
     */
    NSString * MOBILE = @"^1(3[0-9]|5[0-35-9]|8[025-9])\\d{8}$";
    /**
     10         * 中国移动：China Mobile
     11         * 134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     12         */
    NSString * CM = @"^1(34[0-8]|(3[5-9]|5[017-9]|8[278])\\d)\\d{7}$";
    /**
     15         * 中国联通：China Unicom
     16         * 130,131,132,152,155,156,185,186
     17         */
    NSString * CU = @"^1(3[0-2]|5[256]|8[56])\\d{8}$";
    /**
     20         * 中国电信：China Telecom
     21         * 133,1349,153,180,181,189
     22         */
    NSString * CT = @"^1((33|53|8[019])[0-9]|349)\\d{7}$";
    /**
     25         * 大陆地区固话及小灵通
     26         * 区号：010,020,021,022,023,024,025,027,028,029
     27         * 号码：七位或八位
     28         */
    // NSString * PHS = @"^0(10|2[0-5789]|\\d{3})\\d{7,8}$";
    
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    
    if (([regextestmobile evaluateWithObject:mobileNum] == YES)
        || ([regextestcm evaluateWithObject:mobileNum] == YES)
        || ([regextestct evaluateWithObject:mobileNum] == YES)
        || ([regextestcu evaluateWithObject:mobileNum] == YES))
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

// 利用正则表达式验证电信手机号码
+ (BOOL)isCTMobileNumber:(NSString *)mobileNum
{
    /**
     20         * 中国电信：China Telecom
     21         * 133,1349,153,180,181,189
     22         */
    NSString * CT = @"^1((33|53|8[019])[0-9]|349)\\d{7}$";
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    if ([regextestct evaluateWithObject:mobileNum] == YES)
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

//  3DES
+ (NSString *)tripleDES:(NSString *)plainText encryptOrDecrypt:(CCOperation)encryptOrDecrypt key:(NSString *)key
{
    const void *vplainText;
    size_t plainTextBufferSize;
    
    if (encryptOrDecrypt == kCCDecrypt)
    {
        // hexToBytes
        NSMutableData *data = [NSMutableData data];
        int idx;
        for (idx = 0; idx+2 <= plainText.length; idx+=2) {
            NSRange range = NSMakeRange(idx, 2);
            NSString *hexStr = [plainText substringWithRange:range];
            NSScanner *scanner = [NSScanner scannerWithString:hexStr];
            unsigned int intValue;
            [scanner scanHexInt:&intValue];
            [data appendBytes:&intValue length:1];
        }
        
        NSData *EncryptData = data;
        plainTextBufferSize = [EncryptData length];
        vplainText = [EncryptData bytes];
    }
    else
    {
        NSData *data = [plainText dataUsingEncoding:NSUTF8StringEncoding];
        plainTextBufferSize = [data length];
        vplainText = (const void *)[data bytes];
    }
    
    CCCryptorStatus ccStatus;
    uint8_t *bufferPtr = NULL;
    size_t bufferPtrSize = 0;
    size_t movedBytes = 0;
    // uint8_t ivkCCBlockSize3DES;
    
    bufferPtrSize = (plainTextBufferSize + kCCBlockSize3DES) & ~(kCCBlockSize3DES - 1);
    bufferPtr = malloc( bufferPtrSize * sizeof(uint8_t));
    memset((void *)bufferPtr, 0x0, bufferPtrSize);
    
    NSString *initVec = @"init Vec";
    const void *vkey = (const void *) [key UTF8String];
    const void *vinitVec = (const void *) [initVec UTF8String];
    
    ccStatus = CCCrypt(encryptOrDecrypt,
                       kCCAlgorithm3DES,
                       kCCOptionECBMode|kCCOptionPKCS7Padding,
                       vkey,
                       kCCKeySize3DES,
                       vinitVec,
                       vplainText,
                       plainTextBufferSize,
                       (void *)bufferPtr,
                       bufferPtrSize,
                       &movedBytes);
    NSLog(@"ccStatus:%d. \"0 is success\"", ccStatus);
    
    NSString *result;
    
    if (encryptOrDecrypt == kCCDecrypt)
    {
        result = [[NSString alloc] initWithData:[NSData dataWithBytes:(const void *)bufferPtr
                                                               length:(NSUInteger)movedBytes]
                                       encoding:NSUTF8StringEncoding];
    }
    else
    {
        NSData *myData = [NSData dataWithBytes:(const void *)bufferPtr length:(NSUInteger)movedBytes];
        
        Byte *myByte = (Byte *)[myData bytes];
        NSMutableString *tResult = [NSMutableString string];
        NSMutableString *newHexStr = [NSMutableString string];
        for (int i = 0 ; i < [myData length]; i++) {
            [newHexStr setString:[NSString stringWithFormat:@"%x", myByte[i]&0xff]];
            if([newHexStr length] == 1) {
                [tResult appendFormat:@"0%@", newHexStr];
            }
            else {
                [tResult appendString:newHexStr];
            }
        }
        result = tResult;
        
        result = [result uppercaseString];
    }
    free(bufferPtr);
    
    return result;
}

//  保存，读取用户名、密码
+ (void)savePhone:(NSString *)phone andPwd:(NSString *)pwd
{
    NSUserDefaults *settings = [NSUserDefaults standardUserDefaults];
    if (phone) {
        [settings setObject:[self tripleDES:phone encryptOrDecrypt:kCCEncrypt key:tripleDESKey] forKey:@"Phone"];
    }
    if (pwd) {
        [settings setObject:[self tripleDES:pwd encryptOrDecrypt:kCCEncrypt key:tripleDESKey] forKey:@"Password"];
    }
    [settings synchronize];
}

+ (NSString *)getPhone
{
    NSUserDefaults *settings = [NSUserDefaults standardUserDefaults];
    if ([settings objectForKey:@"Phone"] && [[settings objectForKey:@"Phone"] length]>0) {
        return [self tripleDES:[settings objectForKey:@"Phone"] encryptOrDecrypt:kCCDecrypt key:tripleDESKey];
    }
    else
    {
        return @"";
    }
}

+ (NSString *)getPwd
{
    NSUserDefaults *settings = [NSUserDefaults standardUserDefaults];
    if ([settings objectForKey:@"Password"] && [[settings objectForKey:@"Password"] length]>0) {
        return [self tripleDES:[settings objectForKey:@"Password"] encryptOrDecrypt:kCCDecrypt key:tripleDESKey];
    }
    else
    {
        return @"";
    }
}

+ (void)clearPhoneAndPwd
{
    NSUserDefaults *settings = [NSUserDefaults standardUserDefaults];
    [settings removeObjectForKey:@"Phone"];
    [settings removeObjectForKey:@"Password"];
    [settings synchronize];
}

+ (NSString*)getDocumentPath
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    return documentsDirectory;
}

+ (NSString*)getDocumentFolderByName:(NSString *)foldername
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                         NSUserDomainMask,
                                                         YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    if ([foldername length])
    {
        documentsDirectory = [documentsDirectory stringByAppendingPathComponent:foldername];
    }
    
    NSFileManager* fileMgr = [NSFileManager defaultManager];
    BOOL isDir = YES;
    if (![fileMgr fileExistsAtPath:documentsDirectory isDirectory:&isDir])
    {
        [fileMgr createDirectoryAtPath:documentsDirectory withIntermediateDirectories:YES attributes:nil error:nil];
    }
    return documentsDirectory;
}

//时间戳转换成时间
+(NSString *)timestampSwitchTime:(NSString *)timeStr andFormatter:(NSString *)format{
    NSTimeInterval _interval=[timeStr doubleValue];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:_interval];
    NSDateFormatter *objDateformat = [[NSDateFormatter alloc] init];
    [objDateformat setDateFormat:format];
    NSString *currentDateStr = [objDateformat stringFromDate: date];
    return currentDateStr;
}


//照片获取本地路径转换
+(NSString *)getImagePath:(UIImage *)Image {
    NSString *filePath = nil;
    NSData *data = nil;
    if (UIImagePNGRepresentation(Image) == nil) {
        data = UIImageJPEGRepresentation(Image, 1.0);
    } else {
        data = UIImagePNGRepresentation(Image);
    }
    //图片保存的路径
    //这里将图片放在沙盒的documents文件夹中
    NSString *DocumentsPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    //文件管理器
    NSFileManager *fileManager = [NSFileManager defaultManager];
    //把刚刚图片转换的data对象拷贝至沙盒中
    [fileManager createDirectoryAtPath:DocumentsPath withIntermediateDirectories:YES attributes:nil error:nil];
    NSString *ImagePath = [[NSString alloc] initWithFormat:@"/theFirstImage.png"];
    [fileManager createFileAtPath:[DocumentsPath stringByAppendingString:ImagePath] contents:data attributes:nil];
    //得到选择后沙盒中图片的完整路径
    filePath = [[NSString alloc] initWithFormat:@"%@%@", DocumentsPath, ImagePath];
    return filePath;
}

//判断网络请求
+(BOOL)isVaildNetWorkStatus
{
    BOOL _isReachable = NO;
    Reachability *reach = [Reachability reachabilityWithHostName:@"www.apple.com"];
    switch ([reach currentReachabilityStatus]) {
        case NotReachable:// 没有网络
        {
            _isReachable = NO;
        }
            break;
            
        case ReachableViaWiFi:// Wifi
        {
            _isReachable = YES;
        }
            break;
            
        case ReachableViaWWAN:// 手机自带网络
        {
            _isReachable = YES;
        }
            break;
            
        default:
            break;
    }
    
    return _isReachable;
}
//+ (NSString *)setupCreateTime:(NSString *)timeStr {
//    
//    NSTimeInterval _interval=[timeStr doubleValue];
//    NSDate *date = [NSDate dateWithTimeIntervalSince1970:_interval];
//    // NSDateFormatter:NSString与NSDate互转
//    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
//    [fmt setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
//    NSString *currentDateStr = [fmt stringFromDate:date];
//    /*
//     // 如果我们得到的是其他地区时间格式，需要设置locale（我们获得的一开始是欧美时间，所以说这里写 en_US）
//     fmt.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
//     
//     // 设置日期格式（声明字符串里面每个数字和单词的含义）
//     fmt.dateFormat = @"EEE MMM dd HH:mm:ss Z yyyy"; // 因为我们直接获得到的_created_at是欧美时间(NSString类型，无法直接使用)，所以要先用欧美格式将我们获得到的字符串转化为NSDate，然后再设置一次格式，将NSDate转化成为字符串格式
//     
//     // 微博的创建日期（将_created_at字符串对象转化成为NSDate对象）
//     NSDate *createDateUS = [fmt dateFromString:timeStr]; // 此时
//     
//     // 再次设置日期格式（然后再通过这个日期格式去处理时间字符串）
//     fmt.dateFormat = @"yyyy-MM-dd HH:mm:ss";
//     */
//    // 设置格式
//    // 发布日期对象
//    NSDate *createDate = [fmt dateFromString:currentDateStr];
//    
//    // 处理时间(用帖子发布时间与当前时间比较)
//    // 判断是否是今年 年份是否相等 => 获取日期年份 => 日历,获取日期组件
//    // 获取帖子发布时间与当前时间差值
//    NSCalendar *calendar = [NSCalendar currentCalendar];
//    
//    // 获取两个日期差值
//    NSDateComponents *cmp = [calendar components:NSCalendarUnitHour | NSCalendarUnitMinute  fromDate:createDate toDate:[NSDate date] options:NSCalendarWrapComponents];
//    
//    
//    if ([createDate isThisYear]) {
//        if ([createDate isThisToday]) {
//            
//            // 获取日期差值
//            if (cmp.hour >= 1) {
//                timeStr = [NSString stringWithFormat:@"%ld小时前",cmp.hour];
//            } else if (cmp.minute >= 2) {
//                timeStr = [NSString stringWithFormat:@"%ld分钟前",cmp.minute];
//            } else { // 刚刚
//                timeStr = @"刚刚";
//            }
//        } else if ([createDate isThisYesterday]) { // 昨天
//            // 昨天 21:10
//            fmt.dateFormat = @"昨天 HH:mm";
//            timeStr = [fmt stringFromDate:createDate];
//            
//        } else { // 今年的其他日子
//            fmt.dateFormat = @"yyyy-MM-dd";
//            timeStr = [fmt stringFromDate:createDate];
//        }
//    } else { // 非今年
//        fmt.dateFormat = @"yyyy-MM-dd";
//        timeStr = [fmt stringFromDate:createDate];
//    }
//    
//    return timeStr;
//}
////判断上午中午下午
//+(NSString *)getTimeStr{
//    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
//    [formatter setDateFormat:@"HH"];
//    NSString *str = [formatter stringFromDate:[NSDate date]];
//    int time = [str intValue];
//    NSString *timeStr = nil;
//    switch (time) {
//        case 0:
//        {
//            timeStr = @"早上好";
//        }
//            break;
//        case 1:
//        {
//            timeStr = @"早上好";
//        }
//            break;
//        case 2:
//        {
//            timeStr = @"早上好";
//        }
//            break;
//        case 3:
//        {
//            timeStr = @"早上好";
//        }
//            break;
//        case 4:
//        {
//            timeStr = @"早上好";
//        }
//            break;
//        case 5:
//        {
//            timeStr = @"早上好";
//        }
//            break;
//        case 6:
//        {
//            timeStr = @"早上好";
//        }
//            break;
//        case 7:
//        {
//            timeStr = @"早上好";
//        }
//            break;
//        case 8:
//        {
//            timeStr = @"上午好";
//        }
//            break;
//        case 9:
//        {
//            timeStr = @"上午好";
//        }
//            break;
//        case 10:
//        {
//            timeStr = @"上午好";
//        }
//            break;
//        case 11:
//        {
//            timeStr = @"上午好";
//        }
//            break;
//        case 12:
//        {
//            timeStr = @"中午好";
//        }
//            break;
//        case 13:
//        {
//             timeStr = @"下午好";
//        }
//            break;
//        case 14:
//        {
//             timeStr = @"下午好";
//        }
//            break;
//        case 15:
//        {
//             timeStr = @"下午好";
//        }
//            break;
//        case 16:
//        {
//             timeStr = @"下午好";
//        }
//            break;
//        case 17:
//        {
//             timeStr = @"下午好";
//        }
//            break;
//        case 18:
//        {
//             timeStr = @"下午好";
//        }
//            break;
//        case 19:
//        {
//             timeStr = @"晚上好";
//        }
//            break;
//        case 20:
//        {
//            timeStr = @"晚上好";
//        }
//            break;
//        case 21:
//        {
//            timeStr = @"晚上好";
//        }
//            break;
//        case 22:
//        {
//            timeStr = @"晚上好";
//        }
//            break;
//        case 23:
//        {
//            timeStr = @"晚上好";
//        }
//            break;
//            
//        case 24:
//        {
//            timeStr = @"晚上好";
//        }
//            break;
//            
//        default:
//            break;
//    }
//    return timeStr;
//}

@end
