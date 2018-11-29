//  ApplicationproductCell.m
//  mitugou
//  Created by zhufeng on 2018/11/7.
//  Copyright © 2018 zhufeng. All rights reserved.
#import "ApplicationproductCell.h"
@interface ApplicationproductCell()
@property (weak, nonatomic) IBOutlet UIImageView *icon_img;
@property (weak, nonatomic) IBOutlet UILabel *title_lab;
@property (weak, nonatomic) IBOutlet UILabel *price_lab;
@end
@implementation ApplicationproductCell
- (void)awakeFromNib {
    [super awakeFromNib];
}
-(void)setProductModel:(ProductModel *)productModel
{
    _productModel = productModel;
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",self.prePrefix,productModel.photo];
    NSLog(@"url:%@",urlStr);
    [_icon_img sd_setImageWithURL:[NSURL URLWithString:urlStr] placeholderImage:[UIImage imageNamed:@"app_placeholder.png"]];
    _title_lab.text = [NSString stringWithFormat:@"%@",productModel.cname];
    _price_lab.text = [NSString stringWithFormat:@"￥%.2f",[productModel.price doubleValue]];
}
@end
