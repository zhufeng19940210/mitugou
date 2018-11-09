//  HomeSearchVC.m
//  mitugou
//  Created by zhufeng on 2018/11/7.
//  Copyright © 2018 zhufeng. All rights reserved.
#import "HomeSearchVC.h"

@interface HomeSearchVC ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic,strong)UITextField *search_tf;
@property (nonatomic,assign)BOOL isSearch; //是否搜索
@property (nonatomic,strong)NSMutableArray *searchArray;
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
    [self setupConfigNavitionBar];
}
-(void)setupConfigNavitionBar
{
    [self setRightButtonText:@"搜索" withColor:[UIColor blackColor]];
    UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, IPHONE_WIDTH*0.8, 34)];
    textField.layer.masksToBounds = YES;
    textField.layer.cornerRadius = 4.0f;
    textField.backgroundColor = RGB(235, 240, 242);
    textField.font = [UIFont systemFontOfSize:15]; // 字体颜色
    NSMutableDictionary *attrs = [NSMutableDictionary dictionary]; // 创建属性字典
    attrs[NSFontAttributeName] = [UIFont systemFontOfSize:15]; // 设置font
    attrs[NSForegroundColorAttributeName] = RGB(153, 153, 153); // 设置颜色
    NSAttributedString *attStr = [[NSAttributedString alloc] initWithString:@"输入关键字学校名称/区域地址" attributes:attrs];
    textField.attributedPlaceholder = attStr;
    textField.textColor = [UIColor blackColor];
    textField.tintColor = RGB(153, 153, 153);
    textField.leftView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"home_search_gary"]];
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
    //[textField becomeFirstResponder];
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
/**
 点击搜索的功能
 @param button 搜索功能
 */
- (void)onRightBtnAction:(UIButton *)button
{
    NSLog(@"搜索的功能");
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
@end
