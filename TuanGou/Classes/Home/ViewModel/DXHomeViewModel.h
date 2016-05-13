//
//  DXHomeViewModel.h
//  TuanGou
//
//  Created by simon on 16/5/12.
//  Copyright © 2016年 simon. All rights reserved.
//

#import <Foundation/Foundation.h>
@class DXDropNotificationModel;
@class DXHomeRequestModel;
@interface DXHomeViewModel : NSObject

///分类模型
@property (nonatomic, strong) DXDropNotificationModel *catModel;
///区域模型
@property (nonatomic, strong) DXDropNotificationModel *districtModel;
///排序模型
@property (nonatomic, strong) DXDropNotificationModel *sortModel;
///城市模型
@property (nonatomic, strong) DXDropNotificationModel *cityModel;

///请求首页的商品数据列表
+ (void)loadHomeDealsWithRequestModel:(DXHomeRequestModel *)requestMoel
                                 page:(NSNumber *)page
                             complete:(void(^)())completeBlock
                               sucess:(void(^)(NSArray *result))sucessBlock
                         failureBlock:(void (^)(NSString *errorStr))failureBlock;
@end
