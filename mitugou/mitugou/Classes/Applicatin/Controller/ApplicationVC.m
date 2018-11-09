//  ApplicationVC.m
//  mitugou
//  Created by zhufeng on 2018/11/3.
//  Copyright © 2018年 zhufeng. All rights reserved.
#import "ApplicationVC.h"
#import "ApplicationHeaderCell.h"
#import "ApplicationproductCell.h"
#import "HomeProductDetailVC.h"
#import "SettingAuthonVC.h"
@interface ApplicationVC ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionview;
@property (nonatomic,strong)NSMutableArray *applicationArray;
@end
@implementation ApplicationVC
-(NSMutableArray *)applicationArray
{
    if (!_applicationArray) {
        _applicationArray = [NSMutableArray array];
    }
    return _applicationArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"额度";
    //请求数据
    [self setupData];
    //初始化collectionview
    [self setupCollectionView];
}
#pragma mark --请求数据
-(void)setupData
{
    
}
//初始化collectionview
-(void)setupCollectionView
{
    self.collectionview.delegate = self;
    self.collectionview.dataSource = self;
    self.collectionview.backgroundColor = RGB(240, 240, 240);
    [self.collectionview registerNib:[UINib nibWithNibName:NSStringFromClass([ApplicationHeaderCell class]) bundle:nil] forCellWithReuseIdentifier:@"ApplicationHeaderCell"];
    [self.collectionview registerNib:[UINib nibWithNibName:NSStringFromClass([ApplicationproductCell class]) bundle:nil] forCellWithReuseIdentifier:@"ApplicationproductCell"];
}
#pragma mark UICollectionViewDelegate || UICollectionViewDataSource
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 2;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (section == 0) {
        return  1;
    }else{
        return 4;
    }
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *applicationCell = nil;
    if (indexPath.section == 0) {
        //我的额度
        ApplicationHeaderCell *headerCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ApplicationHeaderCell" forIndexPath:indexPath];
        headerCell.actionBlock = ^(UIButton *btn) {
            ///todo这里要做的跳转请求
            [self requestActionBtn];
        };
        applicationCell = headerCell;
    }else if (indexPath.section == 1){
        //商品推荐
        ApplicationproductCell *productCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ApplicationproductCell" forIndexPath:indexPath];
        applicationCell = productCell;
    }
    return applicationCell;
}
#pragma mark - item宽高
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return  CGSizeMake(IPHONE_WIDTH, 310);
    }else{
        return CGSizeMake(IPHONE_WIDTH/2-5,220);
    }
    return CGSizeZero;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1) {
        HomeProductDetailVC *productvc = [[HomeProductDetailVC alloc]init];
        [self.navigationController pushViewController:productvc animated:YES];
    }
}
#pragma mark -- requestActionBtn
-(void)requestActionBtn
{   //1.这里请求接口,判断是否认证的数据
    //2.如果认证成功了就显示成功
    //3.如果申请过了等待结果
    //4.如果失败再次申请去申请，这里只是测试罢了
    SettingAuthonVC *authonvc = [[SettingAuthonVC alloc]init];
    [self.navigationController pushViewController:authonvc animated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
@end
