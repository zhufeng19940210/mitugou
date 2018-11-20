//  HomeSortVC.m
//  mitugou
//  Created by zhufeng on 2018/11/7.
//  Copyright © 2018 zhufeng. All rights reserved.
#import "HomeSortVC.h"
#import "ApplicationproductCell.h"
#import "ProductTypeCell.h"
#import "HomeProductDetailVC.h"
#import "HomeEngineVC.h"
#import "ProductModel.h"
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
    [SVProgressHUD show];
    NSString *token = [[NSUserDefaults standardUserDefaults]valueForKey:ZF_TOKEN];
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"token"] = token;
    WEAKSELF
    [[NetWorkTool shareInstacne]postWithURLString:Product_All parameters:param success:^(id  _Nonnull responseObject) {
        NSLog(@"responsetobject:%@",responseObject);
        [SVProgressHUD dismiss];
        ResponeModel *res = [ResponeModel mj_objectWithKeyValues:responseObject];
        if (res.code==1) {
            [SVProgressHUD showSuccessWithStatus:@"获取成功"];
            [weakSelf.jicheArray removeAllObjects];
            [weakSelf.peijianArray removeAllObjects];
            [weakSelf.phoneArray removeAllObjects];
            weakSelf.phoneArray = [ProductModel mj_objectArrayWithKeyValuesArray:res.data[@"classifys"][0][@"commodirys"]];
            weakSelf.jicheArray = [ProductModel mj_objectArrayWithKeyValuesArray:res.data[@"classifys"][1][@"commodirys"]];
            weakSelf.peijianArray  = [ProductModel mj_objectArrayWithKeyValuesArray:res.data[@"classifys"][2][@"commodirys"]];
            NSLog(@"phoneArray.count:%lu,jicheArraycount:%d,peijianArray.count:%d",(unsigned long)self.phoneArray.count,self.jicheArray.count,self.peijianArray.count);
            [weakSelf.collectionView reloadData];
        }else{
            [SVProgressHUD showErrorWithStatus:@"获取失败"];
            return;
        }
    } failure:^(NSError * _Nonnull error) {
        [SVProgressHUD dismiss];
        [SVProgressHUD showErrorWithStatus:FailRequestTip];
        return;
    }];
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
        return self.jicheArray.count;
    }else if (section == 3){
        return self.peijianArray.count;
    }else if (section == 5){
        return self.phoneArray.count;
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
            enginvc.type = 2;
            [self.navigationController pushViewController:enginvc animated:YES];
        };
        sortCell = typeCell;
    }else if (indexPath.section == 1){
        //机车类别
        ApplicationproductCell *jichenCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ApplicationproductCell" forIndexPath:indexPath];
        ProductModel *model = self.jicheArray[indexPath.row];
        jichenCell.productModel = model;
        sortCell = jichenCell;
    }else if (indexPath.section == 2){
        ProductTypeCell *typeCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ProductTypeCell" forIndexPath:indexPath];
        typeCell.type_lab.text = @"配件专区";
        typeCell.actionCallback = ^(UIButton *button) {
            HomeEngineVC *peijianvc = [[HomeEngineVC alloc]init];
            peijianvc.type = 3;
            [self.navigationController pushViewController:peijianvc animated:YES];
        };
        sortCell = typeCell;
    }else if(indexPath.section == 3){
        //配件类型
        ApplicationproductCell *peijianCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ApplicationproductCell" forIndexPath:indexPath];
        NSLog(@"self.peijianArray.count:%lu",(unsigned long)self.peijianArray.count);
        ProductModel *model = self.peijianArray[indexPath.row];
        peijianCell.productModel = model;
        sortCell = peijianCell;
    }else if (indexPath.section == 4){
        ProductTypeCell *typeCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ProductTypeCell" forIndexPath:indexPath];
        typeCell.type_lab.text = @"手机专区";
        typeCell.actionCallback = ^(UIButton *button) {
            HomeEngineVC *phonevc = [[HomeEngineVC alloc]init];
            phonevc.type = 1;
            [self.navigationController pushViewController:phonevc animated:YES];
        };
        sortCell = typeCell;
    }else if (indexPath.section == 5){
        //手机类型
        ApplicationproductCell *phoneCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ApplicationproductCell" forIndexPath:indexPath];
        ProductModel *model = self.phoneArray[indexPath.row];
        phoneCell.productModel = model;
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
    ProductModel *product = [ProductModel new];
    if (indexPath.section == 1) {
        product = self.jicheArray[indexPath.row];
    }else if (indexPath.section == 3){
        product = self.peijianArray[indexPath.row];
    }else if (indexPath.section == 5){
        product = self.phoneArray[indexPath.row];
    }
    NSLog(@"product.id:%@",product.cid);
    HomeProductDetailVC *productdetailvc = [[HomeProductDetailVC alloc]init];
    productdetailvc.productID = product.cid;
    [self.navigationController pushViewController:productdetailvc animated:YES];
}
@end
