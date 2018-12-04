//
//  SDLoopProgressView.m
//  SDProgressView
//
//  Created by LiMu on 17/9/23.
//  Copyright © 2017年 hisign. All rights reserved.
//

#import "CustomLoopProgressView.h"

@implementation CustomLoopProgressView
{
    UIColor * _bgColor;
}

- (id)initWithFrame:(CGRect)frame bgColor:(UIColor *)color {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = SDProgressViewBackgroundColor;
        self.layer.cornerRadius = SDProgressLineWidth * 0.5;
        self.clipsToBounds = YES;
        _bgColor = color;
    }
    return self;
}

- (void)setProgress:(CGFloat)progress {
    _progress = progress;
    
    if (progress > 1.0) {
        [self removeFromSuperview];
    } else {
        [self setNeedsDisplay];
    }
    
    
}

// 清除指示器
- (void)dismiss {
    self.progress = 1.0;
}

- (void)drawRect:(CGRect)rect {
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGFloat xCenter = rect.size.width * 0.5;
    CGFloat yCenter = rect.size.height * 0.5;
    [_bgColor set];
    
    CGContextSetLineWidth(ctx, SDProgressLineWidth);
    CGContextSetLineCap(ctx, kCGLineCapRound);
    CGFloat to = - M_PI * 0.5 + self.progress * M_PI * 2 + 0.05; // 初始值0.05
    CGFloat radius = MIN(rect.size.width, rect.size.height) * 0.5 - SDProgressLineWidth * 0.5;
    CGContextAddArc(ctx, xCenter, yCenter, radius, - M_PI * 0.5, to, 0);
    CGContextStrokePath(ctx);
}

@end

