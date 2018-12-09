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
@property (weak, nonatomic) IBOutlet UIImageView *produc_img;

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
@end

@implementation OrderContentCell

- (void)awakeFromNib {
    [super awakeFromNib];
}
-(void)setOrderModel:(OrderStatusModel *)orderModel
{
    _orderModel = orderModel;
    _order_number.text = [NSString stringWithFormat:@"%@",orderModel.ordernumber];
    [_produc_img sd_setImageWithURL:[NSURL URLWithString:orderModel.photo] placeholderImage:[UIImage imageNamed:@"app_placeholder.png"]];
    _product_lab.text = [NSString stringWithFormat:@"%@",orderModel.cname];
    _product_des.text = [NSString stringWithFormat:@"%@",orderModel.cname];
    _single_price_lab.text =[NSString stringWithFormat:@"￥%.2f",[orderModel.price doubleValue]];
    _total_price_lab.text = [NSString stringWithFormat:@"小计:￥%.2f",[orderModel.price doubleValue]];
        NSLog(@"orderModel.cstate:%@",orderModel.cstate);
    if ([orderModel.cstate isEqualToString:@"0"]) {
        ///待付款
        _order_status.text = @"待付款";
        _tixingfahuo_btn.hidden = YES;
        _chakanwuliu_btn.hidden = YES;
    }else if([orderModel.cstate isEqualToString:@"1"]){
        ///待发货
        _order_status.text = @"待发货";
        _chakanwuliu_btn.hidden = YES;
        _tixingfahuo_btn.hidden = NO;
    }else if ([orderModel.cstate isEqualToString:@"2"]){
        ///待收货
        _order_status.text = @"待收货";
        _tixingfahuo_btn.hidden = NO;
        _chakanwuliu_btn.hidden = NO;
        [_tixingfahuo_btn setTitle:@"确定收货" forState:UIControlStateNormal];
    }else if ([orderModel.cstate isEqualToString:@"3"]){
        ///已完成
        _order_status.text = @"已完成";
        _tixingfahuo_btn.hidden = NO;
        _chakanwuliu_btn.hidden = YES;
        [_tixingfahuo_btn setTitle:@"已完成" forState:UIControlStateNormal];
    }
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
@end
