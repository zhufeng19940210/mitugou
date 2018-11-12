//  SettingVC.m
//  mitugou
//  Created by zhufeng on 2018/11/3.
//  Copyright © 2018年 zhufeng. All rights reserved.
#import "SettingVC.h"
#import "SettingHeaderCell.h"
#import "SettingCommentCell.h"
#import "SettingFriendVC.h"
#import "OrderListVC.h"
#import "SettingAuthonVC.h"
#import "SettingCouponVC.h"
#import "SettingUserinfoVC.h"
#import "SettingLoanVC.h"
#import "SettingRepaymentVC.h"
#import "HomeMessageVC.h"
#import "ShareView.h"
@interface SettingVC ()<UICollectionViewDelegate,UICollectionViewDataSource,TZImagePickerControllerDelegate,ShareViewDelegate>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic,strong)NSMutableArray *imageArray;
@property (nonatomic,strong)NSMutableArray *titleArray;
@property (nonatomic,strong)ShareView *shareView;
@property (nonatomic,strong)NSMutableArray *photoeArray;
@end

@implementation SettingVC
-(NSMutableArray *)photoeArray
{
    if (!_photoeArray) {
        _photoeArray = [NSMutableArray array];
    }
    return _photoeArray;
}

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
    [self setupShareView];
    [self setupData];
    [self setupCollectionView];
}
-(void)setupShareView{
    ShareView *shareview = [[ShareView alloc]init];
    self.shareView  = shareview;
    self.shareView.delegate = self;
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
        SettingHeaderCell *headerCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"SettingHeaderCell" forIndexPath:indexPath];
        headerCell.actionBlock = ^(SettingHeaderType type) {
            if (type ==  SettingHeaderTypeIcon) {
                //头像
                [self changeIconMethod];
                
            }else if (type == SettingHeaderTypeMsg){
                //消息
                HomeMessageVC *messagevc = [[HomeMessageVC alloc]init];
                [self.navigationController pushViewController:messagevc animated:YES];
            }else if(type == SettingHeaderTypeJie){
                //借款
                SettingLoanVC *loanvc = [[SettingLoanVC alloc]init];
                [self.navigationController pushViewController:loanvc animated:YES];
            }else if (type == SettingHeaderTypeHuan){
                //还款
                SettingRepaymentVC *repaymentvc = [[SettingRepaymentVC alloc]init];
                [self.navigationController pushViewController:repaymentvc animated:YES];
            }
        };
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
/**
 修改头像
 */
-(void)changeIconMethod
{
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:3 columnNumber:4 delegate:self pushPhotoPickerVc:YES];
    [imagePickerVc setAllowPreview:NO];
    [imagePickerVc setAllowPickingVideo:NO];
    [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
       // [self uploadpath:photos[0]];
        [self.photoeArray removeAllObjects];
        [self.photoeArray addObjectsFromArray:photos];
        [self uploadpathes];
    }];
    [self presentViewController:imagePickerVc animated:YES completion:nil];
}
//删除图片
-(void)uploadpathes{
    NSLog(@"sefl.phont.count:%lu",(unsigned long)self.photoeArray.count);
    __weak typeof(self) weakSelf = self;
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"token"] = @"88888888";
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json", @"text/plain", @"text/html",nil];
    [manager POST:@"http://47.93.238.67:9999/htshop/borrowAuthentication/modifyalipayAuth" parameters:param constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        for (int i = 0; i <self.photoeArray.count; i ++) {
            NSDateFormatter *formatter=[[NSDateFormatter alloc]init];
            formatter.dateFormat=@"yyyyMMddHHmmss";
            NSString *str=[formatter stringFromDate:[NSDate date]];
            NSString *fileName=[NSString stringWithFormat:@"%@.jpg",str];
            NSLog(@"selectimageurl:%@",fileName);
            UIImage *image = self.photoeArray[i];
            NSData *imageData = UIImageJPEGRepresentation(image, 0.5);
            NSLog(@"iMAGEdata:%@",imageData);
            [formData appendPartWithFileData:imageData name:@"dd" fileName:fileName mimeType:@"image/jpg"];
        }
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"success:%@",responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [SVProgressHUD showInfoWithStatus:@"服务器失败"];
        return;
    }];
}
-(void)uploadpath:(UIImage *)selectImage{
    __weak typeof(self) weakSelf = self;
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"token"] = @"88888888";
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json", @"text/plain", @"text/html",nil];
    [manager POST:@"http://47.93.238.67:9999/htshop/borrowAuthentication/modifyalipayAuth" parameters:param constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        for (int i = 0; i <self.photoeArray.count; i ++) {
            NSDateFormatter *formatter=[[NSDateFormatter alloc]init];
            formatter.dateFormat=@"yyyyMMddHHmmss";
            NSString *str=[formatter stringFromDate:[NSDate date]];
            NSString *fileName=[NSString stringWithFormat:@"%@.jpg",str];
            NSLog(@"selectimageurl:%@",fileName);
            NSData *imageData = UIImageJPEGRepresentation(selectImage, 0.5);
            NSLog(@"iMAGEdata:%@",imageData);
            [formData appendPartWithFileData:imageData name:@"dd" fileName:fileName mimeType:@"image/jpg"];
        }
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"success:%@",responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [SVProgressHUD showInfoWithStatus:@"服务器失败"];
        return;
    }];
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            //分享的东西
            [self.shareView shareViewShow];
        }
        if (indexPath.row == 1) {
            OrderListVC *ordervc = [[OrderListVC alloc]init];
            [self.navigationController pushViewController:ordervc animated:YES];
        }
        if (indexPath.row == 2) {
            SettingAuthonVC *authonvc = [[SettingAuthonVC alloc]init];
            [self.navigationController pushViewController:authonvc animated:YES];
        }
        if (indexPath.row == 3) {
            SettingCouponVC *couponvc = [[SettingCouponVC alloc]init];
            [self.navigationController pushViewController:couponvc animated:YES];
        }
        if (indexPath.row == 4) {
            //客服打电话的东西
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"客服电话?" message:@"是否拨打客服电话?" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
                //拨打电话的功能
                NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"tel:%@",@"1375110746"];
                UIWebView * callWebview = [[UIWebView alloc] init];
                [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
                [self.view addSubview:callWebview];
            }];
            [alertController addAction:cancelAction];
            [alertController addAction:okAction];
            [self presentViewController:alertController animated:YES completion:nil];
            
        }
        if (indexPath.row == 5) {
            SettingUserinfoVC *userinfovc = [[SettingUserinfoVC alloc]init];
            [self.navigationController pushViewController:userinfovc animated:YES];
        }
    }
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
#pragma mark SharViewDelegate
-(void)shareWithTag:(int)tag
{
    if (tag == 0) {
        NSLog(@"微信分享");
    }else if (tag == 1){
        NSLog(@"朋友圈分享");
    }else if (tag == 2){
        NSLog(@"qq分享");
    }else if (tag == 4 ){
        NSLog(@"微博分享");
    }
}
@end
