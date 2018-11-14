//  AddreeListCell.m
//  mitugou
//  Created by zhufeng on 2018/11/9.
//  Copyright © 2018 zhufeng. All rights reserved.
#import "AddreeListCell.h"
@interface AddreeListCell()
@property (weak, nonatomic) IBOutlet UILabel *name_lab;
@property (weak, nonatomic) IBOutlet UILabel *phone_lab;
@property (weak, nonatomic) IBOutlet UILabel *detail_lab;
@property (weak, nonatomic) IBOutlet UIButton *default_btn;
@end
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
    NSLog(@"name:%@,phone:%@,address:%@",addressModel.receName,addressModel.phone,addressModel.detailAddr);
    self.name_lab.text  = addressModel.receName;
    self.phone_lab.text = addressModel.phone;
    self.detail_lab.text = addressModel.detailAddr;
    if (addressModel.isDefault == 1) {
        //是默认的
        [self.default_btn setImage:[UIImage imageNamed:@"address_select"] forState:UIControlStateNormal];
    }else{
        //不是默认的
        [self.default_btn setImage:[UIImage imageNamed:@"address_normal"] forState:UIControlStateNormal];
    }
}
@end
