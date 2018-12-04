//  UIButton+Block.m
//  mitugou
//  Created by zhufeng on 2018/12/3.
//  Copyright © 2018 zhufeng. All rights reserved.
#import "UIButton+Block.h"
#import <objc/message.h>
static char ActionTag;
@implementation UIButton (Block)
-(void)addTaregetActionBlock:(ButtonClickBlock)blcok
{
    objc_setAssociatedObject(self, &ActionTag, blcok, OBJC_ASSOCIATION_COPY_NONATOMIC);
    [self addTarget:self action:@selector(actionpushBtn:) forControlEvents:UIControlEventTouchUpInside];
}

-(void)actionpushBtn:(UIButton *)btn
{
    ButtonClickBlock block = (ButtonClickBlock)objc_getAssociatedObject(self, &ActionTag);
    if (block) {
        block(self);
    }
}
@end
