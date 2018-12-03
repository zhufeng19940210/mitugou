//  LogisticsCell.m
//  mitugou
//  Created by zhufeng on 2018/12/3.
//  Copyright © 2018 zhufeng. All rights reserved.
#import "LogisticsCell.h"
@implementation LogisticsCell

- (void)awakeFromNib {
    [super awakeFromNib];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}
-(void)setLogisticmodel:(LogisticModel *)logisticmodel
{
    _logisticmodel = logisticmodel;
    
}
@end
