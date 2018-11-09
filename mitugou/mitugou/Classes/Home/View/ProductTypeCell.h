//  ProductTypeCell.h
//  mitugou
//  Created by zhufeng on 2018/11/8.
//  Copyright © 2018 zhufeng. All rights reserved.
#import <UIKit/UIKit.h>
@interface ProductTypeCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UILabel *type_lab;
@property (nonatomic,copy) void(^actionCallback)(UIButton *button);
@end
