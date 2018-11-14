//  AddressEditVC.h
//  mitugou
//  Created by zhufeng on 2018/11/8.
//  Copyright © 2018 zhufeng. All rights reserved.
#import "BaseVC.h"
#import "AddreeModel.h"
@interface AddressEditVC : BaseVC
@property (nonatomic,assign)BOOL isEdit;
@property (nonatomic,strong)AddreeModel *addressmodel;
@end
