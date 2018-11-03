//  ZFCustomView.h
//  xiaochacha
//  Created by apple on 2018/10/29.
//  Copyright © 2018 HuiC. All rights reserved.

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZFCustomView : UIView

/**
 只显示文字
 @param text 文字
 @param duration 时间
 */
+(void)showWithText:(NSString *)text WithDurations:(CGFloat)duration;

/**
 加载视图
 @param text 显示文字
 */
+(void)showWithStatus:(NSString *)text;

/**
 取消视图
 */
+(void)dismiss;

/**
 成功提示

 @param successSting 成功提示
 */
+(void)showWithSuccess:(NSString *)successSting;

/**
 失败提示

 @param errorString 失败提示
 */
+(void)showWithError:(NSString *)errorString;

@end

NS_ASSUME_NONNULL_END
