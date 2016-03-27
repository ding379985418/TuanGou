//
//  DXHomeNetTool.h
//  TuanGou
//
//  Created by simon on 16/3/26.
//  Copyright © 2016年 simon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DXNetRequest.h"
@interface DXHomeNetTool : NSObject
///获取首页分类信息
+ (void)loadHomeCategoriesComplete:(void(^)())completeBlock
                            sucess:(void(^)(NSArray *result))sucessBlock
                      failureBlock:(void (^)(NSString *errorStr))failureBlock;
///首页请求区域信息
+ (void)loadHomeDistrictsWith:(NSNumber *)city_id
                     complete:(void(^)())completeBlock
                       sucess:(void(^)(NSArray *result))sucessBlock
                 failureBlock:(void (^)(NSString *errorStr))failureBlock;
///请求城市数据
+ (void)loadHomeCitiesComplete:(void(^)())completeBlock
                        sucess:(void(^)(NSArray *result))sucessBlock
                  failureBlock:(void (^)(NSString *errorStr))failureBlock;
@end
