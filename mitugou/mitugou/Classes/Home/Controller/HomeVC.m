//  HomeVC.m
//  mitugou
//  Created by zhufeng on 2018/11/3.
//  Copyright © 2018年 zhufeng. All rights reserved.
#import "HomeVC.h"
#import "HomeNavTopView.h"
#import "HomeAdCell.h"
#import "HomeTypeCell.h"
#import "HomerecommendCell.h"
#import "HomeProductCell.h"
#import "HomeOtherCell.h"
#import "HomeForyouCell.h"
#import "HomeMessageVC.h"
#import "HomeSortVC.h"
#import "HomeSearchVC.h"
#import "HomeEngineVC.h"
#import "HomeSysInfo.h"
#import "HomeBaaner.h"
#import "HomeRecommandModel.h"
#import <SDWebImage/UIButton+WebCache.h>
#import "SettingTestLimuEducationVC.h"
#import "HomeProductDetailVC.h"
@interface HomeVC ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic,strong)NSMutableArray *imageArray;
@property (nonatomic,strong)NSMutableArray *titleArray;
@property (nonatomic,strong)NSDictionary   *dataParam;
@property (nonatomic,strong)NSMutableArray *recommandArray;
@property (nonatomic,strong)HomeNavTopView *topView;
@property (weak, nonatomic) IBOutlet UIImageView *home_img;
@end
@implementation HomeVC

