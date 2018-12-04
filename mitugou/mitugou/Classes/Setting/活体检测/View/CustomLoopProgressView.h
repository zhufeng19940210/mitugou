//  SDLoopProgressView.h
//  SDProgressView
//  Created by LiMu on 17/9/23.
//  Copyright © 2017年 hisign. All rights reserved.
#import <UIKit/UIKit.h>
#define SDColorMaker(r, g, b, a) [UIColor colorWithRed:((r) / 255.0) green:((g) / 255.0) blue:((b) / 255.0) alpha:(a)]
#define SDProgressLineWidth 10
#define SDProgressViewFontScale (MIN(self.frame.size.width, self.frame.size.height) / 100.0)
// 背景颜色
#define SDProgressViewBackgroundColor SDColorMaker(240, 240, 240, 0)


@interface CustomLoopProgressView : UIView

@property (nonatomic, assign) CGFloat progress;

- (id)initWithFrame:(CGRect)frame bgColor:(UIColor *)color;

- (void)dismiss;





@end

