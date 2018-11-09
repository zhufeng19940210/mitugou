//  HomeMessageVC.m
//  mitugou
//  Created by zhufeng on 2018/11/7.
//  Copyright © 2018 zhufeng. All rights reserved.
#import "HomeMessageVC.h"
#import "HomeMessageCell.h"
@interface HomeMessageVC ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (nonatomic,strong)NSMutableArray *messageArray;
@end
@implementation HomeMessageVC
-(NSMutableArray *)messageArray
{
    if (!_messageArray) {
        _messageArray = [NSMutableArray array];
    }
    return _messageArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"系统消息";
    [self actionMessageNewData];
    [self setupTableView];
    [self setupRefresh];
}
-(void)setupRefresh
{
    [self setViewRefreshTableView:self.tableview withHeaderAction:@selector(actionMessageNewData) andFooterAction:@selector(actionMessageMoreData) target:self];
}
/**
 加载最新
 */
-(void)actionMessageNewData
{
    
}
/**
 加载更多
 */
-(void)actionMessageMoreData
{
    
}
-(void)setupTableView
{
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    self.tableview.backgroundColor = [UIColor clearColor];
    [self.tableview registerNib:[UINib nibWithNibName:@"HomeMessageCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"HomeMessageCell"];
}
#pragma mark uitableviewdelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.messageArray.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HomeMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HomeMessageCell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
@end
