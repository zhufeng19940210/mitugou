//  GuiideVC.m
//  mitugou
//  Created by zhufeng on 2018/11/3.
//  Copyright © 2018年 zhufeng. All rights reserved.
#import "GuiideVC.h"
#import "LoginVC.h"
@interface GuiideVC ()<UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *scrollview;
@end

@implementation GuiideVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupScrollView];
}
-(void)setupScrollView
{
    self.scrollview.contentSize = CGSizeMake(IPHONE_WIDTH * 3, IPHONE_HEIGHT);
    self.scrollview.pagingEnabled = YES;
    self.scrollview.delegate = self;
    self.scrollview.showsHorizontalScrollIndicator = NO;
    self.scrollview.showsVerticalScrollIndicator = NO;
    self.scrollview.bounces = NO;
    UIImageView *imageView1 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"zf_1"]];
    [self.scrollview addSubview:imageView1];
    imageView1.frame = CGRectMake(0, 0, IPHONE_WIDTH, IPHONE_HEIGHT);
    imageView1.contentMode = UIViewContentModeScaleAspectFill;
    
    UIImageView *imageView2 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"zf_2"]];
    [self.scrollview addSubview:imageView2];
    imageView2.frame = CGRectMake(IPHONE_WIDTH, 0, IPHONE_WIDTH, IPHONE_HEIGHT);
    imageView2.contentMode = UIViewContentModeScaleAspectFill;
    
    UIImageView *imageView3 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"zf_3"]];
    [self.scrollview addSubview:imageView3];
    imageView3.frame = CGRectMake(IPHONE_WIDTH *2, 0, IPHONE_WIDTH, IPHONE_HEIGHT);
    imageView3.contentMode = UIViewContentModeScaleAspectFill;
    imageView3.userInteractionEnabled = YES;
    
    UIButton *button = [[UIButton alloc] init];
    [imageView3 addSubview:button];
    //    [button setTitle:@"立即开启" forState:UIControlStateNormal];
    //    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    //    [button setBackgroundColor:Gold1Color];
    //    button.layer.cornerRadius = 20;
    [button setImage:[UIImage imageNamed:@"start"] forState:UIControlStateNormal];
    button.frame = CGRectMake(0, 0, 180, 60);
    if (IS_IPHONE_X || IS_IPHONE_Xs) {
        button.center = CGPointMake(imageView2.frame.size.width * 0.5, imageView2.frame.size.height * 0.7);
    }else if (IS_IPHONE_Xr ||  IS_IPHONE_Xs_Max){
        button.center = CGPointMake(imageView2.frame.size.width * 0.5, imageView2.frame.size.height * 0.7);
    }else{
        button.center = CGPointMake(imageView2.frame.size.width * 0.5, imageView2.frame.size.height * 0.7);
    }
    [button addTarget:self action:@selector(enterBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
}

-(void)enterBtnClick
{
    LoginVC *loginvc = [[LoginVC alloc]init];
    [self.navigationController pushViewController:loginvc animated:YES];
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:ISFirst];
    [[NSUserDefaults standardUserDefaults]synchronize];
}
#pragma mark -UIScollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    long int page = lroundf(scrollView.contentOffset.x / scrollView.frame.size.width);
    NSLog(@"page:%d",page);
}
/**
 跳过的方法
 @param sender 跳过
 */
- (IBAction)actionSkipBtn:(UIButton *)sender
{
    LoginVC *loginvc = [[LoginVC alloc]init];
    [self.navigationController pushViewController:loginvc animated:YES];
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:ISFirst];
    [[NSUserDefaults standardUserDefaults]synchronize];
}

@end
