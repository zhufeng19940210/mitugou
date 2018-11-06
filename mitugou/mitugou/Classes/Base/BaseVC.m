//  BaseVC.m
//  mitugou
//  Created by zhufeng on 2018/11/3.
//  Copyright © 2018年 zhufeng. All rights reserved.
#import "BaseVC.h"
#import "UIScrollView+EmptyDataSet.h"
@interface BaseVC ()<DZNEmptyDataSetSource,DZNEmptyDataSetDelegate>
@end
@implementation BaseVC
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    // Do any additional setup after loading the view.
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
    {   self.edgesForExtendedLayout = UIRectEdgeNone;
        NSDictionary * attributes = @{
                                      NSForegroundColorAttributeName:[UIColor blackColor],
                                      NSFontAttributeName:[UIFont systemFontOfSize:17]
                                      };
        [self.navigationController.navigationBar setTitleTextAttributes:attributes];
        // 设置状态栏覆盖
        [self.navigationController.navigationBar setTranslucent:NO];
        // shadowline
//        [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
//        self.navigationController.navigationBar.shadowImage = [[UIImage alloc] init];
        //self.navigationController.navigationBar.barStyle = UIBarStyleBlackTranslucent;
        [self setNeedsStatusBarAppearanceUpdate];
    }
    [self setBackwardButton];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}
//返回按钮
- (void)setBackwardButton{
    NSArray *viewControllers = [self.navigationController viewControllers];
    if (viewControllers.count > 1) {
        UIImage *image =[UIImage imageNamed:@"return_back2"];
        UIImage *selectImage = [UIImage imageNamed:@"return_back2"];
        UIButton *leftBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 20, 40)];
        [leftBtn setImage:image forState:UIControlStateNormal];
        [leftBtn setImage:selectImage forState:UIControlStateHighlighted];
        leftBtn.imageEdgeInsets = UIEdgeInsetsMake(0.0, -5.0, 0.0, 5.0);
        [leftBtn addTarget:self action:@selector(onLeftBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
    }
}

#pragma mark - NavigationItem
- (void)setLeftButton:(UIImage *)image
{
    if (image) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setImage:image forState:UIControlStateNormal];
        // button size
        btn.frame = CGRectMake(0, 0, image.size.width, image.size.height);
        btn.imageEdgeInsets = UIEdgeInsetsMake(0.0, -4.0, 0.0, 4.0);
        // button target
        [btn addTarget:self action:@selector(onLeftBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        
        UIBarButtonItem *barItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
        self.navigationItem.leftBarButtonItem = barItem;
    } else {
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:[[UIView alloc]init]];
    }
}

- (void)setLeftButtonText:(NSString *)text withColor:(UIColor *)textColor
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn.titleLabel setFont:[UIFont systemFontOfSize:18.0f]];
    [btn setTitleColor:textColor forState:UIControlStateNormal];
    [btn setTitle:text forState:UIControlStateNormal];
    [btn sizeToFit];
    // button target
    [btn addTarget:self action:@selector(onLeftBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *barItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    self.navigationItem.leftBarButtonItem = barItem;
}

- (void)setRightButton:(UIImage *)image
{
    if (image) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setImage:image forState:UIControlStateNormal];
        // button size
        btn.frame = CGRectMake(0, 0, image.size.width, image.size.height);
        btn.imageEdgeInsets = UIEdgeInsetsMake(0.0, 4.0, 0.0, -4.0);
        // button target
        [btn addTarget:self action:@selector(onRightBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        
        UIBarButtonItem *barItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
        self.navigationItem.rightBarButtonItem = barItem;
    }else {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:[[UIView alloc]init]];
    }
}

/// 设置UINavbar右按钮(图片和文字)
- (void)setRightButton:(UIImage *)image withText:(NSString *)text
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setImage:image forState:UIControlStateNormal];
    [btn setTitle:text forState:UIControlStateNormal];
    [btn setTitleColor:ZF_Global_Color forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:15];
    // button size
    btn.frame = CGRectMake(0, 0, image.size.width+40, image.size.height);
    //btn.imageEdgeInsets = UIEdgeInsetsMake(0.0, 4.0, 0.0, -4.0);
    // button target
    [btn addTarget:self action:@selector(onRightBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *barItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    [btn setImagePosition:0 withInset:2];
    self.navigationItem.rightBarButtonItem = barItem;
}
- (void)setRightButtonText:(NSString *)text withColor:(UIColor *)textColor
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn.titleLabel setFont:[UIFont systemFontOfSize:16.0f]];
    [btn setTitleColor:textColor forState:UIControlStateNormal];
    [btn setTitle:text forState:UIControlStateNormal];
    [btn sizeToFit];
    btn.titleEdgeInsets = UIEdgeInsetsMake(0, 4, 0, -4);
    // button target
    [btn addTarget:self action:@selector(onRightBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *barItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    self.navigationItem.rightBarButtonItem = barItem;
}

#pragma mark - Actions

- (void)onLeftBtnAction:(UIButton *)button
{
    [self backViewController];
}

- (void)onRightBtnAction:(UIButton *)button
{
}

- (void)backViewController
{
    NSArray *viewControllers = [self.navigationController viewControllers];
    // 根据viewControllers的个数来判断此控制器是被present的还是被push的
    if (1 <= viewControllers.count && 0 < [viewControllers indexOfObject:self])
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
    else
    {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}
- (void)setViewRefresh:(UITableView *)tableView withHeaderAction:(SEL)hAction andFooterAction:(SEL)fAction target:(id)target{
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:target refreshingAction:hAction];
    header.lastUpdatedTimeLabel.hidden = YES;
    // 设置header
    tableView.mj_header = header;
    
    tableView.mj_footer = [MJRefreshAutoFooter footerWithRefreshingTarget:target refreshingAction:fAction];
    [self setEmptyTableView:tableView];
}

- (void)setEmptyTableView:(UITableView *)tableView{
    tableView.emptyDataSetSource = self;
    tableView.emptyDataSetDelegate = self;
}

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView {
    NSString *title = @"暂无数据";
    NSDictionary *attributes = @{
                                 NSFontAttributeName:[UIFont systemFontOfSize:17],
                                 NSForegroundColorAttributeName:[UIColor whiteColor]
                                 };
    return [[NSAttributedString alloc] initWithString:title attributes:attributes];
}

- (BOOL)emptyDataSetShouldAllowScroll:(UIScrollView *)scrollView{
    return YES;
}

- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray arrayWithCapacity:0];
    }
    return _dataArray;
}


@end
