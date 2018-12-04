//
//  UIButton+Block.h
//  mitugou
//
//  Created by zhufeng on 2018/12/3.
//  Copyright © 2018 zhufeng. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^ButtonClickBlock)(UIButton *btn);
@interface UIButton (Block)
@property (nonatomic,copy)ButtonClickBlock buttonclickblock;
-(void)addTaregetActionBlock:(ButtonClickBlock)blcok;
@end
