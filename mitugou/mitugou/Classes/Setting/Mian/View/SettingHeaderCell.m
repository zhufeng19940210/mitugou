//  SettingHeaderCell.m
//  mitugou
//  Created by zhufeng on 2018/11/7.
//  Copyright © 2018 zhufeng. All rights reserved.
#import "SettingHeaderCell.h"
@implementation SettingHeaderCell
- (void)awakeFromNib {
    [super awakeFromNib];
}
/**
 headerIconBtn
 @param sender headerIconBtn
 */
- (IBAction)actionHeaderBtn:(UIButton *)sender
{
    if (self.actionBlock) {
        self.actionBlock((SettingHeaderType)sender.tag);
    }
}
@end
