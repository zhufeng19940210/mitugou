//  OrderContentCell.m
//  mitugou
//  Created by zhufeng on 2018/11/9.
//  Copyright © 2018 zhufeng. All rights reserved.

#import "OrderContentCell.h"

@interface OrderContentCell()
///订单编号
@property (weak, nonatomic) IBOutlet UILabel *order_number;
///订单状态
@property (weak, nonatomic) IBOutlet UILabel *order_status;
///商品名称
@property (weak, nonatomic) IBOutlet UILabel *product_lab;
///商品图片
@property (weak, nonatomic) IBOutlet UILabel *produc_img;
///商品描述
@property (weak, nonatomic) IBOutlet UILabel *product_des;
///商品单价
@property (weak, nonatomic) IBOutlet UILabel *single_price_lab;
///商品数量
@property (weak, nonatomic) IBOutlet UILabel *product_total_lab;
///总的价格
@property (weak, nonatomic) IBOutlet UILabel *total_price_lab;
///提醒发货
@property (weak, nonatomic) IBOutlet UIButton *tixingfahuo_btn;
///查看物流
@property (weak, nonatomic) IBOutlet UIButton *chakanwuliu_btn;
///评价
@property (weak, nonatomic) IBOutlet UIButton *pinjia_btn;
///确认收货
@property (weak, nonatomic) IBOutlet UIButton *confirm_btn;
@end

@implementation OrderContentCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

-(void)setOrderModel:(OrderStatusModel *)orderModel
{
    _orderModel = orderModel;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

///提醒发货
- (IBAction)actionTixifahuoBtn:(UIButton *)sender
{
    if (self.tixingfahuoblock) {
        self.tixingfahuoblock(sender.titleLabel.text, self.orderModel);
    }
}
///查看物流
- (IBAction)actionChakanwuliluBtn:(UIButton *)sender
{
    if (self.chakanwuliublock) {
        self.chakanwuliublock(sender.titleLabel.text, self.orderModel);
    }
}
///评价
- (IBAction)acitonPinjiaBtn:(UIButton *)sender
{
    if (self.pinjiablock) {
        self.pinjiablock(sender.titleLabel.text, self.orderModel);
    }
}
//确认收货
- (IBAction)actionConfirmBtn:(UIButton *)sender
{
    if (self.confimblock) {
        self.confimblock(sender.titleLabel.text, self.orderModel);
    }
}
@end
