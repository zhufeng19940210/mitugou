//  SettingLiveBodyVC.m
//  mitugou
//  Created by zhufeng on 2018/12/3.
//  Copyright © 2018 zhufeng. All rights reserved.
#import "SettingLiveBodyVC.h"
#import "SettingHuotiVC.h"
@interface SettingLiveBodyVC ()<SettingHuotiVCDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *huoti_img;
@property (nonatomic,assign)BOOL isHuoti;
@property (nonatomic,strong)UIImage *selectImg;
@end
@implementation SettingLiveBodyVC
- (void)viewDidLoad {
    [super viewDidLoad];
    self.isHuoti = NO;
    self.navigationItem.title = @"活体检测";
    self.huoti_img.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapgesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(actionPushBtn:)];
    [self.huoti_img addGestureRecognizer:tapgesture];
    [self setupData];
}
/*
 请求数据
 */
-(void)setupData
{
    [SVProgressHUD show];
    NSString *token = [[NSUserDefaults standardUserDefaults]valueForKey:ZF_TOKEN];
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"token"] = token;
    WEAKSELF
    [[NetWorkTool shareInstacne]postWithURLString:User_Huoti_Chakan parameters:param success:^(id  _Nonnull responseObject) {
        [SVProgressHUD dismiss];
        NSLog(@"responseObject:%@",responseObject);
        ResponeModel *res = [ResponeModel mj_objectWithKeyValues:responseObject];
        if (res.code == 1) {
            [SVProgressHUD showSuccessWithStatus:@"获取成功"];
            [weakSelf.huoti_img sd_setImageWithURL:[NSURL URLWithString:res.data[@"discern"]] placeholderImage:[UIImage imageNamed:@"btn_id_people.png"]];
        }else if (res.code == 2){
            [SVProgressHUD showSuccessWithStatus:@"暂无数据"];
            return;
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
/**
 图片的跳转
 @return 图片的跳转
 */
-(void)actionPushBtn:(UITapGestureRecognizer *)gesture
{
    SettingHuotiVC *huotivc = [[SettingHuotiVC alloc]init];
    huotivc.delegate =  self;
    [self.navigationController pushViewController:huotivc animated:YES];
}
/**
 提交发布的东西
 @param sender 提交发布的东西
 */
- (IBAction)actionCommitBtn:(UIButton *)sender
{
    if (self.isHuoti == NO) {
        [SVProgressHUD showErrorWithStatus:@"请先去活体检测"];
        return;
    }
    WEAKSELF
    [SVProgressHUD show];
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    NSString *token = [[NSUserDefaults standardUserDefaults]valueForKey:ZF_TOKEN];
    param[@"token"] = token;
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json", @"text/plain", @"text/html",nil];
    [manager POST:User_Huoti_Update parameters:param constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        NSDateFormatter *formatter=[[NSDateFormatter alloc]init];
        formatter.dateFormat=@"yyyyMMddHHmmss";
        NSString *str=[formatter stringFromDate:[NSDate date]];
        NSString *fileName=[NSString stringWithFormat:@"%@.jpg",str];
        NSLog(@"selectimageurl:%@",fileName);
        NSData *imageData = UIImageJPEGRepresentation(weakSelf.selectImg, 0.5);
        NSLog(@"iMAGEdata:%@",imageData);
        [formData appendPartWithFileData:imageData name:@"myseifface" fileName:fileName mimeType:@"image/jpg"];
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [SVProgressHUD dismiss];
        NSLog(@"success:%@",responseObject);
        ResponeModel *res = [ResponeModel mj_objectWithKeyValues:responseObject];
        if (res.code == 1) {
            [SVProgressHUD showSuccessWithStatus:@"上传成功"];
            [weakSelf.navigationController popViewControllerAnimated:YES];
        }else{
            [SVProgressHUD showErrorWithStatus:@"上传失败"];
            return;
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [SVProgressHUD dismiss];
        [SVProgressHUD showInfoWithStatus:FailRequestTip];
        return;
    }];
}
#pragma mark --活体检测的东西
-(void)SettingLiveWithImage:(UIImage *)image
{
    self.selectImg = image;
    self.huoti_img.image = image;
    self.isHuoti = YES;
}
@end
