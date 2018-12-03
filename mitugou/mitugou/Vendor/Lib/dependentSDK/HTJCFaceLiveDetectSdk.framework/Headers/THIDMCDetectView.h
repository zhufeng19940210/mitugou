//
//  THIDMCDetectView.h
//  HTJCFaceLiveDetectSdk
//
//  Copyright © 2015年 HTJCLiveDetect. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@protocol THIDMCSetDetectViewDelegate <NSObject>

@required
- (UIView *)setNavigationView;
- (UIButton *)setBackButton;
- (UIView *)setFaceGuideView;
- (UILabel *)setLightGuideLabel;
- (UIView *)setLiveDetecteView;
- (UIView *)setNumberDownView;
-(void)beginMaskViewAnimation;
- (void)setBottomReminderText:(NSString *)remindStr;
- (void)setGoodNextAnimation;
- (void)setKeepStillAnimation;
- (void)setShakeHeadAnimation;
- (void)setNodHeadAnimation;
- (void)setOpenMouthAnimation;
- (void)setBlinkEyesAnimation;
- (void)beginProgressView;
- (void)stopProgressView;
- (void)endProgressView;


@end

