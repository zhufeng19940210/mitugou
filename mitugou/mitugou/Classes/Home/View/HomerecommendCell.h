//  HomerecommendCell.h
//  mitugou
//  Created by zhufeng on 2018/11/7.
//  Copyright © 2018 zhufeng. All rights reserved.
#import <UIKit/UIKit.h>
#import "SGAdvertScrollView.h"
@interface HomerecommendCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet SGAdvertScrollView *adscrollview;
@property (weak, nonatomic) IBOutlet UIImageView *home_img1;
@property (weak, nonatomic) IBOutlet UIImageView *home_img2;
@property (weak, nonatomic) IBOutlet UIImageView *home_img3;
@end
