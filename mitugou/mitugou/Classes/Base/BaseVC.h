//
//  BaseVC.h
//  mitugou
//
//  Created by zhufeng on 2018/11/3.
//  Copyright © 2018年 zhufeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseVC : UIViewController
/// 加载数据数组
@property (nonatomic,strong) NSMutableArray *dataArray;
/// 设置UINavbar右按钮(图片和文字)
- (void)setRightButton:(UIImage *)image withText:(NSString *)text;
/// 设置UINavbar左按钮（图片）
- (void)setLeftButton:(UIImage *)image;
/// 设置UINavbar左按钮（文字）
- (void)setLeftButtonText:(NSString *)text withColor:(UIColor *)textColor;
/// 设置UINavbar右按钮（图片）
- (void)setRightButton:(UIImage *)image;
/// 设置UINavbar右按钮（文字）
- (void)setRightButtonText:(NSString *)text withColor:(UIColor *)textColor;
//  设置导航栏左键点击事件
- (void)onLeftBtnAction:(UIButton *)button;
//  设置导航栏右键点击事件
- (void)onRightBtnAction:(UIButton *)button;

//刷新列表(tableview)
- (void)setViewRefreshTableView:(UITableView *)tableView withHeaderAction:(SEL)hAction andFooterAction:(SEL)fAction target:(id)target;
//刷新列表(collectionView)
- (void)setViewRefreshColletionView:(UICollectionView *)collectionView withHeaderAction:(SEL)hAction andFooterAction:(SEL)fAction target:(id)target;
//显示数据为空
-(void)setEmptyTableView:(UITableView *)tableView;
-(void)setEmptyCollectionView:(UICollectionView *)colletionView;

- (float)getLabelHeightWithText:(NSString *)text width:(float)width font: (float)font;
@end
