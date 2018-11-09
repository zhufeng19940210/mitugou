//  AddressEditVC.m
//  mitugou
//  Created by zhufeng on 2018/11/8.
//  Copyright © 2018 zhufeng. All rights reserved.
#import "AddressEditVC.h"
@interface AddressEditVC ()
@end
@implementation AddressEditVC

- (void)viewDidLoad {
    [super viewDidLoad];
    if (self.isEdit) {
        //是编辑
        self.navigationItem.title = @"编辑地址";
    }else{
      //添加地址
        self.navigationItem.title = @"添加地址";
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
@end
