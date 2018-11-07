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
#import "HomeAccessoryVC.h"
#import "HomePhoneVC.h"
#import "HomeEngineVC.h"
@interface HomeVC ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic,strong)NSArray *imageArray;
@property (nonatomic,strong)NSArray *titleArray;
@property (nonatomic,strong)HomeNavTopView *topView;
@end
@implementation HomeVC
-(NSArray *)titleArray
{
    if (!_titleArray) {
        _titleArray = [NSArray arrayWithObjects:@"京东、天猫等 app 首页常见的广告滚动视图",@"采用代理设计模式进行封装, 可进行事件点击处理,测试数就测试就减肥法解决",@"建议在 github 上下载建议在 github 上下载建议在 github 上下载建议在 github 上下载", nil];
    }
    return _titleArray;
}
-(NSArray *)imageArray {
    if (!_imageArray) {
        _imageArray = [NSArray arrayWithObjects:@"home_banner",@"home_banner", nil];
    }
    return _imageArray;
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    //[UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    //[UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //请求数据
    [self setupData];
    //初始化collectionView
    [self setupCollectionView];
    //初始化导航栏
    [self setupHomeNav];
}
//请求数据
-(void)setupData{
    
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
        return 2;
    }
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{   UICollectionViewCell *homeCell = nil;
    if (indexPath.section == 0) {
        HomeAdCell *adcell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HomeAdCell" forIndexPath:indexPath];
        adcell.ulrArray = self.imageArray;
        homeCell = adcell;
    }
    if (indexPath.section == 1) {
        HomeTypeCell *typeCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HomeTypeCell" forIndexPath:indexPath];
        typeCell.actionCallback = ^(HomeType type) {
            if (type == HomeTypeCar) {
                //机车专区
                HomeEngineVC *enginevc = [[HomeEngineVC alloc]init];
                [self.navigationController pushViewController:enginevc animated:YES];
            }else{
                //手机专区
                HomePhoneVC *phonevc = [[HomePhoneVC alloc]init];
                [self.navigationController pushViewController:phonevc animated:YES];
            }
        };
        homeCell = typeCell;
    }
    if (indexPath.section == 2) {
        HomerecommendCell *recommandCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HomerecommendCell" forIndexPath:indexPath];
        recommandCell.adscrollview.titles = self.titleArray;
        recommandCell.adscrollview.titleColor = [UIColor redColor];
        recommandCell.adscrollview.textAlignment = NSTextAlignmentLeft;
        homeCell = recommandCell;
    }
    if (indexPath.section == 3) {
        HomeProductCell *prductCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HomeProductCell" forIndexPath:indexPath];
        prductCell.actionCallback = ^(HomeProduct type) {
            if (type == HomeProductHot) {
                //手机热卖
                HomePhoneVC *phonevc = [[HomePhoneVC alloc]init];
                [self.navigationController pushViewController:phonevc animated:YES];
            }else if (type == HomeProductCar){
                //机车
                HomeEngineVC *enginevc = [[HomeEngineVC alloc]init];
                [self.navigationController pushViewController:enginevc animated:YES];
            }else if (type == HomeProductPeijian){
                //机车配件
                HomeAccessoryVC *accessoryvc = [[HomeAccessoryVC alloc]init];
                [self.navigationController pushViewController:accessoryvc animated:YES];
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
        if (indexPath.row == 0) {
            otherCell.content_img.image = [UIImage imageNamed:@"home_other2"];
        }else{
            otherCell.content_img.image = [UIImage imageNamed:@"home_other"];
        }
        homeCell = otherCell;
    }
    return homeCell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 5) {
        if (indexPath.row == 0) {
            //手机热卖
        }else{
            //脐橙热卖
        }
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
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.contentOffset.y > Height_NavBar) {
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
        [[NSNotificationCenter defaultCenter]postNotificationName:SHOWTOPTOOLVIEW object:nil];
    }else{
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
        [[NSNotificationCenter defaultCenter]postNotificationName:HIDETOPTOOLVIEW object:nil];
    }
}
@end
