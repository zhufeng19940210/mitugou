//  OrderListVC.m
//  mitugou
//  Created by zhufeng on 2018/11/8.
//  Copyright © 2018 zhufeng. All rights reserved.
#import "OrderListVC.h"
#import "OrderDetailVC.h"
@interface OrderListVC ()<ZJScrollPageViewDelegate>
//横向滚动视图
@property (nonatomic, weak) ZJScrollPageView *scrollPageView;
@end
@implementation OrderListVC
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"我的订单";
    self.view.backgroundColor = RGB(240, 240, 240);
    [self setRightButton:[UIImage imageNamed:@"电话"]];
    OrderDetailVC  *vc1 = [[OrderDetailVC alloc]init];
    vc1.title = @"全部";
    vc1.status = @"";
    OrderDetailVC  *vc2 = [[OrderDetailVC alloc]init];
    vc2.title = @"待付款";
    vc2.status = @"0";
    OrderDetailVC  *vc3 = [[OrderDetailVC alloc]init];
    vc3.title = @"待发货";
    vc3.status = @"1";
    OrderDetailVC  *vc4 = [[OrderDetailVC alloc]init];
    vc4.title = @"待收货";
    vc4.status = @"2";
    OrderDetailVC  *vc5 = [[OrderDetailVC alloc]init];
    vc5.title = @"已完成";
    vc5.status = @"3";
    [self addChildViewController:vc1];
    [self addChildViewController:vc2];
    [self addChildViewController:vc3];
    [self addChildViewController:vc4];
    [self addChildViewController:vc5];
    self.scrollPageView.backgroundColor = RGB(240, 240, 240);
}
#pragma mark - getter

- (ZJScrollPageView *)scrollPageView
{
    if(_scrollPageView == nil)
    {
        ZJSegmentStyle *style = [[ZJSegmentStyle alloc] init];
        //显示滚动条
        style.showLine = YES;
        // 颜色渐变
        style.gradualChangeTitleColor = YES;
        style.contentViewBounces = NO;
        style.animatedContentViewWhenTitleClicked = NO;
        style.autoAdjustTitlesWidth = YES;
        style.scrollLineColor = MainThemeColor;
        style.selectedTitleColor = MainThemeColor;
        style.normalTitleColor = RGB(100,100,100);
        style.titleFont = [UIFont systemFontOfSize:16];
        ZJScrollPageView *scrollPageView = [[ZJScrollPageView alloc] initWithFrame:CGRectMake(0, 0, IPHONE_WIDTH, IPHONE_HEIGHT-64) segmentStyle:style titles:[self.childViewControllers valueForKey:@"title"] parentViewController:self delegate:self withColor:[UIColor whiteColor]];
        [self.view addSubview:scrollPageView];
        _scrollPageView = scrollPageView;
        //滚动的页面
        //[scrollPageView setSelectedIndex:_index animated:NO];
    }
    return _scrollPageView;
}
#pragma mark - ZJScrollPageViewDelegate
- (NSInteger)numberOfChildViewControllers {
    return self.childViewControllers.count;
}
- (UIViewController <ZJScrollPageViewChildVcDelegate> *)childViewController:(UIViewController<ZJScrollPageViewChildVcDelegate> *)reuseViewController forIndex:(NSInteger)index {
    UIViewController<ZJScrollPageViewChildVcDelegate> *childVc = reuseViewController;
    if (!childVc) {
        childVc = self.childViewControllers[index];
    }
    return childVc;
}
- (BOOL)shouldAutomaticallyForwardAppearanceMethods{
    return NO;
}
@end