-(NSMutableArray *)recommandArray
{
    if (!_recommandArray) {
        _recommandArray = [NSMutableArray array];
    }
    return _recommandArray;
}
-(NSMutableArray *)titleArray
{
    if (!_titleArray) {
        _titleArray = [NSMutableArray array];
    }
    return _titleArray;
}
-(NSMutableArray *)imageArray
{
    if (!_imageArray) {
        _imageArray = [NSMutableArray array];
    }
    return _imageArray;
}
//- (void)viewWillAppear:(BOOL)animated
//{
//    [super viewWillAppear:animated];
//    [self.navigationController setNavigationBarHidden:YES animated:animated];
//}
//- (void)viewWillDisappear:(BOOL)animated
//{
//    [super viewWillDisappear:animated];
//    [self.navigationController setNavigationBarHidden:NO animated:animated];
//}
//    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
//    self.navigationController.navigationBar.shadowImage = [[UIImage alloc] init];
//[self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
//self.navigationController.navigationBar.shadowImage = [[UIImage alloc] init];
- (void)viewDidLoad {
    [super viewDidLoad];
    //请求数据
    [self actionHomeData];
    [self setupRefresh];
    //初始化collectionView
    [self setupCollectionView];
    //初始化导航栏
    [self configNavigationBar];
}
- (void)configNavigationBar
{
    [self setLeftButton:[UIImage imageNamed:@"home_sort_white"]];
    [self setRightButton:[UIImage imageNamed:@"home_message_white"]];
    UIButton *searchButton = [UIButton buttonWithType:UIButtonTypeCustom];
    searchButton.frame = CGRectMake(0, 0, IPHONE_WIDTH*0.7, 34);
    searchButton.backgroundColor = RGB(240, 240, 240);
    searchButton.layer.cornerRadius = 10.0f;
    searchButton.layer.masksToBounds = YES;
    [searchButton setTitle:@"搜索你想要的东西" forState:0];
    [searchButton setTitleColor:[UIColor lightGrayColor] forState:0];
    searchButton.titleLabel.font = [UIFont systemFontOfSize:13];
    [searchButton setImage:[UIImage imageNamed:@"home_search_gary"] forState:0];
    [searchButton adjustsImageWhenHighlighted];
    searchButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    searchButton.titleEdgeInsets = UIEdgeInsetsMake(0, 2 * 10, 0, 0);
    searchButton.imageEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
    [searchButton addTarget:self action:@selector(searchButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.titleView = searchButton;
}
/**
 leftButton方法
 @param button leftbutton方法
 */
- (void)onLeftBtnAction:(UIButton *)button
{
    HomeSortVC *sortvc = [[HomeSortVC alloc]init];
    [self.navigationController pushViewController:sortvc animated:YES];
}
/**
 rightButton
 @param button rightButton的方法
 */
- (void)onRightBtnAction:(UIButton *)button
{
    HomeMessageVC *messagevc = [[HomeMessageVC alloc]init];
    [self.navigationController pushViewController:messagevc animated:YES];
}
/**
 搜索的方法button
 @param button 搜索的方法
 */
-(void)searchButtonClick:(UIButton *)button
{
    HomeSearchVC *searchvc = [[HomeSearchVC alloc]init];
    [self.navigationController pushViewController:searchvc animated:YES];
}
/**
 下拉刷新
 */
-(void)setupRefresh
{
     [self setViewRefreshColletionView:self.collectionView withHeaderAction:@selector(actionHomeData) andFooterAction:nil target:self];
}
/**
 下拉加载更多图片
 */
-(void)actionHomeData
{
    [self setupAdverData];
    [self setupHomeIndex];
    [self setupHomeSysInfo];
    [self setupHomeRecommand];
}
/**
 请求轮播图片
 */
-(void)setupAdverData
{
    [SVProgressHUD show];
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    WEAKSELF
    [[NetWorkTool shareInstacne]postWithURLString:Home_Banner parameters:param success:^(id  _Nonnull responseObject) {
        NSLog(@"轮播:%@",responseObject);
        [SVProgressHUD dismiss];
        ResponeModel *res = [ResponeModel mj_objectWithKeyValues:responseObject];
        if (res.code == 1) {
            [weakSelf.imageArray removeAllObjects];
            NSArray *arr1 = res.data[@"sowingMap"];
            for (NSDictionary *subDic in arr1) {
                HomeBaaner *model = [[HomeBaaner alloc]initWithDataModel:subDic];
                NSString *urlStr = [NSString stringWithFormat:@"%@",model.value];
                [weakSelf.imageArray addObject:urlStr];
            }
            [weakSelf.collectionView reloadData];
            [weakSelf.collectionView.mj_header endRefreshing];
        }else{
        }
    } failure:^(NSError * _Nonnull error) {
        [SVProgressHUD dismiss];
        [SVProgressHUD showErrorWithStatus:FailRequestTip];
        [weakSelf.collectionView.mj_header endRefreshing];
        return;
    }];
}
/**
 请求8张图片
 */
-(void)setupHomeIndex
{
    [SVProgressHUD show];
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    WEAKSELF
    [[NetWorkTool shareInstacne]postWithURLString:Home_Index parameters:param success:^(id  _Nonnull responseObject) {
        [SVProgressHUD dismiss];
        ResponeModel *res = [ResponeModel mj_objectWithKeyValues:responseObject];
        if (res.code == 1) {
            weakSelf.dataParam = res.data;
            [weakSelf.collectionView.mj_header endRefreshing];
            [weakSelf.collectionView reloadData];
        }else{
        }
    } failure:^(NSError * _Nonnull error) {
        [SVProgressHUD dismiss];
        [SVProgressHUD showErrorWithStatus:FailRequestTip];
        [weakSelf.collectionView.mj_header endRefreshing];
        return;
    }];
}
/**
 请求系统消息
 */
-(void)setupHomeSysInfo
{
    [SVProgressHUD show];
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    WEAKSELF
    [[NetWorkTool shareInstacne]postWithURLString:Home_SystemInfo parameters:param success:^(id  _Nonnull responseObject) {
        [SVProgressHUD dismiss];
        ResponeModel *res = [ResponeModel mj_objectWithKeyValues:responseObject];
        if (res.code == 1) {
            [weakSelf.titleArray removeAllObjects];
            NSArray *arr1 = res.data[@"data"];
            for (NSDictionary *subDic in arr1) {
                HomeSysInfo *model = [[HomeSysInfo alloc]initWithDataModel:subDic];
                NSString *title = [NSString stringWithFormat:@"%@",model.value];
                [weakSelf.titleArray addObject:title];
            }
            [weakSelf.collectionView reloadData];
            [weakSelf.collectionView.mj_header endRefreshing];
        }else{
        }
    } failure:^(NSError * _Nonnull error) {
        [SVProgressHUD dismiss];
        [SVProgressHUD showErrorWithStatus:FailRequestTip];
        [weakSelf.collectionView.mj_header endRefreshing];
        return;
    }];
}
//为你推荐
-(void)setupHomeRecommand
{
    [SVProgressHUD show];
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    WEAKSELF
    [[NetWorkTool shareInstacne]postWithURLString:Home_Recommnad parameters:param success:^(id  _Nonnull responseObject) {
        NSLog(@"responseobject:%@",responseObject);
        [SVProgressHUD dismiss];
        ResponeModel *res = [ResponeModel mj_objectWithKeyValues:responseObject];
        if (res.code == 1) {
            [weakSelf.recommandArray removeAllObjects];
            weakSelf.recommandArray = [HomeRecommandModel mj_objectArrayWithKeyValuesArray:res.data[@"commodirys"]];
            [weakSelf.collectionView reloadData];
            [weakSelf.collectionView.mj_header endRefreshing];
        }else{
        }
    } failure:^(NSError * _Nonnull error) {
        [SVProgressHUD dismiss];
        [SVProgressHUD showErrorWithStatus:FailRequestTip];
        [weakSelf.collectionView.mj_header endRefreshing];
        return;
    }];
}
//初始化导航栏
-(void)setupHomeNav
{
    _topView = [[HomeNavTopView alloc]initWithFrame:CGRectMake(0, 0, IPHONE_WIDTH, Height_NavBar)];
    WEAKSELF
    _topView.leftblock = ^(UIButton *btn) {
        HomeSortVC *sortvc = [[HomeSortVC alloc]init];
        [weakSelf.navigationController pushViewController:sortvc animated:YES];
    };
    _topView.rightblock = ^(UIButton *btn) {
        HomeMessageVC *messagevc = [[HomeMessageVC alloc]init];
        [weakSelf.navigationController pushViewController:messagevc animated:YES];
    };
    _topView.searchblock = ^(UIButton *btn) {
        HomeSearchVC *searchvc = [[HomeSearchVC alloc]init];
        [weakSelf.navigationController pushViewController:searchvc animated:YES];
    };
    [self.view addSubview:_topView];
}
//初始化collectionView
-(void)setupCollectionView
{
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.backgroundColor = [UIColor clearColor];
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([HomeAdCell class]) bundle:nil] forCellWithReuseIdentifier:@"HomeAdCell"];
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([HomeTypeCell class]) bundle:nil] forCellWithReuseIdentifier:@"HomeTypeCell"];
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([HomerecommendCell class]) bundle:nil] forCellWithReuseIdentifier:@"HomerecommendCell"];
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([HomeProductCell class]) bundle:nil] forCellWithReuseIdentifier:@"HomeProductCell"];
       [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([HomeForyouCell class]) bundle:nil] forCellWithReuseIdentifier:@"HomeForyouCell"];
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([HomeOtherCell class]) bundle:nil] forCellWithReuseIdentifier:@"HomeOtherCell"];
}

