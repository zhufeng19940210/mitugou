//  HomeSearchVC.m
//  mitugou
//  Created by zhufeng on 2018/11/7.
//  Copyright © 2018 zhufeng. All rights reserved.
#import "HomeSearchVC.h"
#import "ApplicationproductCell.h"
#import "ProductModel.h"
#import "HomeProductDetailVC.h"
@interface HomeSearchVC ()<UITextFieldDelegate,UICollectionViewDelegate,UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic,strong)UITextField *search_tf;
@property (nonatomic,assign)BOOL isSearch; //是否搜索
@property (nonatomic,strong)NSMutableArray *searchArray;
@property (nonatomic,assign)int page;
@end
@implementation HomeSearchVC
-(NSMutableArray *)searchArray
{
    if (!_searchArray) {
        _searchArray = [NSMutableArray array];
    }
    return _searchArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = RGB(240, 240, 240);
    self.page = 0;
    [self setupConfigNavitionBar];
    [self setupCollectionView];
    [self seutpRefresh];
}
-(void)seutpRefresh
{
    [self setViewRefreshColletionView:self.collectionView withHeaderAction:@selector(actionSearchNewData) andFooterAction:@selector(actionSearchMoreData) target:self];
}

-(void)setupCollectionView
{
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.backgroundColor = [UIColor clearColor];
    //注册cell
    [self.collectionView registerNib:[UINib nibWithNibName:@"ApplicationproductCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"ApplicationproductCell"];
}
#pragma mark -- collectionViewDelegate
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    NSLog(@"count:%lu",(unsigned long)self.searchArray.count);
    return self.searchArray.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ApplicationproductCell *searchCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ApplicationproductCell" forIndexPath:indexPath];
    ProductModel *model =  self.searchArray[indexPath.row];
    NSLog(@"model.phont:%@",model.photo);
    searchCell.isPrefix = NO;
    searchCell.productModel = model;
    return searchCell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    ProductModel *model = self.searchArray[indexPath.row];
    HomeProductDetailVC *detailvc = [[HomeProductDetailVC alloc]init];
    detailvc.productID = model.cid;
    [self.navigationController pushViewController:detailvc animated:YES];
}

#pragma mark - item宽高
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(IPHONE_WIDTH/2-5,220);
}

-(void)setupConfigNavitionBar
{
    [self setRightButtonText:@"搜索" withColor:[UIColor whiteColor]];
    UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, IPHONE_WIDTH*0.8, 34)];
    textField.layer.masksToBounds = YES;
    textField.layer.cornerRadius = 16.0f;
    textField.backgroundColor = RGB(240, 240, 240);
    textField.font = [UIFont systemFontOfSize:15]; // 字体颜色
    NSMutableDictionary *attrs = [NSMutableDictionary dictionary]; // 创建属性字典
    attrs[NSFontAttributeName] = [UIFont systemFontOfSize:14]; // 设置font
    attrs[NSForegroundColorAttributeName] = RGB(153, 153, 153); // 设置颜色
    NSAttributedString *attStr = [[NSAttributedString alloc] initWithString:@"搜索您想要" attributes:attrs];
    textField.attributedPlaceholder = attStr;
    textField.textColor = [UIColor blackColor];
    textField.tintColor = RGB(153, 153, 153);
    textField.leftView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"search"]];
    textField.leftViewMode = UITextFieldViewModeAlways;
    textField.rightView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_delete"]];
    textField.rightView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(actionClear:)];
    [textField.rightView addGestureRecognizer:tap];
    textField.rightViewMode = UITextFieldViewModeAlways;
    textField.rightView.hidden = YES;
    self.navigationItem.titleView = textField;
    textField.delegate = self;
    textField.returnKeyType = UIReturnKeySearch;
    textField.enablesReturnKeyAutomatically = YES; //这里设置为无文字就灰色不可点
    ///成为第一个响应者
    [textField becomeFirstResponder];
    //监听的一个事件
    [textField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    self.search_tf = textField;
    self.navigationItem.titleView = textField;
}
/**
 清除的功能
 @param gesture 清除功能
 */
