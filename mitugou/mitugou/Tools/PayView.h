//  PayView.h
//  mitugou
//  Created by zhufeng on 2018/12/3.
//  Copyright © 2018 zhufeng. All rights reserved.

#import <UIKit/UIKit.h>
typedef void(^PayMethodBlock)(int payTag);
@interface PayView : UIView
/**
 支付的方法方式
 */
@property (nonatomic,copy)PayMethodBlock paymethodblock;
//显示
- (void)show;
@end
