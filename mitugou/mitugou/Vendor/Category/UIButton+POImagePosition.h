//
//  UIButton+POImagePosition.h
//  Bclient
//
//  Created by niecong on 2018/4/7.
//  Copyright © 2018年 niecong. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, POImagePosition) {
    POImagePositionLeft   = 0,
    POImagePositionRight  = 1,
    POImagePositionTop    = 2,
    POImagePositionBottom = 3,
};

@interface UIButton (POImagePosition)

- (void)setImagePosition:(POImagePosition)postion withInset:(CGFloat)inset;

@end
