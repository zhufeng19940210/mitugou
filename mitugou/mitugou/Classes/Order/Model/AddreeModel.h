//  AddreeModel.h
//  mitugou
//  Created by zhufeng on 2018/11/9.
//  Copyright © 2018 zhufeng. All rights reserved.
#import <Foundation/Foundation.h>
@interface AddreeModel : NSObject
///aid
@property (nonatomic,assign)NSInteger aid;
///详细地址
@property (nonatomic,copy)NSString *detailAddr;
///是的是默认地址
@property (nonatomic,assign)NSInteger isDefault;
///电话号码
@property (nonatomic,copy)NSString *phone;
///联系人姓名
@property (nonatomic,copy)NSString *receName;
///uid
@property (nonatomic,assign)NSInteger uid;
@end
