//  HomeAdCell.h
//  mitugou
//  Created by zhufeng on 2018/11/7.
//  Copyright © 2018 zhufeng. All rights reserved.
#import <UIKit/UIKit.h>
@interface HomeAdCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet SDCycleScrollView *cycleScrollView;
@property (nonatomic,strong)NSArray *ulrArray;
@end
