//  ProductTypeCell.m
//  mitugou
//  Created by zhufeng on 2018/11/8.
//  Copyright © 2018 zhufeng. All rights reserved.

#import "ProductTypeCell.h"

@implementation ProductTypeCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
/**
 加载更多
 @param sender 加载更多
 */
- (IBAction)actionMoreBtn:(UIButton *)sender
{
    if (self.actionCallback) {
        self.actionCallback(sender);
    }
}

@end
