//  HomeNavTopView.h
//  mitugou
//  Created by zhufeng on 2018/11/7.
//  Copyright © 2018 zhufeng. All rights reserved.
#import <UIKit/UIKit.h>
typedef void(^LeftBtnBlock)(UIButton *btn);
typedef void(^RightBtnBlock)(UIButton *btn);
typedef void(^SearchBtnBlock)(UIButton *btn);
@interface HomeNavTopView : UIView
@property (nonatomic,copy)LeftBtnBlock    leftblock;
@property (nonatomic,copy)RightBtnBlock   rightblock;
@property (nonatomic,copy)SearchBtnBlock  searchblock;

@end
