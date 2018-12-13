//  PayView.m
//  mitugou
//  Created by zhufeng on 2018/12/3.
//  Copyright © 2018 zhufeng. All rights reserved.
#import "PayView.h"
@interface PayView()
@property (weak, nonatomic) IBOutlet UIButton *wecha_btn;
@property (weak, nonatomic) IBOutlet UIButton *zhfubao_btn;
@property (nonatomic,assign)int payTag;
@property (weak, nonatomic) IBOutlet UIView *bgview;
@end
@implementation PayView

-(void)awakeFromNib
{
    [super awakeFromNib];
    self.frame = CGRectMake(0, 0, IPHONE_WIDTH, IPHONE_HEIGHT);
    self.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.3];
}

/**
 更换支付方式
 @param sender 更换支付方式
 */
- (IBAction)actionChangePayBtn:(UIButton *)sender
{
    int tag = (int)sender.tag;
    self.payTag = tag;
    if (tag == 0) {
        //微信支付
        [self.wecha_btn setImage:[UIImage imageNamed:@"pay_select.png"] forState:UIControlStateNormal];
        [self.zhfubao_btn setImage:[UIImage imageNamed:@"pay_normal.png"] forState:UIControlStateNormal];
    }else{
        //支付宝支付
        [self.wecha_btn setImage:[UIImage imageNamed:@"pay_normal.png"] forState:UIControlStateNormal];
        [self.zhfubao_btn setImage:[UIImage imageNamed:@"pay_select.png"] forState:UIControlStateNormal];
    }
}
/**
 确定支付方式
 @param sender 确定支付
 */
- (IBAction)actionOKBtn:(UIButton *)sender
{
    [self removeSelfFromSupView];
    if (self.paymethodblock) {
        self.paymethodblock(self.payTag);
    }
}
/**
 弹出视图
 */
- (void)show
{
    self.frame = CGRectMake(0, 0, IPHONE_WIDTH,IPHONE_HEIGHT);
    [[[UIApplication sharedApplication].delegate window] addSubview:self];
    
    //动画出现
    CGRect frame = self.bgview.frame;
    if (frame.origin.y == IPHONE_HEIGHT) {
        [UIView animateWithDuration:0.3 animations:^{
            self.bgview.frame = frame;
        }];
    }
}
/**
 移除视图
 */
- (void)removeSelfFromSupView
{
     [self removeFromSuperview];
}
/**
 点击空白关闭
 */
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self removeSelfFromSupView];
}
@end
