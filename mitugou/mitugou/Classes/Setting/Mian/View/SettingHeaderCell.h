//  SettingHeaderCell.h
//  mitugou
//  Created by zhufeng on 2018/11/7.
//  Copyright © 2018 zhufeng. All rights reserved
#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger,SettingHeaderType) {
    SettingHeaderTypeIcon   = 1000,//头像Btn
    SettingHeaderTypeMsg    = 2000,//消息Btn
    SettingHeaderTypeJie    = 3000,//借款Btn
    SettingHeaderTypeHuan   = 4000,//还款Btn
};
@interface SettingHeaderCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *icon_btn;
@property (weak, nonatomic) IBOutlet UILabel *name_lab;
@property (nonatomic,copy)void(^actionBlock)(SettingHeaderType type);
@end
