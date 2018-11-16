//  ZhifubaoPayAuthonVC.m
//  mitugou
//  Created by zhufeng on 2018/11/8.
//  Copyright © 2018 zhufeng. All rights reserved.
#import "ZhifubaoPayAuthonVC.h"

@interface ZhifubaoPayAuthonVC ()<TZImagePickerControllerDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *first_img;
@property (weak, nonatomic) IBOutlet UIImageView *second_img;
@property (weak, nonatomic) IBOutlet UIImageView *third_img;
@property (weak, nonatomic) IBOutlet UIImageView *four_img;
@property (weak, nonatomic) IBOutlet UIImageView *add_img1;
@property (weak, nonatomic) IBOutlet UIImageView *add_img2;
@property (weak, nonatomic) IBOutlet UIImageView *add_img3;
@property (weak, nonatomic) IBOutlet UIImageView *add_img4;
@property (nonatomic,assign)BOOL isFirst;
@property (nonatomic,assign)BOOL isSecod;
@property (nonatomic,assign)BOOL isThird;
@property (nonatomic,assign)BOOL isFour;
@property (nonatomic,strong)UIImage *zf_first_img;
@property (nonatomic,strong)UIImage *zf_second_img;
@property (nonatomic,strong)UIImage *zf_third_img;
@property (nonatomic,strong)UIImage *zf_four_img;
@property (nonatomic,strong)NSMutableArray *imageArray;
@end

@implementation ZhifubaoPayAuthonVC
-(NSMutableArray *)imageArray
{
    if (!_imageArray) {
        _imageArray = [NSMutableArray array];
    }
    return _imageArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"支付宝认证";
    [self setRightButtonText:@"上传" withColor:MainThemeColor];
    [self seutpUI];
    [self setupData];
}

-(void)seutpUI
{
    self.zf_first_img  = nil;
    self.zf_second_img = nil;
    self.zf_third_img  = nil;
    self.zf_four_img   = nil;
    self.isFirst = NO;
    self.isSecod = NO;
    self.isThird = NO;
    self.isFour  = NO;
    self.first_img.userInteractionEnabled = YES;
    self.second_img.userInteractionEnabled = YES;
    self.third_img.userInteractionEnabled = YES;
    self.four_img.userInteractionEnabled = YES;
    //添加添加手势
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(actionSelect1:)];
    UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(actionSelect2:)];
    UITapGestureRecognizer *tap3 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(actionSelect3:)];
    UITapGestureRecognizer *tap4 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(actionSelect4:)];
    [self.first_img addGestureRecognizer:tap1];
    [self.second_img addGestureRecognizer:tap2];
    [self.third_img addGestureRecognizer:tap3];
    [self.four_img addGestureRecognizer:tap4];
}

/**
 选择第一张图片
 @param gesture 选择第一张图片
 */
-(void)actionSelect1:(UITapGestureRecognizer *)gesture
{
    
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:1 columnNumber:4 delegate:self pushPhotoPickerVc:YES];
    [imagePickerVc setAllowPreview:NO];
    [imagePickerVc setAllowPickingVideo:NO];
    [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
        self.isFirst = YES;
        self.add_img1.hidden = YES;
        self.first_img.image = photos[0];
        self.zf_first_img = photos[0];
    }];
    [self presentViewController:imagePickerVc animated:YES completion:nil];
}

/**
 选择第二张图片
 @param gesture 选择第二张图片
 */
-(void)actionSelect2:(UITapGestureRecognizer *)gesture
{
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:1 columnNumber:4 delegate:self pushPhotoPickerVc:YES];
    [imagePickerVc setAllowPreview:NO];
    [imagePickerVc setAllowPickingVideo:NO];
    [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
        self.isSecod = YES;
        self.add_img2.hidden = YES;
        self.second_img.image = photos[0];
        self.zf_second_img = photos[0];
    }];
    [self presentViewController:imagePickerVc animated:YES completion:nil];
}
/**
 选择第三张图片
 @param gesture 选择第三张图片
 */
-(void)actionSelect3:(UITapGestureRecognizer *)gesture
{
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:1 columnNumber:4 delegate:self pushPhotoPickerVc:YES];
    [imagePickerVc setAllowPreview:NO];
    [imagePickerVc setAllowPickingVideo:NO];
    [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
        self.isThird = YES;
        self.add_img2.hidden = YES;
        self.third_img.image = photos[0];
        self.zf_third_img = photos[0];
    }];
    [self presentViewController:imagePickerVc animated:YES completion:nil];
}
/**
 选择第四张图片
 @param gesture 现在第三张图片
 */