#pragma mark UICollectionViewDelegate || UICollectionViewDataSource
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 6;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (section == 0 || section == 1 || section == 2 || section == 3 || section == 4) {
        return 1;
    }else{
        return self.recommandArray.count;
    }
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{   UICollectionViewCell *homeCell = nil;
    if (indexPath.section == 0) {
        HomeAdCell *adcell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HomeAdCell" forIndexPath:indexPath];
        adcell.ulrArray = self.imageArray;
        adcell.cycleScrollView.backgroundColor = RGB(208, 208, 208);
        adcell.cycleScrollView.placeholderImage = [UIImage imageNamed:@"app_placeholder3.png"];
        homeCell = adcell;
    }
    if (indexPath.section == 1) {
        HomeTypeCell *typeCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HomeTypeCell" forIndexPath:indexPath];
        [typeCell.left_btn sd_setImageWithURL:[NSURL URLWithString:self.dataParam[User_AreaLeft]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"app_placeholder3.png"]];
        [typeCell.right_btn sd_setImageWithURL:[NSURL URLWithString:self.dataParam[User_AreaRight]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"app_placeholder3.png"]];
        typeCell.actionCallback = ^(HomeType type) {
            if (type == HomeTypeCar) {
                //机车专区
                HomeEngineVC *enginevc = [[HomeEngineVC alloc]init];
                enginevc.type = 2;
                [self.navigationController pushViewController:enginevc animated:YES];
            }else{
                //手机专区
                HomeEngineVC *phonevc = [[HomeEngineVC alloc]init];
                phonevc.type = 1;
                [self.navigationController pushViewController:phonevc animated:YES];
            }
        };
        homeCell = typeCell;
    }
    if (indexPath.section == 2) {
        HomerecommendCell *recommandCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HomerecommendCell" forIndexPath:indexPath];
        [recommandCell.home_img1 sd_setImageWithURL:[NSURL URLWithString:self.dataParam[User_Recommend1]] placeholderImage:[UIImage imageNamed:@"app_placeholder3"]];
        [recommandCell.home_img2 sd_setImageWithURL:[NSURL URLWithString:self.dataParam[User_Recommend2]] placeholderImage:[UIImage imageNamed:@"app_placeholder3"]];
        [recommandCell.home_img3 sd_setImageWithURL:[NSURL URLWithString:self.dataParam[User_Recommend3]] placeholderImage:[UIImage imageNamed:@"app_placeholder3"]];
        recommandCell.adscrollview.titles = self.titleArray;
        recommandCell.adscrollview.titleColor = [UIColor redColor];
        recommandCell.adscrollview.textAlignment = NSTextAlignmentLeft;
        homeCell = recommandCell;
    }
    if (indexPath.section == 3) {
        HomeProductCell *prductCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HomeProductCell" forIndexPath:indexPath];
        [prductCell.hot_img sd_setImageWithURL:[NSURL URLWithString:self.dataParam[User_HotLeft]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"app_placeholder.png"]];
        [prductCell.hot_up_img sd_setImageWithURL:[NSURL URLWithString:self.dataParam[User_HotRightUp]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"app_placeholder3"]];
        [prductCell.hot_down_img sd_setImageWithURL:[NSURL URLWithString:self.dataParam[User_HotRightDown]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"app_placeholder3"]];
        prductCell.actionCallback = ^(HomeProduct type) {
            if (type == HomeProductHot) {
                //手机热卖
                HomeEngineVC *phonevc  = [[HomeEngineVC alloc]init];
                phonevc.type = 1;
                [self.navigationController pushViewController:phonevc animated:YES];
            }else if (type == HomeProductCar){
                //机车
                HomeEngineVC *enginevc = [[HomeEngineVC alloc]init];
                enginevc.type = 2;
                [self.navigationController pushViewController:enginevc animated:YES];
            }else if (type == HomeProductPeijian){
                //机车配件
                HomeEngineVC *peijianvc = [[HomeEngineVC alloc]init];
                peijianvc.type = 3;
                [self.navigationController pushViewController:peijianvc animated:YES];
            }
        };
        homeCell = prductCell;
    }
    if (indexPath.section == 4) {
        HomeForyouCell *foryouCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HomeForyouCell" forIndexPath:indexPath];
        homeCell = foryouCell;
    }
    if (indexPath.section ==5) {
        HomeOtherCell *otherCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HomeOtherCell" forIndexPath:indexPath];
        HomeRecommandModel *model = self.recommandArray[indexPath.row];
        [otherCell.content_img sd_setImageWithURL:[NSURL URLWithString:model.photo] placeholderImage:[UIImage imageNamed:@"app_placeholder3.png"]];
        homeCell = otherCell;
    }
    return homeCell;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 5) {
        HomeRecommandModel *model = self.recommandArray[indexPath.row];
        HomeProductDetailVC *detailvc = [[HomeProductDetailVC alloc]init];
        detailvc.productID = model.cid;
        [self.navigationController pushViewController:detailvc animated:YES];
    }
}
#pragma mark - item宽高
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return CGSizeMake(IPHONE_WIDTH, 200);
    }
    if (indexPath.section == 1) {
        return CGSizeMake(IPHONE_WIDTH, 70);
    }
    if (indexPath.section == 2) {
        return CGSizeMake(IPHONE_WIDTH, 100);
    }
    if (indexPath.section ==3) {
        return CGSizeMake(IPHONE_WIDTH, 140);
    }
    if (indexPath.section == 4) {
        return CGSizeMake(IPHONE_WIDTH, 40);
    }
    if (indexPath.section ==5) {
        return CGSizeMake(IPHONE_WIDTH, 110);
    }
    return CGSizeZero;
}
#pragma mark - <UIScrollViewDelegate>
//- (void)scrollViewDidScroll:(UIScrollView *)scrollView
//{
//    if (scrollView.contentOffset.y > Height_NavBar) {
//        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
//        [[NSNotificationCenter defaultCenter]postNotificationName:SHOWTOPTOOLVIEW object:nil];
//    }else{
//        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
//        [[NSNotificationCenter defaultCenter]postNotificationName:HIDETOPTOOLVIEW object:nil];
//    }
//}
@end
