//
//  DXHomeRequestModel.h
//  TuanGou
//
//  Created by simon on 16/5/12.
//  Copyright © 2016年 simon. All rights reserved.
//

#import <Foundation/Foundation.h>
@class DXDropNotificationModel;
@interface DXHomeRequestModel : NSObject
///分类模型
@property (nonatomic, strong) DXDropNotificationModel *catModel;
///区域模型
@property (nonatomic, strong) DXDropNotificationModel *districtModel;
///排序模型
@property (nonatomic, strong) DXDropNotificationModel *sortModel;
///城市模型
@property (nonatomic, strong) DXDropNotificationModel *cityModel;
///关键字
@property (nonatomic, strong) NSString *keyWord;

@end
