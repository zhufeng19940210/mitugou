//  PeriodsModel.h
//  mitugou
//  Created by zhufeng on 2018/11/19.
//  Copyright © 2018 zhufeng. All rights reserved.
#import <Foundation/Foundation.h>
/**
 分期的model
 */
@interface PeriodsModel : BaseModel
@property (nonatomic) BOOL isSelect;
@property (nonatomic, strong) NSString *updateBy;
@property (nonatomic, copy) NSNumber *atInterest;
@property (nonatomic, strong) NSString *internalBaseClassIdentifier;
@property (nonatomic, copy) NSNumber *totalAmount;
@property (nonatomic, copy) NSNumber *periodNum;
@property (nonatomic, strong) NSString *createDate;
@property (nonatomic, strong) NSString *periodTypeName;
@property (nonatomic, strong) NSString *periodNumName;
@property (nonatomic, strong) NSString *updateDate;
@property (nonatomic, strong) NSString *createBy;
@property (nonatomic, strong) NSString *productNo;
@property (nonatomic, copy) NSNumber *atPrincipal;
@property (nonatomic, copy) NSNumber *atServiceCharge;
@property (nonatomic, copy) NSNumber *periodType;
@end
