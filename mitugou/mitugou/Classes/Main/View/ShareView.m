//  ShareView.m
//  xiaochacha
//  Created by apple on 2018/10/24.
//  Copyright © 2018 HuiC. All rights reserved.
#import "ShareView.h"
@interface ShareView()
@property (nonatomic,strong)NSMutableArray *imageArray;
@property (nonatomic,strong)NSMutableArray *titleArray;
@end
@implementation ShareView
-(NSMutableArray *)imageArray
{
    if (!_imageArray) {
        _imageArray = [NSMutableArray arrayWithObjects:@"wechat",@"pyq",@"qq", nil];
    }
    return _imageArray;
}
-(NSMutableArray *)titleArray
{
    if (!_titleArray) {
        _titleArray = [NSMutableArray arrayWithObjects:@"微信",@"朋友圈",@"qq", nil];
    }
    return _titleArray;
}
-(void)shareViewShow
{   UIWindow *window = [UIApplication sharedApplication].keyWindow;
    UITapGestureRecognizer *tapgesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(actionHiddernView)];
    UIView *blackView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, IPHONE_WIDTH,IPHONE_HEIGHT)];
    blackView.backgroundColor = [UIColor colorWithRed:(0/255.0f) green:(0/255.0f) blue:(0/255.0f) alpha:0.3];
    blackView.tag = 440;
    [blackView addGestureRecognizer:tapgesture];
    [window addSubview:blackView];
    //分享的界面
    UIView *shareView = [[UIView alloc]init];
    //居中的显示
    shareView.frame =CGRectMake(0, IPHONE_HEIGHT-(150*pro_HEIGHT),IPHONE_WIDTH,160*pro_HEIGHT);
    shareView.backgroundColor = [UIColor whiteColor];
    shareView.tag = 441;
    [window addSubview:shareView];
    //分享的文字
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 30, shareView.frame.size.width ,30)];
    titleLabel.text = @"分享到";
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont systemFontOfSize:16];
    titleLabel.textColor = [UIColor blackColor];
    titleLabel.backgroundColor = [UIColor clearColor];
    [shareView addSubview:titleLabel];
    //去参加按钮
    CGFloat btnH = 80;
    CGFloat btnW = btnH;
    CGFloat marign = 10;
    for(int i = 0 ; i<3; i++){
        UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(10+(marign*i)+btnW*i, CGRectGetMaxY(titleLabel.frame)+20,btnW , btnH)];
        [button setImage:[UIImage imageNamed:self.imageArray[i]] forState:UIControlStateNormal];
        [button setTitle:self.titleArray[i] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [button setImagePosition:POImagePositionTop withInset:5];
        button.titleLabel.font = [UIFont systemFontOfSize:15];
        button.tag = 1000+i;
        [button addTarget:self action:@selector(myButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [shareView addSubview:button];
    }
}
#pragma mark
-(void)myButtonClick:(UIButton *)button
{
    int tag = (int)button.tag - 1000;
    if (self.delegate) {
        if ([self.delegate respondsToSelector:@selector(shareWithTag:)]) {
            [self.delegate shareWithTag:tag];
            [self shareViewHidden];
        }
    }
}
/**
 手势执行的方法
 */
-(void)actionHiddernView
{
    [self shareViewHidden];
}
//隐藏的方法
-(void)shareViewHidden
{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    UIView *blackView = [window viewWithTag:440];
    UIView *shareView = [window viewWithTag:441];
    //为了弹窗不那么生硬，这里加了个简单的动画
    shareView.transform = CGAffineTransformMakeScale(1, 1);
    [UIView animateWithDuration:0.35f animations:^{
        shareView.transform = CGAffineTransformMakeScale(1/300.0f, 1/270.0f);
        blackView.alpha = 0;
    } completion:^(BOOL finished) {
        [shareView removeFromSuperview];
        [blackView removeFromSuperview];
    }];
}
@end
