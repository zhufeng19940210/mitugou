//  MessageModel.h
//  mitugou
//  Created by zhufeng on 2018/11/21.
//  Copyright © 2018 zhufeng. All rights reserved
#import "BaseModel.h"
@interface MessageModel : BaseModel
@property (nonatomic,copy) NSString *cid;
@property (nonatomic,copy) NSString *name;
@property (nonatomic,copy) NSString *type;
@end
