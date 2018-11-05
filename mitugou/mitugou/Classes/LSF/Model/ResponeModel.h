//  ResponeModel.h
//  mitugou
//  Created by zhufeng on 2018/11/3.
//  Copyright © 2018年 zhufeng. All rights reserved.
#import <Foundation/Foundation.h>

@interface ResponeModel : NSObject
@property (nonatomic,copy) NSString *htoken;
@property (nonatomic,copy) NSString *message;
@property (nonatomic,assign) NSInteger  status;
@property (nonatomic,assign) NSInteger  success;
@property (nonatomic,assign) NSInteger  totalCount;
@property (nonatomic,assign) NSInteger  totalPages;
@property (nonatomic,strong) id data;
@end
