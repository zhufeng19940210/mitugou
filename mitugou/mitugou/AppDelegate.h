//  AppDelegate.h
//  mitugou
//  Created by zhufeng on 2018/11/3.
//  Copyright © 2018年 zhufeng. All rights reserved.
#import <UIKit/UIKit.h>
@protocol AppPaySuccessDelegate <NSObject>
-(void)AppPayResultSuccess:(BOOL)isSuccess;
@end
@interface AppDelegate : UIResponder <UIApplicationDelegate>
@property (strong, nonatomic) UIWindow *window;
@property (nonatomic,weak)id <AppPaySuccessDelegate> PayDelegate;
@end

