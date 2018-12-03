//  OrderContentCell.h
//  mitugou
//  Created by zhufeng on 2018/11/9.
//  Copyright © 2018 zhufeng. All rights reserved.
#import <UIKit/UIKit.h>
#import "OrderStatusModel.h"
typedef void(^TixingfahuoBlock)(NSString *tagStr,OrderStatusModel *orderModel);
typedef void(^ChakanwuliuBlcok)(NSString *tagStr,OrderStatusModel *orderModel);
typedef void(^PinjiagBlock)(NSString *tagStr,OrderStatusModel *orderModel);
typedef void(^ConfimBlcok)(NSString *tagStr,OrderStatusModel *orderModel );
@interface OrderContentCell : UITableViewCell
@property (nonatomic,strong)OrderStatusModel *orderModel;
@property (nonatomic,copy)TixingfahuoBlock tixingfahuoblock;
@property (nonatomic,copy)ChakanwuliuBlcok chakanwuliublock;
@property (nonatomic,copy)PinjiagBlock     pinjiablock;
@property (nonatomic,copy)ConfimBlcok      confimblock;
@end
