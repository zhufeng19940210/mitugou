//  AddressListVC.h
//  mitugou
//  Created by zhufeng on 2018/11/8.
//  Copyright © 2018 zhufeng. All rights reserved.

#import "BaseVC.h"
#import "AddreeModel.h"
typedef void(^SelectAddressBlock)(AddreeModel *model);
@interface AddressListVC : BaseVC
@property (nonatomic,copy)SelectAddressBlock addressBlock;
@end
