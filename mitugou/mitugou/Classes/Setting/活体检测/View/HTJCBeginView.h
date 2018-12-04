//
//  HTJCBeginView.h
//  HTJCFaceDetect
//
//  Created by LiMu on 17/9/23.
//  Copyright (c) 2015年 HTJCLiveDetect. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^detectBeginBlock)(void);
typedef void(^detectBackBlock)(void);
typedef void(^detectQuitBlock)(void);
typedef void(^detectAginBlock)(void);
typedef void(^wifiShareBlock)(void);



@interface HTJCBeginView : UIView

@property (nonatomic, copy) detectBeginBlock beginBlock;
@property (nonatomic, copy) detectBackBlock backBlock;
@property (nonatomic, copy) detectQuitBlock quitBlock;
@property (nonatomic, copy) detectAginBlock againBlock;
@property (nonatomic, copy) wifiShareBlock wifishareBlock;
@property (nonatomic, strong) UIButton *backBtn;


-(void)changeToSuccessView:(UIImage *)img;

-(void)changeToImageCheckFailView:(UIImage *)img errorInfo:(NSString *)error;

-(void)changeToFailView:(UIImage *)img failedInfo:(NSString*)failedStr;

-(void)changeToBeginView;

-(UIView *)creatLoadingView;

@end
