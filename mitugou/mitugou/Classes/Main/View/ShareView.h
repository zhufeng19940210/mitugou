//  ShareView.h
//  xiaochacha
//  Created by apple on 2018/10/24.
//  Copyright © 2018 HuiC. All rights reserved

#import <UIKit/UIKit.h>

@protocol ShareViewDelegate <NSObject>
-(void)shareWithTag:(int)tag;
@end
@interface ShareView : UIView
@property (nonatomic,weak)id <ShareViewDelegate> delegate;
-(void)shareViewShow;
-(void)shareViewHidden;
@end
