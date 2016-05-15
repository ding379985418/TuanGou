//
//  DXCollectTools.h
//  TuanGou
//
//  Created by simon on 16/5/14.
//  Copyright © 2016年 simon. All rights reserved.
//

#import <Foundation/Foundation.h>
@class DXDealModel;
@interface DXCollectTools : NSObject
///将dealModel插入数据库
+ (void)insertDealWith:(DXDealModel *)dealModel;
///根据一个dealModel判断数据中是否有此数据
+ (BOOL)hasCollectedDealWith:(DXDealModel *)dealModel;
///根据一个dealModel从数据中删除
+ (BOOL)deleteDealWith:(DXDealModel *)dealModel;
///查询数据,得到dealModel数组
+ (NSArray *)dealModelsWithPage:(NSInteger)page pageSize:(NSInteger)pageSize;
///返回收藏个数
+ (NSInteger)countCollected;
@end
