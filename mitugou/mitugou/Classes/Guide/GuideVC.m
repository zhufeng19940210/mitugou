//  GuideVC.m
//  YDXZ
//  Created by bailing on 2018/7/5.
//  Copyright © 2018年 niecong. All rights reserved.
#import "GuideVC.h"
#import "LoginVC.h"
#import "AppDelegate.h"
@interface GuideVC ()<UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *scrollview;
@property (weak, nonatomic) IBOutlet UIPageControl *pagecontrol;
@end
@implementation GuideVC
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}
-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}
#pragma mark - 系统方法
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self setupScrollView];
    [self setupWelceomPageView];
}
-(void)setupScrollView
{   self.scrollview.contentSize = CGSizeMake(IPHONE_WIDTH * 2, IPHONE_HEIGHT);
    self.scrollview.pagingEnabled = YES;
    self.scrollview.delegate = self;
    self.scrollview.showsHorizontalScrollIndicator = NO;
    self.scrollview.showsVerticalScrollIndicator = NO;
    self.scrollview.bounces = NO;
    UIImageView *imageView1 = [[UIImageView alloc]init];
    UIImageView *imageView2 = [[UIImageView alloc] init];
    if (IS_IPHONE_X || IS_IPHONE_Xs) {
        imageView1.image = [UIImage imageNamed:@"Guide1_x"];
        imageView2.image = [UIImage imageNamed:@"Guide2_x"];
    }else if(IS_IPHONE_Xs_Max){
        imageView1.image = [UIImage imageNamed:@"Guide1_xr"];
        imageView2.image = [UIImage imageNamed:@"Guide2_xr"];
    }else if(IS_IPHONE_Xr){
        imageView1.image = [UIImage imageNamed:@"Guide1_xs"];
        imageView2.image = [UIImage imageNamed:@"Guide2_xs"];
    }else{
        imageView1.image = [UIImage imageNamed:@"Guide1"];
        imageView2.image = [UIImage imageNamed:@"Guide2"];
    }
    [self.scrollview addSubview:imageView1];
    imageView1.frame = CGRectMake(0, 0, IPHONE_WIDTH, IPHONE_HEIGHT);
    imageView1.contentMode = UIViewContentModeScaleAspectFill;
    
    [self.scrollview addSubview:imageView2];
    imageView2.frame = CGRectMake(IPHONE_WIDTH, 0, IPHONE_WIDTH, IPHONE_HEIGHT);
    imageView2.contentMode = UIViewContentModeScaleAspectFill;
    imageView2.userInteractionEnabled = YES;
    
    UIButton *button = [[UIButton alloc] init];
    button.frame = CGRectMake(0, 0, 130, 45);
    [button setTitle:@"立即体验" forState:UIControlStateNormal];
    [button setTintColor:[UIColor whiteColor]];
    button.layer.borderColor = [UIColor whiteColor].CGColor;
    button.layer.borderWidth = 1.0f;
    button.center = CGPointMake(imageView2.frame.size.width * 0.5, imageView2.frame.size.height * 0.8);
    [button addTarget:self action:@selector(enterBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [imageView2 addSubview:button];
}
-(void)enterBtnClick
{
    LoginVC *loginVC = [[LoginVC alloc]init];
    AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:loginVC];
    app.window.backgroundColor = [UIColor whiteColor];
    app.window.rootViewController = nav;
    [app.window makeKeyAndVisible];
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:ISFirst];
    [[NSUserDefaults standardUserDefaults]synchronize];
}
#pragma mark -UIScollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    long int page = lroundf(scrollView.contentOffset.x / scrollView.frame.size.width);
    NSLog(@"page:%ld",page);
}
- (void)setupWelceomPageView {
    self.pagecontrol.numberOfPages = 2;
    self.pagecontrol.currentPageIndicatorTintColor = [UIColor whiteColor];
    self.pagecontrol.pageIndicatorTintColor = [UIColor grayColor];
}
@end
