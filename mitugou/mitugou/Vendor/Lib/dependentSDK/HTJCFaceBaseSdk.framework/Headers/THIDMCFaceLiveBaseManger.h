//
//  THIDMCFaceLiveBaseManger.h
//  HTJCFaceBaseSdk
//
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface THIDMCFaceLiveBaseManger : NSObject

@property (nonatomic,strong,readonly) NSArray *liveDetectValueCache;
@property (nonatomic,assign,readonly) NSInteger LiveDetectionNum;

@property (nonatomic, assign) BOOL isRandom;
@property (nonatomic, strong) NSArray *liveDetectArr;
+(THIDMCFaceLiveBaseManger *)sharedManager;

-(void)initializedSdkSuccess:(void (^)(BOOL success))_sucessed failed:(void (^)(NSString *error))_failed;
- (void)getLiveDetectProcessPushed:(UIImage *)detectImage withCompletion:(void (^)(NSInteger procedueState, NSInteger returnVal))_completion failed:(void (^)(NSInteger state, NSInteger returnErr))_failed;
-(void)UnInitHTJCSDK;
-(NSData*)getEcryptFaceRectImage:(UIImage*)_image;
-(NSData*)getEcryptFaceRectImage:(UIImage*)_imageOne imageData:(NSData *)imageData;
- (NSData *)insertImage:(NSData *)imageData toImage:(NSData *)inputImageData;
- (NSData *)insertDetectName:(NSString *)detectName toImage:(NSData *)inputImageData;
-(CGRect)getFaceTHIDRectWithImage:(UIImage*)image;
- (void)getNextStepLiveDetection:(void (^)(NSInteger state))nextState;
- (float)getImageGuideScore;
- (float)getImageLiveScore:(UIImage *)resizeImage;

@end
