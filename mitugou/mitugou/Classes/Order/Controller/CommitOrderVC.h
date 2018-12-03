//  CommitOrderVC.h
//  mitugou
//  Created by zhufeng on 2018/11/8.
//  Copyright © 2018 zhufeng. All rights reserved.

#import "BaseVC.h"
#import "ProductSubModel.h"
#import "PeriodsModel.h"
@interface CommitOrderVC : BaseVC
@property (nonatomic,strong)ProductSubModel *detailModel;
//@property (nonatomic,strong)PeriodsModel *periodsModl;
@property (nonatomic,copy)NSString *selectColor;
@property (nonatomic,copy)NSString *prefix; //图片前缀
@end
