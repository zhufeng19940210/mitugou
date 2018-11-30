//  CardAuthonVC.m
//  mitugou
//  Created by zhufeng on 2018/11/8.
//  Copyright © 2018 zhufeng. All rights reserved.
#import "CardAuthonVC.h"
@interface CardAuthonVC ()<TZImagePickerControllerDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *up_img;
@property (weak, nonatomic) IBOutlet UIImageView *down_img;
@property (weak, nonatomic) IBOutlet UIImageView *add_img;
@property (weak, nonatomic) IBOutlet UIImageView *add_img2;
@property (weak, nonatomic) IBOutlet UILabel *add_title1;
@property (weak, nonatomic) IBOutlet UILabel *add_title2;
@property (nonatomic,assign)BOOL isFirst;
@property (nonatomic,assign)BOOL isSecond;
@property (nonatomic,strong)UIImage *zf_up_imag;
@property (nonatomic,strong)UIImage *zf_down_img;
@property (nonatomic,strong)NSMutableArray *imageArray;
@end
@implementation CardAuthonVC
-(NSMutableArray *)imageArray
{
    if (!_imageArray) {
        _imageArray = [NSMutableArray array];
    }
    return _imageArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"银行卡认证";
    [self setRightButtonText:@"上传" withColor:MainThemeColor];
    [self setupUI];
    [self setupData];
}
-(void)setupUI
{
    self.isFirst = NO;
    self.isSecond = NO;
    self.zf_up_imag = nil;
    self.zf_down_img = nil;
    self.up_img.userInteractionEnabled = YES;
    self.down_img.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(actinoAction1:)];
    UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(actinoAction2:)];
    [self.up_img addGestureRecognizer:tap1];
    [self.down_img addGestureRecognizer:tap2];
}
/**
 选择银行卡正面
 @return
 */
-(void)actinoAction1:(UITapGestureRecognizer *)gesture
{
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:1 columnNumber:4 delegate:self pushPhotoPickerVc:YES];
    [imagePickerVc setAllowPreview:NO];
    [imagePickerVc setAllowPickingVideo:NO];
    [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
        self.isFirst = YES;
        self.add_img.hidden = YES;
        self.add_title1.hidden = YES;
        self.zf_up_imag = photos[0];
        self.up_img.image = photos[0];
    }];
    [self presentViewController:imagePickerVc animated:YES completion:nil];
}
/**
银行卡反面
 @param gesture 银行卡反面
 */
-(void)actinoAction2:(UITapGestureRecognizer *)gesture
{
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:1 columnNumber:4 delegate:self pushPhotoPickerVc:YES];
    [imagePickerVc setAllowPreview:NO];
    [imagePickerVc setAllowPickingVideo:NO];
    [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
        self.isSecond = YES;
        self.add_img2.hidden = YES;
        self.add_title2.hidden = YES;
        self.zf_down_img = photos[0];
        self.down_img.image = photos[0];
    }];
    [self presentViewController:imagePickerVc animated:YES completion:nil];
}
-(void)setupData
{
    WEAKSELF
    [SVProgressHUD show];
    NSString *token = [[NSUserDefaults standardUserDefaults]valueForKey:ZF_TOKEN];
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"token"] = token;
    [[NetWorkTool shareInstacne]postWithURLString:Userinfo_bankAuthen_Url_Find parameters:param success:^(id  _Nonnull responseObject) {
        NSLog(@"responseObject:%@",responseObject);
        [SVProgressHUD dismiss];
        ResponeModel *res = [ResponeModel mj_objectWithKeyValues:responseObject];
        if (res.code == 1) {
                [SVProgressHUD showSuccessWithStatus:@"获取成功"];
                NSDictionary *authInfo = res.data[@"authInfo"];
                NSString *upimage   = authInfo[@"backbank"];
                NSString *downimage = authInfo[@"justbank"];
                weakSelf.add_img.hidden = YES;
                weakSelf.add_title1.hidden = YES;
                weakSelf.add_img2.hidden = YES;
                weakSelf.add_title2.hidden = YES;
                [weakSelf.up_img sd_setImageWithURL:[NSURL URLWithString:downimage] placeholderImage:nil];
                [weakSelf.down_img sd_setImageWithURL:[NSURL URLWithString:upimage] placeholderImage:nil];
        }
       else if (res.code == 2) {
            [SVProgressHUD showSuccessWithStatus:@"暂无数据"];
            return;
        }
        else{
            [SVProgressHUD showErrorWithStatus:@"获取失败"];
            return ;
        }
    } failure:^(NSError * _Nonnull error) {
        [SVProgressHUD dismiss];
        [SVProgressHUD showErrorWithStatus:FailRequestTip];
        return;
    }];
}
/**
 上传的方法
 @param button 上传的方法
 */
- (void)onRightBtnAction:(UIButton *)button
{
    if (!self.isFirst) {
        [self showHint:@"请先选择银行卡正面" yOffset:-200];
        return;
    }
    if (!self.isSecond) {
        [self showHint:@"请先选择银行卡正面" yOffset:-200];
        return;
    }
    //开始去上传
    [self.imageArray removeAllObjects];
    [self.imageArray addObject:self.zf_up_imag];
    [self.imageArray addObject:self.zf_down_img];
    [SVProgressHUD show];
    NSString *token = [[NSUserDefaults standardUserDefaults]valueForKey:ZF_TOKEN];
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"token"] = token;
    WEAKSELF
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json", @"text/plain", @"text/html",nil];
    [manager POST:@"http://47.93.238.67:9999/htshop/borrowAuthentication/modifybankAuthen" parameters:param constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        for (int i = 0; i <self.imageArray.count; i ++) {
            NSDateFormatter *formatter=[[NSDateFormatter alloc]init];
            formatter.dateFormat=@"yyyyMMddHHmmss";
            NSString *str=[formatter stringFromDate:[NSDate date]];
            NSString *fileName=[NSString stringWithFormat:@"%@.jpg",str];
            NSLog(@"selectimageurl:%@",fileName);
            UIImage *image = self.self.imageArray[i];
            NSData *imageData = [LCUtil zipNSDataWithImage:image];
            NSLog(@"iMAGEdata:%@",imageData);
            [formData appendPartWithFileData:imageData name:@"bankimg" fileName:fileName mimeType:@"image/jpg"];
        }
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [SVProgressHUD dismiss];
        ResponeModel *res = [ResponeModel mj_objectWithKeyValues:responseObject];
        if (res.code == 1) {
            [[NSUserDefaults standardUserDefaults]setBool:YES forKey:User_Authon6];
            [[NSUserDefaults standardUserDefaults]synchronize];
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
@end
