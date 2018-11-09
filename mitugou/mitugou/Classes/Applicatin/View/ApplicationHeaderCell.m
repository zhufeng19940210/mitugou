//  ApplicationHeaderCell.m
//  mitugou
//  Created by zhufeng on 2018/11/7.
//  Copyright © 2018 zhufeng. All rights reserved.

#import "ApplicationHeaderCell.h"
@implementation ApplicationHeaderCell
- (void)awakeFromNib {
    [super awakeFromNib];
}
/**
 立即申请
 @param sender 立即申请的方法
 */
- (IBAction)actionApplicatinBtn:(UIButton *)sender
{
    if (self.actionBlock) {
        self.actionBlock(sender);
    }
}
@end
