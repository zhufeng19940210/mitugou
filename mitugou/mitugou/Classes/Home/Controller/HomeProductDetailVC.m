//  HomeProductDetailVC.m
//  mitugou
//  Created by zhufeng on 2018/11/8.
//  Copyright © 2018 zhufeng. All rights reserved.
#import "HomeProductDetailVC.h"
#import "CommitOrderVC.h"
#import "SettingAuthonVC.h"
#import "OrderContentCell.h"
#import "ProductBottomView.h"
#import "ProductDetailModel.h"
#import "PeriodsModel.h"
#import "ColorModel.h"
#import "DetailImageModel.h"
#import "BannerModel.h"
#import "ProductSubModel.h"
#import "HomedestailModel.h"
@interface HomeProductDetailVC ()<SDCycleScrollViewDelegate,UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic, strong) UIView *headView;
@property (nonatomic,strong) SDCycleScrollView *cycleScrollView;//轮播器
@property (nonatomic, strong) NSMutableArray *periodsArr;
@property (nonatomic, strong) NSMutableArray *netImages;
@property (nonatomic, strong) NSMutableArray *decImageUrl;
@property (nonatomic, strong) PeriodsModel *selectModel;
@property (nonatomic, strong)ProductSubModel *productSubModel; ///商品详情
@property (nonatomic)    CGFloat rowH ;
@property  (nonatomic) BOOL status;
@property (nonatomic,copy) NSString *colorStr;
@property (nonatomic,strong) NSMutableArray *colorArr;
@property (nonatomic, strong)NSMutableArray *periodsBtnArr;
@property (nonatomic, strong)NSMutableArray *colorBtnArr;
@property (nonatomic,strong) ProductBottomView *bottomView; //底部view

@end
@implementation HomeProductDetailVC

-(NSMutableArray *)periodsBtnArr
{
    if (!_periodsBtnArr) {
        _periodsBtnArr = [NSMutableArray array];
    }
    return _periodsBtnArr;
}
-(NSMutableArray *)colorBtnArr
{
    if (!_colorBtnArr) {
        _colorBtnArr = [NSMutableArray array];
    }
    return _colorBtnArr;
}
-(NSMutableArray *)colorArr
{
    if (!_colorArr) {
        _colorArr = [NSMutableArray array];
    }
    return _colorArr;
}
-(NSMutableArray *)decImageUrl
{
    if (!_decImageUrl) {
        _decImageUrl = [NSMutableArray array];
        
    }
    
    return _decImageUrl;
}

-(NSMutableArray *)periodsArr
{
    if (!_periodsArr) {
        _periodsArr = [NSMutableArray array];
    }
    
    return _periodsArr;
}

-(NSMutableArray *)netImages
{
    if (!_netImages) {
        _netImages = [NSMutableArray array];
    }
    return _netImages;
}
-(UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, IPHONE_WIDTH, IPHONE_HEIGHT-Height_NavBar-50) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.showsHorizontalScrollIndicator = NO;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        //注册cell
        [_tableView registerNib:[UINib nibWithNibName:@"OrderContentCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"OrderContentCell"];
    }
    return _tableView;
}

-(SDCycleScrollView *)cycleScrollView
{
    if (!_cycleScrollView) {
        _cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0,0, IPHONE_WIDTH, IPHONE_HEIGHT/2) delegate:self placeholderImage:[UIImage imageNamed:@"app_placeholder.png"]];
        //设置图片视图显示类型
        _cycleScrollView.bannerImageViewContentMode = UIViewContentModeScaleAspectFill;
        _cycleScrollView.clipsToBounds = YES;
        //设置自动滚动间隔时间
        _cycleScrollView.autoScrollTimeInterval = 5;
        _cycleScrollView.backgroundColor = [UIColor whiteColor];
        //设置轮播视图的分页控件的显示
        _cycleScrollView.showPageControl = YES;
        //设置轮播视图分也控件的位置
        _cycleScrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
    }
    return _cycleScrollView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"商品详情";
    [self actionProductNewData];
    [self setupUI];
    [self setupRefresh];
}
/**
 集成刷新的东西
 */
-(void)setupRefresh
{
    [self setViewRefreshTableView:self.tableView withHeaderAction:@selector(actionProductNewData) andFooterAction:nil target:self];
}
/**
 请求数据的接口
 */
