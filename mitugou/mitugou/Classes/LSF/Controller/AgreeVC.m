//  AgreeVC.m
//  mitugou
//  Created by zhufeng on 2018/11/5.
//  Copyright © 2018 zhufeng. All rights reserved.
#import "AgreeVC.h"
@interface AgreeVC ()<UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *webview;
@end
@implementation AgreeVC
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"协议";
    [SVProgressHUD show];
    NSURL *filePath = [[NSBundle mainBundle] URLForResource:@"协议.html" withExtension:nil];
    NSURLRequest *request = [NSURLRequest requestWithURL:filePath];
    self.webview.delegate = self;
    [self.webview loadRequest:request];
}
#pragma mark - uiwebViewDelegate
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    NSLog(@"加载成功");
    [SVProgressHUD dismiss];
    [SVProgressHUD showSuccessWithStatus:@"加载成功"];
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    NSLog(@"失败了");
    [SVProgressHUD dismiss];
    [SVProgressHUD showErrorWithStatus:@"加载失败"];
}
@end
