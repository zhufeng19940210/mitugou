//  ProductSubModel.m
//  mitugou
//  Created by zhufeng on 2018/11/20.
//  Copyright © 2018 zhufeng. All rights reserved.

#import "ProductSubModel.h"
#import "ZFDetailModel.h"
@implementation ProductSubModel
+(NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{
             @"desc": @"description"
             
             };
}

-(void)setDetails:(NSArray *)details
{
    NSMutableArray *array = [NSMutableArray array];
    for (NSDictionary *dict in details) {
        [array addObject:[ZFDetailModel mj_objectWithKeyValues:dict]];
    }
    _details = array;
}

@end
