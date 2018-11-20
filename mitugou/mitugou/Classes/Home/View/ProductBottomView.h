//  ProductBottomView.h
//  mitugou
//  Created by zhufeng on 2018/11/19.
//  Copyright © 2018 zhufeng. All rights reserved.
#import <UIKit/UIKit.h>
typedef void(^actionLeftBtn)(UIButton *btn);
typedef void(^actionRightBtn)(UIButton *btn);
@interface ProductBottomView : UIView
@property (nonatomic,strong)actionLeftBtn  leftBlock;
@property (nonatomic,strong)actionRightBtn rightBlock;
@end
