//  SettingHeaderCell.m
//  mitugou
//  Created by zhufeng on 2018/11/7.
//  Copyright © 2018 zhufeng. All rights reserved.
#import "SettingHeaderCell.h"
@implementation SettingHeaderCell
- (void)awakeFromNib {
    [super awakeFromNib];
    self.icon_btn.layer.cornerRadius = 40.0f;
    self.icon_btn.layer.masksToBounds = YES;
    self.icon_btn.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(IconTap:)];
    [self.icon_btn addGestureRecognizer:tapGesture];
}
/**
 headerIconBtn
 @param sender headerIconBtn
 */
-(void)IconTap:(UITapGestureRecognizer *)gesture
{   int tag = (int)gesture.view.tag;
    if (self.actionBlock) {
        self.actionBlock((SettingHeaderType)tag);
    }
}

@end
