//  HomeMessageModel.h
//  mitugou
//  Created by zhufeng on 2018/12/5.
//  Copyright © 2018 zhufeng. All rights reserved.
#import "BaseModel.h"
@interface HomeMessageModel : NSObject
@property (nonatomic,copy) NSString *address;
@property (nonatomic,copy) NSString *briefly;
@property (nonatomic,copy) NSString *category;
@property (nonatomic,copy) NSString *content;
@property (nonatomic,copy) NSString *createtime;
@property (nonatomic,copy) NSString *header;
@property (nonatomic,copy) NSString *iid;
@property (nonatomic,copy) NSString *promulgator;
@property (nonatomic,copy) NSString *receiver;
@property (nonatomic,copy) NSString *state;
@property (nonatomic,copy) NSString *way;
@end
