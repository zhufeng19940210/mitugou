//  HomeProductCell.m
//  mitugou
//
//  Created by zhufeng on 2018/11/7.
//  Copyright © 2018 zhufeng. All rights reserved.
//

#import "HomeProductCell.h"

@implementation HomeProductCell

- (void)awakeFromNib {
    [super awakeFromNib];
}
/**
 产品的跳转
 @param sender 产品的跳转
 */
- (IBAction)actionProductBtn:(UIButton *)sender
{
    if (self.actionCallback) {
        self.actionCallback((HomeProduct)sender.tag);
    }
}
@end
