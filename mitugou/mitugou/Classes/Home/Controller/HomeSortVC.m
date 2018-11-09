//  HomeSortVC.m
//  mitugou
//  Created by zhufeng on 2018/11/7.
//  Copyright © 2018 zhufeng. All rights reserved.
#import "HomeSortVC.h"
#import "ApplicationproductCell.h"
#import "ProductTypeCell.h"
#import "HomeProductDetailVC.h"
#import "HomeEngineVC.h"
@interface HomeSortVC ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic,strong)NSMutableArray *jicheArray;
@property (nonatomic,strong)NSMutableArray *phoneArray;
@property (nonatomic,strong)NSMutableArray *peijianArray;
@end
@implementation HomeSortVC
-(NSMutableArray *)jicheArray
{
    if (!_jicheArray) {
        _jicheArray = [NSMutableArray array];
    }
    return _jicheArray;
}
-(NSMutableArray *)phoneArray
{
    if (!_phoneArray) {
        _phoneArray = [NSMutableArray array];
    }
    return _phoneArray;
}
-(NSMutableArray *)peijianArray
{
    if (!_peijianArray) {
        _peijianArray = [NSMutableArray array];
    }
    return _peijianArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"商品分类";
    [self setupData];
    [self setupCollectionView];
}
//请求数据
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
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([ProductTypeCell class]) bundle:nil] forCellWithReuseIdentifier:@"ProductTypeCell"];
}

#pragma mark UICollectionViewDelegate || UICollectionViewDataSource
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 6;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (section == 0 || section == 2 || section == 4) {
        return 1;
    }else if (section == 1){
        return 4;
        //return self.jicheArray.count;
    }else if (section == 3){
        return  4;
        //return self.peijianArray.count;
    }else if (section == 5){
        return 4;
        //return self.phoneArray.count;
    }else{
        return 0;
    }
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *sortCell = nil;
    if (indexPath.section == 0) {
        ProductTypeCell *typeCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ProductTypeCell" forIndexPath:indexPath];
        typeCell.type_lab.text = @"机车专区";
        typeCell.actionCallback = ^(UIButton *button) {
            HomeEngineVC *enginvc = [[HomeEngineVC alloc]init];
            enginvc.type = 0;
            [self.navigationController pushViewController:enginvc animated:YES];
        };
        sortCell = typeCell;
    }else if (indexPath.section == 1){
        //机车类别
        ApplicationproductCell *jichenCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ApplicationproductCell" forIndexPath:indexPath];
        jichenCell.icon_img.image = [UIImage imageNamed:@"app_default.png"];
        sortCell = jichenCell;
    }else if (indexPath.section == 2){
        ProductTypeCell *typeCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ProductTypeCell" forIndexPath:indexPath];
        typeCell.type_lab.text = @"配件专区";
        typeCell.actionCallback = ^(UIButton *button) {
            HomeEngineVC *peijianvc = [[HomeEngineVC alloc]init];
            peijianvc.type = 1;
            [self.navigationController pushViewController:peijianvc animated:YES];
        };
        sortCell = typeCell;
    }else if(indexPath.section == 3){
        //配件类型
        ApplicationproductCell *peijianCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ApplicationproductCell" forIndexPath:indexPath];
        peijianCell.icon_img.image = [UIImage imageNamed:@"app_peijian.png"];
        sortCell = peijianCell;
    }else if (indexPath.section == 4){
        ProductTypeCell *typeCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ProductTypeCell" forIndexPath:indexPath];
        typeCell.type_lab.text = @"手机专区";
        typeCell.actionCallback = ^(UIButton *button) {
            HomeEngineVC *phonevc = [[HomeEngineVC alloc]init];
            phonevc.type = 2;
            [self.navigationController pushViewController:phonevc animated:YES];
        };
        sortCell = typeCell;
    }else if (indexPath.section == 5){
        //手机类型
        ApplicationproductCell *phoneCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ApplicationproductCell" forIndexPath:indexPath];
        phoneCell.icon_img.image = [UIImage imageNamed:@"app_phone.png"];
        sortCell = phoneCell;
    }
    return sortCell;
}
#pragma mark - item宽高
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0 || indexPath.section == 2 || indexPath.section==4) {
        return  CGSizeMake(IPHONE_WIDTH, 40);
    }else if (indexPath.section == 1 || indexPath.section == 3 || indexPath.section == 5){
        return CGSizeMake(IPHONE_WIDTH/2-5,220);
    }
    return CGSizeZero;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    HomeProductDetailVC *productdetailvc = [[HomeProductDetailVC alloc]init];
    [self.navigationController pushViewController:productdetailvc animated:YES];
}
@end
