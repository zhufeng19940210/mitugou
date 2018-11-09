//
//  ApplicationproductCell.h
//  mitugou
//
//  Created by zhufeng on 2018/11/7.
//  Copyright © 2018 zhufeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ApplicationproductCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *icon_img;
@property (weak, nonatomic) IBOutlet UILabel *title_lab;

@property (weak, nonatomic) IBOutlet UILabel *price_lab;
@end
