//  ProductBottomView.m
//  mitugou
//  Created by zhufeng on 2018/11/19.
//  Copyright © 2018 zhufeng. All rights reserved.
#import "ProductBottomView.h"
@interface ProductBottomView ()
@property (nonatomic,strong)UIButton *buynowBtn;
@property (nonatomic,strong)UIButton *stagingBtn;
@end

@implementation ProductBottomView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self seutpUI];
    }
    return self;
}
/**
 setupUI
 */
-(void)seutpUI
{
    self.backgroundColor = [UIColor clearColor];
    _buynowBtn = ({
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:@"直接购买" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button setBackgroundColor:ZF_Left_Color];
        [button addTarget:self action:@selector(actionLeftBtn:) forControlEvents:UIControlEventTouchUpInside];
        button;
    });
    
    _stagingBtn = ({
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:@"分期购买" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button setBackgroundColor:MainThemeColor];
        [button addTarget:self action:@selector(actionRightBtn:) forControlEvents:UIControlEventTouchUpInside];
        button;
    });
    
    [self addSubview:_buynowBtn];
    [self addSubview:_stagingBtn];
}
/**
 leftButton
 @param button leftButton
 */
-(void)actionLeftBtn:(UIButton *)button
{
    if (self.leftBlock) {
        self.leftBlock(button);
    }
}
/**
 rightButton
 @param button rightButton
 */
-(void)actionRightBtn:(UIButton *)button
{
    if (self.rightBlock) {
        self.rightBlock(button);
    }
}

-(void)layoutSubviews
{
  
    [super layoutSubviews];
    _buynowBtn.frame = CGRectMake(0, 0, IPHONE_WIDTH/2, 50);
    _stagingBtn.frame =CGRectMake(IPHONE_WIDTH/2, 0, IPHONE_WIDTH/2, 50);
}

@end
