//  ProductDetailCell.h
//  mitugou
//  Created by zhufeng on 2018/11/9.
//  Copyright © 2018 zhufeng. All rights reserved.
#import <UIKit/UIKit.h>

@interface ProductDetailCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *product_img;
@property (weak, nonatomic) IBOutlet UILabel *name_lab;
@property (weak, nonatomic) IBOutlet UILabel *detail_lab;
@property (weak, nonatomic) IBOutlet UILabel *price_lab;
@property (weak, nonatomic) IBOutlet UILabel *color_lab;
@property (weak, nonatomic) IBOutlet UILabel *total_lab;
@property (weak, nonatomic) IBOutlet UILabel *count_lab;

@end
