//  HomeEngineVC.m
//  mitugou
//  Created by zhufeng on 2018/11/7.
//  Copyright © 2018 zhufeng. All rights reserved.
#import "HomeEngineVC.h"
#import "ApplicationproductCell.h"
#import "HomeProductDetailVC.h"
@interface HomeEngineVC ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic,strong)NSMutableArray *contentArray;
@end
@implementation HomeEngineVC
-(NSMutableArray *)contentArray
{
    if (!_contentArray) {
        _contentArray = [NSMutableArray array];
    }
    return _contentArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self configNavgationTitle];
    [self setupData];
    [self setupCollectionView];
}
-(void)configNavgationTitle
{  NSString *urlTitle = nil;
    if (self.type == 0) {
        urlTitle = @"机车专区";
    }else if(self.type == 1){
        urlTitle = @"配件专区";
    }else if (self.type == 2){
        urlTitle = @"手机专区";
    }
    self.navigationItem.title = urlTitle;
}
-(void)setupData
{
    
}
//初始化collectionview
-(void)setupCollectionView
{
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.backgroundColor = RGB(240, 240, 240);
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([ApplicationproductCell class]) bundle:nil] forCellWithReuseIdentifier:@"ApplicationproductCell"];
}
#pragma mark UICollectionViewDelegate || UICollectionViewDataSource
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 5;
   // return self.contentArray.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ApplicationproductCell *engineCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ApplicationproductCell" forIndexPath:indexPath];
    if (self.type == 0) {
        engineCell.icon_img.image = [UIImage imageNamed:@"app_default.png"];
    }else if (self.type == 1){
        engineCell.icon_img.image = [UIImage imageNamed:@"app_peijian.png"];
    }else if (self.type == 2){
        engineCell.icon_img.image = [UIImage imageNamed:@"app_phone.png"];
    }
    return engineCell;
}
#pragma mark - item宽高
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(IPHONE_WIDTH/2-5,220);
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    HomeProductDetailVC *productdetailvc = [[HomeProductDetailVC alloc]init];
    [self.navigationController pushViewController:productdetailvc animated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
@end
