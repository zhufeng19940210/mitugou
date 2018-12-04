//  SettingHuotiVC.h
//  mitugou
//  Created by zhufeng on 2018/12/3.
//  Copyright © 2018 zhufeng. All rights reserved.

#import "BaseVC.h"

@protocol SettingHuotiVCDelegate <NSObject>

-(void)SettingLiveWithImage:(UIImage *)image;

@end

@interface SettingHuotiVC : BaseVC

@property (nonatomic,weak)id <SettingHuotiVCDelegate> delegate;

@end
