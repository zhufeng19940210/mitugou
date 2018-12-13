//  OrderProductDetailVC.m
//  mitugou
//  Created by zhufeng on 2018/12/10.
//  Copyright © 2018 zhufeng. All rights reserved
#import "OrderProductDetailVC.h"
#import "OrderProductDetailCell.h"
#import "AddSelectCell.h"
#import "ProductDetailCell.h"
@interface OrderProductDetailVC ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@end
@implementation OrderProductDetailVC
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"订单详情";
    self.view.backgroundColor = RGB(240, 240, 240);
    [self setupTableView];
}
-(void)setupTableView
{
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    self.tableview.backgroundColor = [UIColor clearColor];
    [self.tableview registerNib:[UINib nibWithNibName:@"AddSelectCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"AddSelectCell"];
    [self.tableview registerNib:[UINib nibWithNibName:@"ProductDetailCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"ProductDetailCell"];
    [self.tableview registerNib:[UINib nibWithNibName:@"OrderProductDetailCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"OrderProductDetailCell"];
}
#pragma uitableviewdelagate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return  CGFLOAT_MIN;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 90;
    }else if(indexPath.section == 1){
        return 180;
    }else if(indexPath.section == 2){
        return 100;
    }else{
        return 0;
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        AddSelectCell *addressCell = [tableView dequeueReusableCellWithIdentifier:@"AddSelectCell"];
        addressCell.nameandphone_lab.text = [NSString stringWithFormat:@"%@ %@",self.statusmodel.rname,self.statusmodel.phone];
        addressCell.detail_lab.text = [NSString stringWithFormat:@"%@",self.statusmodel.address];
        return addressCell;
    }else if(indexPath.section ==1){
        ProductDetailCell *detailCell = [tableView dequeueReusableCellWithIdentifier:@"ProductDetailCell"];
        [detailCell.product_img sd_setImageWithURL:[NSURL URLWithString:self.statusmodel.photo] placeholderImage:[UIImage imageNamed:@"app_placeholder.png"]];
        detailCell.name_lab.text = [NSString stringWithFormat:@"%@",self.statusmodel.cname];
        detailCell.detail_lab.text = [NSString stringWithFormat:@"%@",self.statusmodel.cname];
        detailCell.price_lab.text = [NSString stringWithFormat:@"￥%.2f",[self.statusmodel.price doubleValue]];
        detailCell.color_lab.text = [NSString stringWithFormat:@"%@",self.statusmodel.cname];
        detailCell.total_lab.text = [NSString stringWithFormat:@"￥%.2f",[self.statusmodel.price doubleValue]];
        detailCell.count_lab.text = @"共计1件商品";
        return  detailCell;
    }else if(indexPath.section ==2){
        OrderProductDetailCell *productCell = [tableView dequeueReusableCellWithIdentifier:@"OrderProductDetailCell"];
        productCell.ordernumber_lab.text = [NSString stringWithFormat:@"订单编号:%@",self.statusmodel.oid];
        NSLog(@"self.statusmodel.ordertime:%@",self.statusmodel.ordertime);
        productCell.time_lab.text = [NSString stringWithFormat:@"创建时间:%@",[LCUtil timestampSwitchTime:self.statusmodel.ordertime andFormatter:@"yyyy-MM-dd HH:MM:SS"]];
        productCell.pay_time.text = [NSString stringWithFormat:@"支付时间:%@",[LCUtil timestampSwitchTime:self.statusmodel.ordertime andFormatter:@"yyyy-MM-dd HH:MM:SS"]];
        productCell.selectionStyle = UITableViewCellSelectionStyleNone;
        return productCell;
    }else{
        return nil;
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
@end
