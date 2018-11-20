//  HomeTypeCell.h
//  mitugou
//  Created by zhufeng on 2018/11/7.
//  Copyright © 2018 zhufeng. All rights reserved.
#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger,HomeType) {
    HomeTypeCar   = 100,//机车专区
    HomeTypePhone = 200,//手机专区
};
@interface HomeTypeCell : UICollectionViewCell
@property (nonatomic,copy) void(^actionCallback)(HomeType type);
@property (weak, nonatomic) IBOutlet UIButton *left_btn;
@property (weak, nonatomic) IBOutlet UIButton *right_btn;
@end
