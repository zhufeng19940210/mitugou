//  HomeNavTopView.m
//  mitugou
//  Created by zhufeng on 2018/11/7.
//  Copyright © 2018 zhufeng. All rights reserved.
#import "HomeNavTopView.h"
/** 常量数 */
CGFloat const DCMargin = 10;

@interface HomeNavTopView()
/* 左边的按钮 */
@property(nonatomic,strong)UIButton *leftBarItem;
/* 右边按钮 */
@property(nonatomic,strong)UIButton *rightBarItem;
/* 搜索 */
@property (strong , nonatomic)UIView *topSearchView;
/* 搜索按钮 */
@property (strong , nonatomic)UIButton *searchButton;
/* 通知 */
@property (weak ,nonatomic) id dcObserve;

@end

@implementation HomeNavTopView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
        [self acceptanceNote];
    }
    return self;
}
-(void)setupUI
{
    self.backgroundColor = [UIColor clearColor];
    _leftBarItem = ({
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setImage:[UIImage imageNamed:@"home_sort_white"] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(actionLeftBtn:) forControlEvents:UIControlEventTouchUpInside];
        button;
    });
    _rightBarItem = ({
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setImage:[UIImage imageNamed:@"home_message_white"] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(actionRightBtn:) forControlEvents:UIControlEventTouchUpInside];
        button;
    });
    [self addSubview:_leftBarItem];
    [self addSubview:_rightBarItem];
    
    _topSearchView = [[UIView alloc] init];
    _topSearchView.backgroundColor = [UIColor whiteColor];
    _topSearchView.layer.cornerRadius = 16;
    [_topSearchView.layer masksToBounds];
    [self addSubview:_topSearchView];
    
    _searchButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_searchButton setTitle:@"搜索你想要的东西" forState:0];
    [_searchButton setTitleColor:[UIColor lightGrayColor] forState:0];
    _searchButton.titleLabel.font = [UIFont systemFontOfSize:13];
    [_searchButton setImage:[UIImage imageNamed:@"home_search_gary"] forState:0];
    [_searchButton adjustsImageWhenHighlighted];
    _searchButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    _searchButton.titleEdgeInsets = UIEdgeInsetsMake(0, 2 * DCMargin, 0, 0);
    _searchButton.imageEdgeInsets = UIEdgeInsetsMake(0, DCMargin, 0, 0);
    [_searchButton addTarget:self action:@selector(searchButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [_topSearchView addSubview:_searchButton];
}
-(void)acceptanceNote
{
    ///显示的功能
    WEAKSELF
    _dcObserve = [[NSNotificationCenter defaultCenter]addObserverForName:SHOWTOPTOOLVIEW object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note) {
        weakSelf.backgroundColor = [UIColor whiteColor];
        weakSelf.topSearchView.backgroundColor = RGB(240, 240, 240);
        [weakSelf.leftBarItem  setImage:[UIImage imageNamed:@"home_sort_white"] forState:UIControlStateNormal];
        [weakSelf.rightBarItem setImage:[UIImage imageNamed:@"home_message_white"] forState:UIControlStateNormal];
    }];
    ///隐藏的功能
    _dcObserve = [[NSNotificationCenter defaultCenter]addObserverForName:HIDETOPTOOLVIEW object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note) {
        weakSelf.backgroundColor = [UIColor clearColor];
        weakSelf.topSearchView.backgroundColor = [UIColor whiteColor];
        [weakSelf.leftBarItem  setImage:[UIImage imageNamed:@"home_sort_white"] forState:UIControlStateNormal];
        [weakSelf.rightBarItem setImage:[UIImage imageNamed:@"home_message_white"] forState:UIControlStateNormal];
    }];
}
/**
 leftBtn
 @param button leftButton
 */
-(void)actionLeftBtn:(UIButton *)button
{
    if (self.leftblock) {
        self.leftblock(button);
    }
}
/**
 rightBtn
 @param button rightBtn
 */
-(void)actionRightBtn:(UIButton *)button
{
    if (self.rightblock) {
        self.rightblock(button);
    }
}
/**
 搜索东西
 @param button 搜索的按钮
 */
-(void)searchButtonClick:(UIButton *)button
{
    if (self.searchblock) {
        self.searchblock(button);
    }
}
-(void)layoutSubviews
{
    [super layoutSubviews];
    [_leftBarItem mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).offset(Height_StatusBar);
        make.left.equalTo(self.mas_left).offset(0);
        make.height.equalTo(@44);
        make.width.equalTo(@44);
    }];
    [_rightBarItem mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self->_leftBarItem.mas_centerY);
        make.right.equalTo(self.mas_right).offset(-0);
        make.height.equalTo(@44);
        make.width.equalTo(@44);
    }];
    [_topSearchView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self->_leftBarItem.mas_right).offset(5);
        make.right.equalTo(self->_rightBarItem.mas_left).offset(5);
        make.height.equalTo(@32);
        make.centerY.equalTo(self->_rightBarItem.mas_centerY);
    }];
    [_searchButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self->_topSearchView);
        make.top.equalTo(self->_topSearchView);
        make.height.equalTo(self->_topSearchView);
        make.right.equalTo(self->_topSearchView);
    }];
}
@end
