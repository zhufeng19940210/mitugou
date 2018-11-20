//  PersonCardVC.m
//  mitugou
//  Created by zhufeng on 2018/11/10.
//  Copyright © 2018 zhufeng. All rights reserved.
#import "PersonCardVC.h"
@interface PersonCardVC ()<TZImagePickerControllerDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *up_img;
@property (weak, nonatomic) IBOutlet UIImageView *down_img;
@property (weak, nonatomic) IBOutlet UIImageView *handle_img;
@property (weak, nonatomic) IBOutlet UIImageView *add_img1;
@property (weak, nonatomic) IBOutlet UILabel *add_title1;
@property (weak, nonatomic) IBOutlet UIImageView *add_img2;
@property (weak, nonatomic) IBOutlet UILabel *add_title2;
@property (weak, nonatomic) IBOutlet UIImageView *add_img3;
@property (weak, nonatomic) IBOutlet UILabel *add_title3;
@property (nonatomic,strong)UIImage *upimg;       //upimg
@property (nonatomic,strong)UIImage *downimg;     //downimg
@property (nonatomic,strong)UIImage *handleimg;   //handleimg
@property (nonatomic,assign)BOOL isFirst;         //isFirst
@property (nonatomic,assign)BOOL isSecond;        //isSecond
@property (nonatomic,assign)BOOL isThird;         //isThird
@property (nonatomic,strong)NSMutableArray *imageArray;
@end
@implementation PersonCardVC
-(NSMutableArray *)imageArray
{
    if (!_imageArray) {
        _imageArray = [NSMutableArray arrayWithCapacity:3];
    }
    return _imageArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"上传身份证照片";
    //给图片添加手势和和事件
    [self initlitaionUI];
    [self setupUI];
    [self setupData];
}
-(void)initlitaionUI
{
    self.upimg = nil;
    self.downimg = nil;
    self.handleimg = nil;
    self.isFirst = NO;
    self.isSecond = NO;
    self.isThird = NO;
}

-(void)setupData
{
    WEAKSELF
    [SVProgressHUD show];
    NSString *token = [[NSUserDefaults standardUserDefaults]valueForKey:ZF_TOKEN];
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"token"] = token;
    [[NetWorkTool shareInstacne]postWithURLString:Userinfo_Card_Url_Find parameters:param success:^(id  _Nonnull responseObject) {
        NSLog(@"responseObject:%@",responseObject);
        [SVProgressHUD dismiss];
        ResponeModel *res = [ResponeModel mj_objectWithKeyValues:responseObject];
        NSLog(@"res.code:%ld",(long)res.code);
        if (res.code == 1) {
            [SVProgressHUD showSuccessWithStatus:@"获取成功"];
            self.add_img1.hidden = YES;
            self.add_title1.hidden = YES;
            self.add_img2.hidden = YES;
            self.add_title2.hidden = YES;
            self.add_img3.hidden = YES;
            self.add_title3.hidden = YES;
            NSString *justimage = res.data[@"justImage"];
            NSString *backImage = res.data[@"backImage"];
            NSString *handImage = res.data[@"handImage"];
            [weakSelf.up_img sd_setImageWithURL:[NSURL URLWithString:justimage] placeholderImage:[UIImage imageNamed:@""]];
            [weakSelf.down_img sd_setImageWithURL:[NSURL URLWithString:backImage] placeholderImage:[UIImage imageNamed:@""]];
            [weakSelf.handle_img sd_setImageWithURL:[NSURL URLWithString:handImage] placeholderImage:[UIImage imageNamed:@""]];
        }else if (res.code == 2) {
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
        return;
    }];
}
-(void)setupUI
{
    self.up_img.userInteractionEnabled = YES;
    self.down_img.userInteractionEnabled = YES;
    self.handle_img.userInteractionEnabled = YES;
    //添加事件
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(actionSelectImageAction1:)];
    UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(actionSelectImageAction2:)];
    UITapGestureRecognizer *tap3 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(actionSelectImageAction3:)];
    [self.up_img addGestureRecognizer:tap1];
    [self.down_img addGestureRecognizer:tap2];
    [self.handle_img addGestureRecognizer:tap3];
}
/**
 点击第一张图片的手势
 @param gesture 点击第一张图片的手势
 */
