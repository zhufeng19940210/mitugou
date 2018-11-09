//  AddreeListCell.m
//  mitugou
//  Created by zhufeng on 2018/11/9.
//  Copyright © 2018 zhufeng. All rights reserved.
#import "AddreeListCell.h"
@implementation AddreeListCell
- (void)awakeFromNib {
    [super awakeFromNib];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}
/**
 删除/编辑方法
 @param sender 删除/编辑方法
 */
- (IBAction)actionProtationBtn:(UIButton *)sender
{
    if (self.acitonBlock) {
        self.acitonBlock((AddressOpertaionType)sender.tag);
    }
}
-(void)setAddressModel:(AddreeModel *)addressModel
{
    _addressModel = addressModel;
}
@end