-(void)actionProductNewData
{
    [SVProgressHUD show];
    NSString *token = [[NSUserDefaults standardUserDefaults]valueForKey:ZF_TOKEN];
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"token"] = token;
    param[@"cid"]   = self.productID;
    WEAKSELF
    [[NetWorkTool shareInstacne]postWithURLString:Product_Detail  parameters:param success:^(id  _Nonnull responseObject) {
        NSLog(@"responseObject:%@",responseObject);
        [SVProgressHUD dismiss];
        ResponeModel *res = [ResponeModel mj_objectWithKeyValues:responseObject];
        if (res.code == 1) {
            [SVProgressHUD showSuccessWithStatus:@"获取成功"];
            weakSelf.productSubModel = res.data[@"commodiry"];
            [weakSelf.tableView reloadData];
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
 请求设置tableview的功能
 */
-(void)setupUI
{
    self.bottomView = [[ProductBottomView alloc]initWithFrame:CGRectMake(0,IPHONE_HEIGHT-Height_NavBar-50, IPHONE_WIDTH, 50)];
    self.bottomView.backgroundColor = [UIColor redColor];
    WEAKSELF
    self.bottomView.leftBlock = ^(UIButton *btn) {
        //直接购买
        CommitOrderVC *commitordervc = [[CommitOrderVC alloc]init];
        commitordervc.detailModel = weakSelf.productSubModel;
        commitordervc.selectColor = weakSelf.colorStr;
        [weakSelf.navigationController pushViewController:commitordervc animated:YES];
    };
    self.bottomView.rightBlock = ^(UIButton *btn) {
        //分期购买
        //这里需要判断下用户是否已经认证过
        [weakSelf stagingWithAnthonBtn];
    };
    [self.view addSubview:self.bottomView];
    [self.view addSubview:self.tableView];
}
/**
 认证
 */
-(void)stagingWithAnthonBtn
{
    [SVProgressHUD show];
    NSString *token = [[NSUserDefaults standardUserDefaults]valueForKey:ZF_TOKEN];
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"token"] = token;
    WEAKSELF
    [[NetWorkTool shareInstacne]postWithURLString:@"" parameters:param success:^(id  _Nonnull responseObject) {
        [SVProgressHUD dismiss];
        ResponeModel *res = [ResponeModel mj_objectWithKeyValues:responseObject];
        if (res.code == 1) {
            //成功了直接跳转
            CommitOrderVC *commitordervc = [[CommitOrderVC alloc]init];
            commitordervc.detailModel = weakSelf.productSubModel;
            commitordervc.selectColor = weakSelf.colorStr;
            [weakSelf.navigationController pushViewController:commitordervc animated:YES];
        }else{
            //没有认证过
            SettingAuthonVC *authonvc = [[SettingAuthonVC alloc]init];
            [weakSelf.navigationController pushViewController:authonvc animated:YES];
        }
    } failure:^(NSError * _Nonnull error) {
        [SVProgressHUD dismiss];
        [SVProgressHUD showErrorWithStatus:FailRequestTip];
        return;
    }];
}
#pragma mark
#pragma mark - 轮播图的代理方法
/** 点击图片回调 */
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index{
    
    //NSLog(@"%ld",index);
}

/** 图片滚动回调 */
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didScrollToIndex:(NSInteger)index{
    //NSLog(@"%ld",index);
}

#pragma mark - uitableviewdelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 2) {
        return self.decImageUrl.count;
    }else{
        return 0;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return  IPHONE_HEIGHT/2+120;
    }
    
    /*else if (section == 1)
    {
        if (self.periodsArr.count == 0) {
            return 80*pro_HEIGHT;
            
        }else{
            NSInteger count = self.periodsArr.count;
            if (count%3 == 0) {
                return 30+60*count/3+20;
            }else{
                return 30+60*(count/3+1)+20;
            }
        }
        
    }*/
     else if (section == 1)
    {
        if (self.colorArr.count == 0) {
            return 60*pro_HEIGHT;
            
        }else{
            NSInteger count = self.colorArr.count;
            if (count%4 == 0) {
                return 30+40*count/4+20;
            }else{
                return 30+40*(count/4+1)+20;
            }
        }
        
    }else{
        return 50;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 2) {
        return CGFLOAT_MIN;
    }else{
        return 10.0f;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DetailImageModel *model = self.decImageUrl[indexPath.row];
    if (model.field2.length) {
        NSArray *arr = [model.field2 componentsSeparatedByString:@"_"];
        CGFloat W = [arr[0] doubleValue];
        CGFloat H = [arr[1] doubleValue];
        
        CGFloat atH = IPHONE_WIDTH*H/W;
        return atH;
    }else{
        return 300;
    }
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        UIView *view = [[UIView alloc]init];
        view.backgroundColor = [UIColor whiteColor];
        [view addSubview:self.cycleScrollView];
        self.cycleScrollView.imageURLStringsGroup = self.netImages;
        self.cycleScrollView.placeholderImage = [UIImage imageNamed:@"placehodel_image.png"];
        //名称
        UILabel *nameLab = [[UILabel alloc]init];
        nameLab.font = [UIFont systemFontOfSize:16];
        nameLab.text = self.productSubModel.cname;
        nameLab.textColor = [UIColor blackColor];
        [nameLab setSingleLineAutoResizeWithMaxWidth:IPHONE_WIDTH];
        [view addSubview:nameLab];
        //描述文件
        UILabel *desLab = [UILabel new];
        desLab.font = [UIFont systemFontOfSize:13];
        desLab.textColor = [UIColor darkGrayColor];
        desLab.numberOfLines= 2;
        desLab.text = self.productSubModel.description;
        [view addSubview:desLab];
        //价格
        UILabel *priceLab = [UILabel new];
        priceLab.textColor = [UIColor redColor];
        priceLab.text = [NSString stringWithFormat:@"￥%.2f",[self.productSubModel.price doubleValue]];
        priceLab.font = [UIFont systemFontOfSize:18];
        [priceLab setSingleLineAutoResizeWithMaxWidth:IPHONE_WIDTH];
        [view addSubview:priceLab];
        //接下来去布局使用
        nameLab.sd_layout
        .leftSpaceToView(view, 10)
        .topSpaceToView(self.cycleScrollView, 10)
        .autoHeightRatio(0);
        
        desLab.sd_layout
        .leftEqualToView(nameLab)
        .topSpaceToView(nameLab, 5)
        .rightSpaceToView(view, 10)
        .heightIs(35);
        
        priceLab.sd_layout
        .leftEqualToView(nameLab)
        .topSpaceToView(desLab, 0)
        .autoHeightRatio(0);
        return view;
    }
    /*else if (section == 1){
        //选择分期
        UIView *view = [UIView new];
        view.backgroundColor = [UIColor whiteColor];
        view.userInteractionEnabled = YES;
        //选择分期
        UILabel *titleLab = [UILabel new];
        titleLab.text = @"选择分期";
        titleLab.font = [UIFont systemFontOfSize:16];
        titleLab.textColor = [UIColor blackColor];
        [titleLab setSingleLineAutoResizeWithMaxWidth:IPHONE_WIDTH];
        [view addSubview:titleLab];
        
        CGFloat w = (IPHONE_WIDTH-40)/3.0;
        for (int i = 0; i< self.periodsArr.count; i++) {
            PeriodsModel *model = self.periodsArr[i];
            NSInteger row = i/3;
            NSInteger col = i%3;
            CGFloat margin = 10;
            CGFloat picx = margin +(w+margin)*col;
            CGFloat picy = margin +(50+margin)*row+30;
            NSString *title = [NSString stringWithFormat:@"%@/%@(含手续费)\n￥%.2f/期",model.periodNumName,model.periodTypeName,[model.totalAmount doubleValue]];
            UIButton  *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.frame = CGRectMake(picx, picy, w, 50);
            btn.titleLabel.font = [UIFont systemFontOfSize:10];
            btn.titleLabel.numberOfLines = 0;
            [btn setTitle:title forState:UIControlStateNormal];
            [view addSubview:btn];
            btn.tag = i+1;
            btn.clipsToBounds = YES;
            btn.layer.cornerRadius = 5;
            if (model.isSelect == YES) {
                btn.backgroundColor = MainThemeColor;
                [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                self.selectModel = model;
            }else{
                btn.backgroundColor = RGB(240, 240, 240);
                [btn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
            }
            [btn addTarget:self action:@selector(selectParir:) forControlEvents:UIControlEventTouchUpInside];
            [self.periodsBtnArr addObject:btn];
        }
            titleLab.sd_layout
            .leftSpaceToView(view, 10)
            .topSpaceToView(view, 5)
            .autoHeightRatio(0);
            if (self.periodsArr.count == 0) {
                UILabel *lab = [UILabel new];
                lab.text = @"暂无分期可选";
                lab.textColor = [UIColor blackColor];
                lab.font = [UIFont systemFontOfSize:16];
                [lab setSingleLineAutoResizeWithMaxWidth:IPHONE_WIDTH];
                [view addSubview:lab];
                
                lab.sd_layout
                .centerXEqualToView(view)
                .centerYEqualToView(view)
                .autoHeightRatio(0);
            }
            return view;
    }*/
     
     else if (section == 1){
        //选择颜色
        UIView *view = [UIView new];
        view.backgroundColor = [UIColor whiteColor];
        view.userInteractionEnabled = YES;
        
        UILabel *titleLab = [UILabel new];
        titleLab.text = @"选择颜色";
        titleLab.font = [UIFont systemFontOfSize:16];
        titleLab.textColor = [UIColor blackColor];
        [titleLab setSingleLineAutoResizeWithMaxWidth:IPHONE_WIDTH];
        [view addSubview:titleLab];
        
        CGFloat w = (IPHONE_WIDTH-40)/4.0;
        for(int i = 0; i < self.colorArr.count;i++){
            ColorModel *model = self.colorArr[i];
            NSInteger row = i/4;
            NSInteger col = i%4;
            CGFloat margin = 10;
            CGFloat picx = margin+(w+margin)*col;
            CGFloat picy = margin+(50+margin)*row+30;
            NSString *title = model.color;
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.frame = CGRectMake(picx, picy, w, 40);
            btn.titleLabel.font = [UIFont systemFontOfSize:14];
            btn.titleLabel.numberOfLines = 0;
            [btn setTitle:title forState:UIControlStateNormal];
            [view addSubview:btn];
            btn.tag = i+1;
            btn.clipsToBounds = YES;
            btn.layer.cornerRadius = 5;
            if (model.isSelect == YES) {
                btn.backgroundColor = MainThemeColor;
                [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                self.colorStr = model.color;
            }else{
                btn.backgroundColor = RGB(24, 240, 240);
                [btn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
            }
            [btn addTarget:self action:@selector(selectColor:) forControlEvents:UIControlEventTouchUpInside];
            [self.colorBtnArr addObject:btn];
        }
        titleLab.sd_layout
        .leftSpaceToView(view, 10)
        .topSpaceToView(view, 5)
        .autoHeightRatio(0);
        if (self.colorArr.count == 0) {
            UILabel *lab = [UILabel new];
            lab.text = @"暂无颜色可选";
            lab.textColor = [UIColor blackColor];
            lab.font = [UIFont systemFontOfSize:16];
            [lab setSingleLineAutoResizeWithMaxWidth:IPHONE_HEIGHT];
            [view addSubview:lab];
            
            lab.sd_layout
            .centerXEqualToView(view)
            .centerYEqualToView(view)
            .autoHeightRatio(0);
        }
        return view;
    }else{
        //商品详情
        UIView *view = [UIView new];
        view.backgroundColor = [UIColor whiteColor];
        
        UILabel *lab = [UILabel new];
        lab.text = @"商品详情";
        lab.textColor = [UIColor blackColor];
        lab.font = [UIFont systemFontOfSize:16];
        [lab setSingleLineAutoResizeWithMaxWidth:IPHONE_WIDTH];
        [view addSubview:lab];
        
        lab.sd_layout
        .leftSpaceToView(view, 10)
        .topSpaceToView(view, 5)
        .autoHeightRatio(0);
        
        return view;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
        UIImageView *imag = [[UIImageView alloc]init];
        imag.contentMode = UIViewContentModeScaleAspectFill;
        imag.clipsToBounds = YES;
        [cell.contentView addSubview:imag];
        
        imag.sd_layout
        .topSpaceToView(cell.contentView, 0)
        .leftSpaceToView(cell.contentView, 0)
        .rightSpaceToView(cell.contentView, 0)
        .bottomSpaceToView(cell.contentView, 0);
        
        DetailImageModel *model = self.decImageUrl[indexPath.row];
        [imag sd_setImageWithURL:[NSURL URLWithString:model.picUrl] placeholderImage:[UIImage imageNamed:@""]];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

/**
 选择分期的功能
 @param btn 选择分期的功能
 */
-(void)selectParir:(UIButton *)btn
{
    PeriodsModel *model = self.periodsArr[btn.tag - 1];
    self.selectModel = model;
    for (UIButton *aBtn in self.periodsBtnArr) {
        if (aBtn == btn) {
            //选择中
            aBtn.backgroundColor = MainThemeColor;
            [aBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        }else{
            //未选中
            aBtn.backgroundColor = RGB(240, 240, 240);
            [aBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        }
    }
}
/**
 选择颜色的功能
 @param btn 选择颜色的功能
 */
-(void)selectColor:(UIButton *)btn
{
    ColorModel *model = self.colorArr[btn.tag-1];
    self.colorStr = model.color;
    for (UIButton *aBtn in self.colorBtnArr) {
        if (aBtn == btn) {
            aBtn.backgroundColor = MainThemeColor;
            [aBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        }else{
            aBtn.backgroundColor = RGB(240, 240, 240);
            [aBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        }
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
