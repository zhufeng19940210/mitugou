//  HomeTypeCell.m
//  mitugou
//  Created by zhufeng on 2018/11/7.
//  Copyright © 2018 zhufeng. All rights reserved.
#import "HomeTypeCell.h"
@implementation HomeTypeCell
- (void)awakeFromNib {
    [super awakeFromNib];
}
/**
 类型的button
 @param sender 类型的button
 */
- (IBAction)actionTypeBtn:(UIButton *)sender
{
    if (self.actionCallback) {
        self.actionCallback((HomeType)sender.tag);
    }
}
@end
