//  ProductSubModel.h
//  mitugou
//  Created by zhufeng on 2018/11/20.
//  Copyright © 2018 zhufeng. All rights reserved.
#import <Foundation/Foundation.h>

@interface ProductSubModel : NSObject
@property (nonatomic,copy)NSString  *cid;
@property (nonatomic,strong)NSDictionary  *classify;
@property (nonatomic,copy)NSString  *cname;
@property (nonatomic,copy)NSString  *color;
@property (nonatomic,copy)NSString  *counts;
@property (nonatomic,copy)NSString  *ctype;
@property (nonatomic,copy)NSString  *desc;
@property (nonatomic,strong)NSArray *details;
@property (nonatomic,copy)NSString  *ishot;
@property (nonatomic,copy)NSString  *isrecommand;
@property (nonatomic,copy)NSString  *photo;
@property (nonatomic,copy)NSString  *price;
@end