-(void)actionSelectImageAction1:(UITapGestureRecognizer *)gesture
{
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:1 columnNumber:4 delegate:self pushPhotoPickerVc:YES];
    [imagePickerVc setAllowPreview:NO];
    [imagePickerVc setAllowPickingVideo:NO];
    [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
        self.add_img1.hidden = YES;
        self.add_title1.hidden = YES;
        self.isFirst = YES;
        self.upimg = photos[0];
        self.up_img.image = photos[0];
    }];
    [self presentViewController:imagePickerVc animated:YES completion:nil];
}

/**
 点击第二张图片的手势
 @param gesture 点击第二张图片的手势
 */
-(void)actionSelectImageAction2:(UITapGestureRecognizer *)gesture
{
    if (self.isFirst) {
        TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:1 columnNumber:4 delegate:self pushPhotoPickerVc:YES];
        [imagePickerVc setAllowPreview:NO];
        [imagePickerVc setAllowPickingVideo:NO];
        [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
            self.add_img2.hidden = YES;
            self.add_title2.hidden = YES;
            self.isSecond = YES;
            self.downimg = photos[0];
            self.down_img.image = photos[0];
        }];
        [self presentViewController:imagePickerVc animated:YES completion:nil];
    }else{
        [ZFCustomView showWithText:@"请先选择正面照片" WithDurations:1];
        return;
    }
}
/**
 点击第三张图片的手势
 @param gesture 点击第三张图片的手势
 */
-(void)actionSelectImageAction3:(UITapGestureRecognizer *)gesture
{
    if (self.isFirst && self.isSecond) {
        TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:1 columnNumber:4 delegate:self pushPhotoPickerVc:YES];
        [imagePickerVc setAllowPreview:NO];
        [imagePickerVc setAllowPickingVideo:NO];
        [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
            self.add_img3.hidden = YES;
            self.add_title3.hidden = YES;
            self.isThird = YES;
            self.handleimg = photos[0];
            self.handle_img.image = photos[0];
        }];
        [self presentViewController:imagePickerVc animated:YES completion:nil];
    }else{
        [ZFCustomView showWithText:@"请先选择正面和反面照" WithDurations:1];
        return;
    }
}
/**
 保存用户
 @param sender 保存用户
 */
- (IBAction)actionSaveBtn:(UIButton *)sender
{
    if (!self.isFirst) {
        [self showHint:@"请选择正面照片" yOffset:-200];
        return;
    }
    if (!self.isSecond) {
        [self showHint:@"请选择反面照片" yOffset:-200];
        return;
    }
    if (!self.isThird) {
        [self showHint:@"请选择手持照片" yOffset:-200];
        return;
    }
    [self.imageArray removeAllObjects];
    [self.imageArray addObject:self.upimg];
    [self.imageArray addObject:self.downimg];
    [self.imageArray addObject:self.handleimg];
    [SVProgressHUD show];
    NSString *token = [[NSUserDefaults standardUserDefaults]valueForKey:ZF_TOKEN];
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"token"] = token;
    WEAKSELF
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json", @"text/plain", @"text/html",nil];
    [manager POST:@"http://47.93.238.67:9999/htshop/userInfoForm/saveIdcard" parameters:param constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        for (int i = 0; i <self.imageArray.count; i ++) {
            NSDateFormatter *formatter=[[NSDateFormatter alloc]init];
            formatter.dateFormat=@"yyyyMMddHHmmss";
            NSString *str=[formatter stringFromDate:[NSDate date]];
            NSString *fileName=[NSString stringWithFormat:@"%@.jpg",str];
            NSLog(@"selectimageurl:%@",fileName);
            UIImage *image = self.self.imageArray[i];
            NSData *imageData = [LCUtil zipNSDataWithImage:image];
            NSLog(@"iMAGEdata:%@",imageData);
            [formData appendPartWithFileData:imageData name:@"idcardimg" fileName:fileName mimeType:@"image/jpg"];
        }
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [SVProgressHUD dismiss];
        ResponeModel *res = [ResponeModel mj_objectWithKeyValues:responseObject];
        if (res.code == 1) {
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
