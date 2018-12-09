//  ApplicationproductCell.h
//  mitugou
//  Created by zhufeng on 2018/11/7.
//  Copyright © 2018 zhufeng. All rights reserved

#import <UIKit/UIKit.h>
#import "ProductModel.h"
@interface ApplicationproductCell : UICollectionViewCell
@property (nonatomic,strong)ProductModel *productModel;
@property (nonatomic,copy) NSString *prePrefix;
@property (nonatomic,assign)BOOL isPrefix;
@end
