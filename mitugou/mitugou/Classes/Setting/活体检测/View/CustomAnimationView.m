//
//  CustomAnimationView.m
//  HTJCFaceDetect
//
//  Created by LiMu on 17/9/23.
//  Copyright © 2017年 SJC. All rights reserved.
//

#import "CustomAnimationView.h"

#define DOWN_IMG     [UIImage imageNamed:@"HTJCDataBase.bundle/headImage_down.png"]
#define UP_IMG       [UIImage imageNamed:@"HTJCDataBase.bundle/headImage_up.png"]
#define FRONT_IMG    [UIImage imageNamed:@"HTJCDataBase.bundle/headImage_normal.png"]
#define LEFT_IMG     [UIImage imageNamed:@"HTJCDataBase.bundle/headImage_left.png"]
#define RIGHT_IMG    [UIImage imageNamed:@"HTJCDataBase.bundle/headImage_right.png"]
#define MOUTH_IMG    [UIImage imageNamed:@"HTJCDataBase.bundle/mouthImage_open.png"]
#define EYES_IMG     [UIImage imageNamed:@"HTJCDataBase.bundle/eyesImage_close.png"]

@implementation CustomAnimationView


- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
    }
    return self;
}
//创建动画
-(void)beginAnimationWithType:(NSInteger)type{
    
    [UIView transitionWithView:self duration:0.3f options:UIViewAnimationOptionTransitionFlipFromLeft animations:^{
        
    } completion:^(BOOL finished) {
        
    }];
    
    if (type == 0) {              //凝视
        [self startAnimationWithImages:[self forntImages]];
    } else if (type == 1) {       //点头动画
        [self startAnimationWithImages:[self nodImages]];
    } else if (type == 2) {       //摇头动画
        [self startAnimationWithImages:[self shakeImages]];
    } else if (type == 3) {       //向右看
        [self startAnimationWithImages:[self rightImages]];
    }  else if (type == 4) {      //向左看
        [self startAnimationWithImages:[self leftImages]];
    }else if (type == 5) {        //张嘴
        [self startAnimationWithImages:[self mouthImages]];
    }else if (type == 6) {        //眨眼
        [self startAnimationWithImages:[self eyesImages]];
    }
    
    
}

- (void)startAnimationWithImages:(NSArray *)images
{
    //添加照片数组
    [self setAnimationImages:images];
    //设置动画播放次数
    [self setAnimationRepeatCount:0];
    //设置动画播放时间
    [self setAnimationDuration:12*0.095];
    //动画开始
    [self startAnimating];
}

//点头
- (NSArray *)nodImages
{
    UIImage *fornImg2 = FRONT_IMG;
    UIImage *downImg = DOWN_IMG;
    UIImage *fornImg = FRONT_IMG;
    UIImage *upImg = UP_IMG;
    NSArray *imgs = [NSArray arrayWithObjects:fornImg2, downImg, fornImg, upImg, nil];
    return imgs;
}

//摇头
- (NSArray *)shakeImages
{
    UIImage *fornImg2 = FRONT_IMG;
    UIImage *leftImg = LEFT_IMG;
    UIImage *fornImg = FRONT_IMG;
    UIImage *rightImg = RIGHT_IMG;
    NSArray *imgs = [NSArray arrayWithObjects:fornImg2, leftImg, fornImg, rightImg, nil];
    return imgs;
}

//向左看
- (NSArray *)leftImages
{
    UIImage *fornImg = FRONT_IMG;
    UIImage *leftImg = LEFT_IMG;
    NSArray *imgs = [NSArray arrayWithObjects:fornImg, leftImg, nil];
    return imgs;
}

//向右看
- (NSArray *)rightImages
{
    UIImage *fornImg = FRONT_IMG;
    UIImage *rightImg = RIGHT_IMG;
    NSArray *imgs = [NSArray arrayWithObjects:fornImg, rightImg, nil];
    return imgs;
}
//凝视
- (NSArray *)forntImages
{
    UIImage *fornImg = FRONT_IMG;
    NSArray *imgs = [NSArray arrayWithObjects:fornImg, nil];
    return imgs;
}
//张嘴
- (NSArray *)mouthImages
{
    UIImage *fornImg = FRONT_IMG;
    UIImage *mouthImg = MOUTH_IMG;
    NSArray *imgs = [NSArray arrayWithObjects:fornImg,mouthImg, nil];
    return imgs;
}
//眨眼
- (NSArray *)eyesImages
{
    UIImage *fornImg = FRONT_IMG;
    UIImage *mouthImg = EYES_IMG;
    NSArray *imgs = [NSArray arrayWithObjects:fornImg,mouthImg, nil];
    return imgs;
}

@end
