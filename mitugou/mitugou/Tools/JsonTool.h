//
//  JsonTool.h
//  xiaochacha
//
//  Created by apple on 2018/10/31.
//  Copyright © 2018 HuiC. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface JsonTool : NSObject
#pragma mark - 字典转json
+ (NSString*)dictionaryToJson:(NSDictionary *)dic;
#pragma mark - json转字典
+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString;
@end

NS_ASSUME_NONNULL_END
