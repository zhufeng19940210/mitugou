//  HomeAdCell.m
//  mitugou
//  Created by zhufeng on 2018/11/7.
//  Copyright © 2018 zhufeng. All rights reserved.
#import "HomeAdCell.h"
@implementation HomeAdCell
- (void)awakeFromNib {
    [super awakeFromNib];
}
-(void)setUlrArray:(NSArray *)ulrArray
{
    _cycleScrollView.imageURLStringsGroup = ulrArray;
}

@end
