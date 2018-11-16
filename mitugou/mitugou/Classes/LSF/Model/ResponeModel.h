//  ResponeModel.h
//  mitugou
//  Created by zhufeng on 2018/11/3.
//  Copyright © 2018年 zhufeng. All rights reserved.
#import <Foundation/Foundation.h>

@interface ResponeModel : NSObject
@property (nonatomic,assign) NSInteger code;
@property (nonatomic,copy) NSString *message;
@property (nonatomic,strong) id data;
@end
