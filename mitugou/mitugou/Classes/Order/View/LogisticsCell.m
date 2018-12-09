//  LogisticsCell.m
//  mitugou
//  Created by zhufeng on 2018/12/3.
//  Copyright © 2018 zhufeng. All rights reserved.
#import "LogisticsCell.h"
@interface LogisticsCell()
@property (weak, nonatomic) IBOutlet UILabel *time_lab;
@property (weak, nonatomic) IBOutlet UILabel *content_lab;
@property (weak, nonatomic) IBOutlet UILabel *remark_lab;

@end
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
    _time_lab.text = [NSString stringWithFormat:@"%@",logisticmodel.AcceptTime];
    _content_lab.text = [NSString stringWithFormat:@"%@",logisticmodel.AcceptStation];
    _remark_lab.text = [NSString stringWithFormat:@"(%@)",logisticmodel.Remark];
}
@end
