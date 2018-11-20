//  DetailImageModel.m
//  mitugou
//  Created by zhufeng on 2018/11/19.
//  Copyright © 2018 zhufeng. All rights reserved.
#import "DetailImageModel.h"
#define ImageURL @"http://47.104.133.55/"
@implementation DetailImageModel

-(void)setPicUrl:(NSString *)picUrl
{
    _picUrl = [NSString stringWithFormat:@"%@%@",ImageURL,picUrl];
}
@end
