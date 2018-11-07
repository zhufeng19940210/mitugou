//  SettingVC.m
//  mitugou
//  Created by zhufeng on 2018/11/3.
//  Copyright © 2018年 zhufeng. All rights reserved.

#import "SettingVC.h"
#import "SettingHeaderCell.h"
#import "SettingCommentCell.h"
@interface SettingVC ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic,strong)NSMutableArray *imageArray;
@property (nonatomic,strong)NSMutableArray *titleArray;
@end

@implementation SettingVC
-(NSMutableArray *)imageArray
{
    if (!_imageArray) {
        _imageArray = [NSMutableArray arrayWithObjects:@"setting1",@"setting2",@"setting3",@"setting4",@"setting5",@"setting6", nil];
    }
    return _imageArray;
}
-(NSMutableArray *)titleArray
{
    if (!_titleArray) {
        _titleArray = [NSMutableArray arrayWithObjects:@"邀请好友",@"商品订单",@"实名认证",@"优惠券",@"客服",@"设置",nil];
    }
    return _titleArray;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNavigationBar];
    [self setupData];
    [self setupCollectionView];
}
-(void)setupData
{
}
-(void)setupNavigationBar
{
    [self setRightButton:[UIImage imageNamed:@"setting_msg"]];
}
//初始化collectionview
-(void)setupCollectionView
{
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.backgroundColor = [UIColor clearColor];
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([SettingHeaderCell class]) bundle:nil] forCellWithReuseIdentifier:@"SettingHeaderCell"];
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([SettingCommentCell class]) bundle:nil] forCellWithReuseIdentifier:@"SettingCommentCell"];
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
        return self.imageArray.count;
    }
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *settingCell = nil;
    if (indexPath.section == 0) {
        //我的额度
        SettingHeaderCell *headerCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"SettingHeaderCell" forIndexPath:indexPath];
        settingCell = headerCell;
    }else if (indexPath.section == 1){
        //商品推荐
        SettingCommentCell *commentCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"SettingCommentCell" forIndexPath:indexPath];
        commentCell.icon_img.image = [UIImage imageNamed:self.imageArray[indexPath.row]];
        commentCell.title_lab.text = [NSString stringWithFormat:@"%@",self.titleArray[indexPath.row]];
        settingCell = commentCell;
    }
    return settingCell;
}
#pragma mark - item宽高
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return  CGSizeMake(IPHONE_WIDTH, 200);
    }else{
        return CGSizeMake(IPHONE_WIDTH,50);
    }
    return CGSizeZero;
}

#pragma mark - <UICollectionViewDelegateFlowLayout>
#pragma mark - X间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}
#pragma mark - Y间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
}
@end