-(void)actionSelect4:(UITapGestureRecognizer *)gesture
{
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:1 columnNumber:4 delegate:self pushPhotoPickerVc:YES];
    [imagePickerVc setAllowPreview:NO];
    [imagePickerVc setAllowPickingVideo:NO];
    [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
        self.isFour = YES;
        self.add_img3.hidden = YES;
        self.four_img.image = photos[0];
        self.zf_four_img = photos[0];
    }];
    [self presentViewController:imagePickerVc animated:YES completion:nil];
}
//获取返回的数据了
-(void)setupData
{
    WEAKSELF
    [SVProgressHUD show];
    NSString *token = [[NSUserDefaults standardUserDefaults]valueForKey:ZF_TOKEN];
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"token"] = token;
    [[NetWorkTool shareInstacne]postWithURLString:Userinfo_Ali_Url_Find parameters:param success:^(id  _Nonnull responseObject) {
        [SVProgressHUD dismiss];
        ResponeModel *res = [ResponeModel mj_objectWithKeyValues:responseObject];
        if (res.code == 1) {
            [SVProgressHUD showSuccessWithStatus:@"获取成功"];
            NSDictionary *authInfo = res.data[@"authInfo"];
            NSString *first   = authInfo[@"payimg1"];
            NSString *second  = authInfo[@"payimg2"];
            NSString *third   = authInfo[@"payimg3"];
            NSString *four    = authInfo[@"payimg4"];
            weakSelf.add_img1.hidden = YES;
            weakSelf.add_img2.hidden = YES;
            weakSelf.add_img3.hidden = YES;
            weakSelf.add_img4.hidden = YES;
            [weakSelf.first_img sd_setImageWithURL:[NSURL URLWithString:first]];
            [weakSelf.second_img sd_setImageWithURL:[NSURL URLWithString:second]];
            [weakSelf.third_img sd_setImageWithURL:[NSURL URLWithString:third]];
            [weakSelf.four_img sd_setImageWithURL:[NSURL URLWithString:four]];
            }
        if (res.code == 2) {
            [SVProgressHUD showSuccessWithStatus:@"暂无数据"];
            return;
        }
        else{
            [SVProgressHUD showErrorWithStatus:@"获取失败"];
            return;
        }
    } failure:^(NSError * _Nonnull error) {
        [SVProgressHUD dismiss];
        [SVProgressHUD showErrorWithStatus:FailRequestTip];
    }];
    
}
/**
 RightButton
 @param button RightButton
 */
- (void)onRightBtnAction:(UIButton *)button
{
    if (!self.isFirst) {
        [self showHint:@"请先选择第一张图片" yOffset:-200];
        return;
    }
    if (!self.isSecod) {
        [self showHint:@"请选择第二张图片" yOffset:-200];
        return;
    }
    if (!self.isThird) {
        [self showHint:@"请选择第三张图片" yOffset:-200];
        return;
    }
    if (!self.isFour) {
        [self showHint:@"请选择第四张图片" yOffset:-200];
        return;
    }
    [self.imageArray removeAllObjects];
    [self.imageArray addObject:self.zf_first_img];
    [self.imageArray addObject:self.zf_second_img];
    [self.imageArray addObject:self.zf_third_img];
    [self.imageArray addObject:self.zf_four_img];
    //开始去上传图片
    [SVProgressHUD show];
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    NSString *token  = [[NSUserDefaults standardUserDefaults]valueForKey:ZF_TOKEN];
    param[@"token"] = token;
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json", @"text/plain", @"text/html",nil];
    [manager POST:@"http://47.93.238.67:9999/htshop/borrowAuthentication/modifyalipayAuth" parameters:param constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        for (int i = 0; i <self.imageArray.count; i ++) {
            NSDateFormatter *formatter=[[NSDateFormatter alloc]init];
            formatter.dateFormat=@"yyyyMMddHHmmss";
            NSString *str=[formatter stringFromDate:[NSDate date]];
            NSString *fileName=[NSString stringWithFormat:@"%@.jpg",str];
            NSLog(@"selectimageurl:%@",fileName);
            UIImage *image = self.self.imageArray[i];
            NSData *imageData = [LCUtil zipNSDataWithImage:image];
            NSLog(@"iMAGEdata:%@",imageData);
            [formData appendPartWithFileData:imageData name:@"aliPay" fileName:fileName mimeType:@"image/jpg"];
        }
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [SVProgressHUD dismiss];
        ResponeModel *res = [ResponeModel mj_objectWithKeyValues:responseObject];
        if (res.code ==1) {
            [SVProgressHUD showSuccessWithStatus:@"上传成功"];
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            [SVProgressHUD showErrorWithStatus:@"上传失败"];
            return;
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [SVProgressHUD dismiss];
        [SVProgressHUD showErrorWithStatus:FailRequestTip];
        return;
    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
@end
