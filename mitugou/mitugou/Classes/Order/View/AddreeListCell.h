//  AddreeListCell.h
//  mitugou
//  Created by zhufeng on 2018/11/9.
//  Copyright © 2018 zhufeng. All rights reserved.
#import <UIKit/UIKit.h>
#import "AddreeModel.h"
typedef NS_ENUM(NSInteger,AddressOpertaionType) {
    AddressOpertaionTypeDefault   = 1000,//默认地址
    AddressOpertaionTypeDelete    = 2000,//删除地址
    AddressOpertaionTypeEdit      = 3000,//编辑按钮
};
@interface AddreeListCell : UITableViewCell
@property (nonatomic,strong)AddreeModel *addressModel;
@property (nonatomic,copy)void(^acitonBlock)(AddressOpertaionType type);
@end
