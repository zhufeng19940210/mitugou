//  ZFCustomView.m
//  xiaochacha
//  Created by apple on 2018/10/29.
//  Copyright © 2018 HuiC. All rights reserved.

#import "ZFCustomView.h"
@interface ZFCustomView()
@end
@implementation ZFCustomView
static ZFCustomView *Hud = nil;
/**
 只显示文字
 @param text 文字
 @param duration 时间
 */
+(void)showWithText:(NSString *)text WithDurations:(CGFloat)duration
{   //添加背景
    ZFCustomView * custom = [[ZFCustomView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    [[UIApplication sharedApplication].keyWindow addSubview:custom];
    //添加提示框
    UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width/2-65, [UIScreen mainScreen].bounds.size.height/2-20, 130, 40)];
    label.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.8];
    label.text = text;
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont boldSystemFontOfSize:14];
    label.textColor = [UIColor whiteColor];
    [custom addSubview:label];
    label.layer.masksToBounds=YES;
    label.layer.cornerRadius=10;
    //视图消失
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(duration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [custom removeFromSuperview];
    });
}

/**
 加载视图
 @param text 显示文字
 */
+(void)showWithStatus:(NSString *)text
{
    ZFCustomView * custom = [[ZFCustomView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    Hud=custom;
    [[UIApplication sharedApplication].keyWindow addSubview:custom];
    UIView * customView = [[UIView alloc]initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width/2-75, [UIScreen mainScreen].bounds.size.height/2-50, 150, 120)];
    customView.backgroundColor = [UIColor whiteColor];
    [custom addSubview:customView];
    customView.layer.masksToBounds = YES;
    customView.layer.cornerRadius=10;
    UIImageView *heartImageView = [[UIImageView alloc]initWithFrame:CGRectMake(customView.frame.size.width/2-50, 10,100, 95)];
    [customView addSubview:heartImageView];
    NSMutableArray *images = [[NSMutableArray alloc]initWithCapacity:7];
    for (int i=1; i<=7; i++)
    {
        [images addObject:[UIImage imageNamed:[NSString stringWithFormat:@"%d.png",i]]];
    }
    heartImageView.animationImages = images;
    heartImageView.animationDuration = 1.0;
    heartImageView.animationRepeatCount = MAXFLOAT;
    [heartImageView startAnimating];
    
    UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(customView.frame.size.width/2-50, 80, 100, 40)];
    label.text = text;
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont boldSystemFontOfSize:16];
    label.textColor = [UIColor whiteColor];
    [customView addSubview:label];
    
}

+(void)showWithSuccess:(NSString*)successString//成功提示
{
    ZFCustomView * custom = [[ZFCustomView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    Hud=custom;
    [[UIApplication sharedApplication].keyWindow addSubview:custom];
    
    
    UIView * customView = [[UIView alloc]initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width/2-75, [UIScreen mainScreen].bounds.size.height/2-50, 150, 100)];
    customView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    [custom addSubview:customView];
    customView.layer.masksToBounds = YES;
    customView.layer.cornerRadius=10;
    UIImageView *heartImageView = [[UIImageView alloc]initWithFrame:CGRectMake(customView.frame.size.width/2-20, 15,40, 40.0)];
    heartImageView.contentMode=1;
    [customView addSubview:heartImageView];
    heartImageView.image = [UIImage imageNamed:@"成功图片"];
    
    UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(customView.frame.size.width/2-50, 55, 100, 40)];
    label.text = successString;
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont boldSystemFontOfSize:16];
    label.textColor = [UIColor whiteColor];
    [customView addSubview:label];
    
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [custom removeFromSuperview];
    });
}

/**
 取消视图
 */
+(void)dismiss{
 
    [Hud removeFromSuperview];
}

/**
 失败提示
 
 @param errorString 失败提示
 */
+(void)showWithError:(NSString *)errorString
{
    ZFCustomView * custom = [[ZFCustomView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    Hud=custom;
    [[UIApplication sharedApplication].keyWindow addSubview:custom];
    
    
    UIView * customView = [[UIView alloc]initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width/2-75, [UIScreen mainScreen].bounds.size.height/2-50, 150, 100)];
    customView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    [custom addSubview:customView];
    customView.layer.masksToBounds = YES;
    customView.layer.cornerRadius=10;
    UIImageView *heartImageView = [[UIImageView alloc]initWithFrame:CGRectMake(customView.frame.size.width/2-20, 15,40, 40.0)];
    heartImageView.contentMode=1;
    [customView addSubview:heartImageView];
    heartImageView.image = [UIImage imageNamed:@"失败图片"];
    
    UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(customView.frame.size.width/2-50, 55, 100, 40)];
    label.text = errorString;
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont boldSystemFontOfSize:16];
    label.textColor = [UIColor whiteColor];
    [customView addSubview:label];
    
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [custom removeFromSuperview];
    });
}

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self=[super initWithFrame:frame])
    {
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.2];
    }
    return self;
}


@end
