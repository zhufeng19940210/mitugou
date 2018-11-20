//  ProductModel.h
//  mitugou
//  Created by zhufeng on 2018/11/20.
//  Copyright © 2018 zhufeng. All rights reserved.
#import <Foundation/Foundation.h>
@interface ProductModel : BaseModel
@property (nonatomic,copy)NSString *cid;
@property (nonatomic,copy)NSString *cname;
@property (nonatomic,copy)NSString *ctype;
@property (nonatomic,copy)NSString *photo;
@property (nonatomic,copy)NSString *price;
@end
