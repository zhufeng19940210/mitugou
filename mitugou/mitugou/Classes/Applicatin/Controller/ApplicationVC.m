//  ApplicationVC.m
//  mitugou
//  Created by zhufeng on 2018/11/3.
//  Copyright © 2018年 zhufeng. All rights reserved.
#import "ApplicationVC.h"
#import "ApplicationHeaderCell.h"
#import "ApplicationproductCell.h"
#import "HomeProductDetailVC.h"
#import "SettingAuthonVC.h"
#import "ProductModel.h"
@interface ApplicationVC ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionview;
@property (nonatomic,strong)NSMutableArray *applicationArray;
@property (nonatomic,strong)NSDictionary *responseDic;
@property (nonatomic,assign)int maxCount;
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
    [self actionApplicatinNewData];
    //初始化collectionview
    [self setupCollectionView];
    //集成下拉刷新
    [self setViewRefreshColletionView:self.collectionview withHeaderAction:@selector(actionApplicatinNewData) andFooterAction:nil target:self];
}
#pragma mark --请求数据
-(void)actionApplicatinNewData
{
    [SVProgressHUD show];
    NSString *token = [[NSUserDefaults standardUserDefaults]valueForKey:ZF_TOKEN];
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"token"] = token;
    WEAKSELF
    [[NetWorkTool shareInstacne]postWithURLString:Appication_Url parameters:param success:^(id  _Nonnull responseObject) {
        NSLog(@"responseObject:%@",responseObject);
        [SVProgressHUD dismiss];
        ResponeModel *res = [ResponeModel mj_objectWithKeyValues:responseObject];
        if (res.code == 1) {
            [SVProgressHUD showSuccessWithStatus:@"获取成功"];
            [weakSelf.applicationArray removeAllObjects];
            weakSelf.applicationArray = [ProductModel mj_objectArrayWithKeyValuesArray:res.data[@"commodirys"]];
            //额度
            NSLog(@"res.data:%@",res.data[@"maxAmount"]);
            weakSelf.maxCount = [res.data[@"maxAmount"] intValue];
        }else{
            [SVProgressHUD showErrorWithStatus:@"获取失败"];
            return ;
        }
        [weakSelf.collectionview reloadData];
        [weakSelf.collectionview.mj_header endRefreshing];
    } failure:^(NSError * _Nonnull error) {
        [SVProgressHUD dismiss];
        [SVProgressHUD showErrorWithStatus:FailRequestTip];
        [weakSelf.collectionview.mj_header endRefreshing];
        return;
    }];
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
        if (self.applicationArray.count>3) {
            return 4;
        }else{
            return self.applicationArray.count;
        }
    }
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *applicationCell = nil;
    if (indexPath.section == 0) {
        //我的额度
        ApplicationHeaderCell *headerCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ApplicationHeaderCell" forIndexPath:indexPath];
        headerCell.count_lab.text = [NSString stringWithFormat:@"%d",self.maxCount];
        headerCell.actionBlock = ^(UIButton *btn) {
            ///todo这里要做的跳转请求
            [self requestActionBtn];
        };
        applicationCell = headerCell;
    }else if (indexPath.section == 1){
        //商品推荐
        ApplicationproductCell *productCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ApplicationproductCell" forIndexPath:indexPath];
        ProductModel *model = self.applicationArray[indexPath.row];
        productCell.isPrefix = NO;
        productCell.productModel = model;
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
{
//    NSDate * date = [NSDate date];
//    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
//    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
//    //设置时间间隔（秒）（这个我是计算出来的，不知道有没有简便的方法 )
//    NSTimeInterval time = 60 * 60;//一年的秒数
//    //得到一年之前的当前时间（-：表示向前的时间间隔（即去年），如果没有，则表示向后的时间间隔（即明年））
//    NSDate * lastYear = [date dateByAddingTimeInterval:time];
//    //转化为字符串
//    NSString * startDate = [dateFormatter stringFromDate:lastYear];
//    NSLog(@"startDate:%@",startDate);
    //1.这里请求接口,判断是否认证的数据
    //2.如果认证成功了就显示成功
    //3.如果申请过了等待结果
    //4.如果失败再次申请去申请，这里只是测试罢了
    //SettingAuthonVC *authonvc = [[SettingAuthonVC alloc]init];
    //[self.navigationController pushViewController:authonvc animated:YES];
    [SVProgressHUD show];
    NSString *token = [[NSUserDefaults standardUserDefaults]valueForKey:ZF_TOKEN];
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"token"] = token;
    [[NetWorkTool shareInstacne]postWithURLString:Pay_alipayPremount parameters:param success:^(id  _Nonnull responseObject) {
        NSLog(@"responseObject:%@",responseObject);
        ResponeModel *res = [ResponeModel mj_objectWithKeyValues:responseObject];
        if (res.code == 1) {
            [[AlipaySDK defaultService] payOrder:res.data[@"payinfo"] fromScheme:AppScheme callback:^(NSDictionary *resultDic) {
                NSLog(@"reslut = %@",resultDic);
            }];
        }else{
            [SVProgressHUD showErrorWithStatus:res.message];
            return ;
        }
    } failure:^(NSError * _Nonnull error) {
        [SVProgressHUD dismiss];
        [SVProgressHUD showErrorWithStatus:FailRequestTip];
        return;
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
@end
