//
//  HomeProductCell.h
//  mitugou
//
//  Created by zhufeng on 2018/11/7.
//  Copyright © 2018 zhufeng. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger,HomeProduct) {
    HomeProductHot       = 1000,//手机专区
    HomeProductCar       = 2000,//机车专区
    HomeProductPeijian   = 3000,//配件专区
};
@interface HomeProductCell : UICollectionViewCell
@property (nonatomic,copy) void(^actionCallback)(HomeProduct type);
@property (weak, nonatomic) IBOutlet UIButton *hot_img;
@property (weak, nonatomic) IBOutlet UIButton *hot_up_img;
@property (weak, nonatomic) IBOutlet UIButton *hot_down_img;

@end
