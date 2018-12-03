//
//  THIDMCHTJCViewManger.h
//  THIDMCHTJCViewManger
//
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface THIDMCHTJCViewManger : NSObject

+(THIDMCHTJCViewManger *)sharedManager:(UIViewController*)_vc;
-(void)getLiveDetectCompletion:(void (^)(BOOL success,NSData * imageData))_completion
                        cancel:(void(^)(BOOL success, NSError* error))_cancel
                        failed:(void (^)(NSError *error,NSData *imageData))_failed;
-(void)dismissTakeCaptureSessionViewController;
- (void)navigationType:(int)navType;
- (void)liveDetectTypeArray:(NSArray *)liveDetectTypeArray;
- (void)isNeedRandom:(BOOL)isRandom;
- (void)setDetectViewListener:(id)delegate;
- (NSString *)getBundleVersion;
- (NSString *)getSDKVersion;

@end
