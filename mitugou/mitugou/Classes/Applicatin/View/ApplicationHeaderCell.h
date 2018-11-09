//  ApplicationHeaderCell.h
//  mitugou
//  Created by zhufeng on 2018/11/7.
//  Copyright © 2018 zhufeng. All rights reserved.
#import <UIKit/UIKit.h>
@interface ApplicationHeaderCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UILabel *count_lab;
@property (nonatomic,copy)void(^actionBlock)(UIButton *btn);
@end