-(void)actionClear:(UITapGestureRecognizer *)gesture
{
    [self.search_tf resignFirstResponder];
    self.isSearch = NO;
    self.search_tf.rightView.hidden = YES;
    self.search_tf.text = @"";
    [self.searchArray removeAllObjects];
    [self.collectionView reloadData];
}
/**
 值的变化功能
 @param tf 值变化的功能
 */
#pragma mark - textFieldDidChange
-(void)textFieldDidChange:(UITextField *)textField
{
    if (textField == self.search_tf) {
        if (textField.text.length == 0 ) {
            self.isSearch = NO;
            self.search_tf.rightView.hidden = YES;
            [self.searchArray removeAllObjects];
        }else{
            self.search_tf.rightView.hidden = NO;
        }
    }
}
#pragma mark -- uitextfielddelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self actionSearchNewData];
    return YES;
}
/**
 点击搜索的功能
 @param button 搜索功能
 */
- (void)onRightBtnAction:(UIButton *)button
{
    [self actionSearchNewData];
}
//搜索的功能
-(void)actionSearchNewData
{
    NSString *searchStr = self.search_tf.text;
    if (searchStr.length == 0 || [searchStr isEqualToString:@""]) {
        [self showHint:@"搜索的内容不能为空" yOffset:-200];
        return;
    }
    ///开始去搜索公司
    self.page = 0;
    [SVProgressHUD show];
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"page"] = [NSString stringWithFormat:@"%d",self.page];
    param[@"keyword"] = searchStr;
    WEAKSELF
    [[NetWorkTool shareInstacne]postWithURLString:Home_Search parameters:param success:^(id  _Nonnull responseObject) {
        NSLog(@"responseObject:%@",responseObject);
        [SVProgressHUD dismiss];
        ResponeModel *res = [ResponeModel mj_objectWithKeyValues:responseObject];
        if (res.code == 1) {
            //请求成功
            [weakSelf.searchArray removeAllObjects];
            weakSelf.searchArray = [ProductModel mj_objectArrayWithKeyValuesArray:res.data[@"commodirys"]];
        }
        [weakSelf.collectionView reloadData];
        [weakSelf.collectionView.mj_header endRefreshing];
    } failure:^(NSError * _Nonnull error) {
        [SVProgressHUD dismiss];
        [SVProgressHUD showErrorWithStatus:FailRequestTip];
        [weakSelf.collectionView.mj_header endRefreshing];
        return;
    }];
}
/**
加载更多数据
 */
-(void)actionSearchMoreData
{
    NSString *searchStr = self.search_tf.text;
    self.page ++;
    [SVProgressHUD show];
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"page"] = [NSString stringWithFormat:@"%d",self.page];
    param[@"keyword"] = searchStr;
    WEAKSELF
    [[NetWorkTool shareInstacne]postWithURLString:Home_Search parameters:param success:^(id  _Nonnull responseObject) {
        NSLog(@"responseObject:%@",responseObject);
        [SVProgressHUD dismiss];
        ResponeModel *res = [ResponeModel mj_objectWithKeyValues:responseObject];
        if (res.code == 1) {
            //请求成功
            NSMutableArray *array = [NSMutableArray array];
            array = [ProductModel mj_objectArrayWithKeyValuesArray:res.data[@"commodirys"]];
            [weakSelf.searchArray addObjectsFromArray:array];
        }
        [weakSelf.collectionView reloadData];
        [weakSelf.collectionView.mj_footer endRefreshing];
    } failure:^(NSError * _Nonnull error) {
        [SVProgressHUD dismiss];
        [SVProgressHUD showErrorWithStatus:FailRequestTip];
        [weakSelf.collectionView.mj_footer endRefreshing];
        return;
    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
@end
