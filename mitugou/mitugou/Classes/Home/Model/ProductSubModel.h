//  ProductSubModel.h
//  mitugou
//  Created by zhufeng on 2018/11/20.
//  Copyright © 2018 zhufeng. All rights reserved.
#import <Foundation/Foundation.h>

@interface ProductSubModel : NSObject
@property (nonatomic,copy)NSString  *cname;
@property (nonatomic,copy)NSString  *color;
@property (nonatomic,copy)NSString  *counts;
@property (nonatomic,copy)NSString  *ctype;
@property (nonatomic,copy)NSString  *description;
@property (nonatomic,strong)NSArray *destails;
@property (nonatomic,copy)NSString  *ishot;
@property (nonatomic,copy)NSString  *isrecommand;
@property (nonatomic,copy)NSString  *photo;
@property (nonatomic,copy)NSString  *price;

@end
