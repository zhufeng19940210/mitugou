//  HomeEngineVC.m
//  mitugou
//  Created by zhufeng on 2018/11/7.
//  Copyright © 2018 zhufeng. All rights reserved.
#import "HomeEngineVC.h"
#import "ApplicationproductCell.h"
#import "HomeProductDetailVC.h"
#import "ProductModel.h"
@interface HomeEngineVC ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic,strong)NSMutableArray *contentArray;
@property (nonatomic,assign)int page;
@property (nonatomic,copy)NSString *PrefixStr;   //前缀url
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
    [self actionEngineNewData];
    [self setupCollectionView];
    [self setupReresh];
}
/**
 集成刷新
 */
-(void)setupReresh
{
    [self setViewRefreshColletionView:self.collectionView withHeaderAction:@selector(actionEngineNewData) andFooterAction:@selector(actionEngineMoreData) target:self];
}
/**
 请求最新的数据
 */
-(void)actionEngineNewData
{
    [SVProgressHUD show];
    self.page = 0 ;
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"token"] = [[NSUserDefaults standardUserDefaults]valueForKey:ZF_TOKEN];
    param[@"tid"]   = [NSString stringWithFormat:@"%d",self.type];
    param[@"page"]  = [NSString stringWithFormat:@"%d",self.page];
    WEAKSELF
    [[NetWorkTool shareInstacne]postWithURLString:Userinfo_Cat_All parameters:param success:^(id  _Nonnull responseObject) {
        NSLog(@"responseObject:%@",responseObject);
        [SVProgressHUD dismiss];
        ResponeModel *res = [ResponeModel mj_objectWithKeyValues:responseObject];
        if (res.code == 1) {
            [SVProgressHUD showSuccessWithStatus:@"获取成功"];
            [weakSelf.contentArray removeAllObjects];
            weakSelf.PrefixStr = res.data[@"httpPrefix"];
            weakSelf.contentArray = [ProductModel mj_objectArrayWithKeyValuesArray:res.data[@"commodirys"]];
            [weakSelf.collectionView reloadData];
            [weakSelf.collectionView.mj_header endRefreshing];
        }else{
            [SVProgressHUD showErrorWithStatus:@"获取失败"];
            return;
        }
    } failure:^(NSError * _Nonnull error) {
        [SVProgressHUD dismiss];
        [SVProgressHUD showInfoWithStatus:FailRequestTip];
        [weakSelf.collectionView.mj_header endRefreshing];
        return;
    }];
}
/**
 请求更多数据
 */
-(void)actionEngineMoreData
{
    self.page++;
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"token"] = [[NSUserDefaults standardUserDefaults]valueForKey:ZF_TOKEN];
    param[@"tid"]   = [NSString stringWithFormat:@"%d",self.type];
    param[@"page"]  = [NSString stringWithFormat:@"%d",self.page];
    WEAKSELF
    [[NetWorkTool shareInstacne]postWithURLString:Userinfo_Cat_All parameters:param success:^(id  _Nonnull responseObject) {
        NSLog(@"responseObject:%@",responseObject);
        [SVProgressHUD dismiss];
        ResponeModel *res = [ResponeModel mj_objectWithKeyValues:responseObject];
        if (res.code == 1) {
            NSMutableArray *array = [NSMutableArray array];
            array = [ProductModel mj_objectArrayWithKeyValuesArray:res.data[@"commodirys"]];
            [weakSelf.contentArray addObjectsFromArray:array];
            [weakSelf.collectionView reloadData];
            [weakSelf.collectionView.mj_footer endRefreshing];
        }else{
        }
    } failure:^(NSError * _Nonnull error) {
        [SVProgressHUD dismiss];
        [SVProgressHUD showInfoWithStatus:FailRequestTip];
        [weakSelf.collectionView.mj_footer endRefreshing];
        return;
    }];
}
-(void)configNavgationTitle
{  NSString *urlTitle = nil;
    if (self.type == 1) {
        urlTitle = @"手机专区";
    }else if(self.type == 2){
        urlTitle = @"机车专区";
    }else if (self.type == 3){
        urlTitle = @"配件专区";
    }
    self.navigationItem.title = urlTitle;
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
   return self.contentArray.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ApplicationproductCell *engineCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ApplicationproductCell" forIndexPath:indexPath];
    ProductModel *model = self.contentArray[indexPath.row];
    engineCell.prePrefix  = self.PrefixStr;
    engineCell.isPrefix = YES;
    engineCell.productModel = model;
    return engineCell;
}
#pragma mark - item宽高
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(IPHONE_WIDTH/2-5,220);
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    ProductModel *product = self.contentArray[indexPath.row];
    HomeProductDetailVC *productdetailvc = [[HomeProductDetailVC alloc]init];
    productdetailvc.productID = product.cid;
    [self.navigationController pushViewController:productdetailvc animated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
@end
