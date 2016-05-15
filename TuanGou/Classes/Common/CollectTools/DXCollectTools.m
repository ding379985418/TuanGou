//
//  DXCollectTools.m
//  TuanGou
//
//  Created by simon on 16/5/14.
//  Copyright © 2016年 simon. All rights reserved.
//

#import "DXCollectTools.h"
#import "FMDBManager.h"
#import "DXDealModel.h"
#import "FMDB.h"

@implementation DXCollectTools
//  CREATE TABLE IF NOT EXISTS t_collect_deal(id integer PRIMARY KEY, deal_id text NOT NULL, deal blob NOT NULL);";

//插入数据
+ (void)insertDealWith:(DXDealModel *)dealModel
{

    if ([self hasCollectedDealWith:dealModel]) {
        
//        [MBProgressHUD showError:@"已经收藏过...!" toView:DXApplication.keyWindow];
        ToastMessage(@"您已经收藏过!");

        return;
    }
    
    FMDBManager *manager = [FMDBManager shareManager];
    NSString *sql = @"INSERT INTO t_collect_deal (deal_id,deal) VALUES (?,?);";
    NSData *dealData = [NSKeyedArchiver archivedDataWithRootObject:dealModel];
    
    [manager.queue inDatabase:^(FMDatabase *db) {
        if ([db executeUpdate:sql,dealModel.deal_id,dealData]) {
            NSLog(@"插入成功");
            ToastMessage(@"收藏成功!");
            
        }else{
            ToastMessage(@"收藏失败!");
            NSLog(@"插入失败");
        }
    }];
}
///根据一个dealModel判断数据中是否有此数据
+ (BOOL)hasCollectedDealWith:(DXDealModel *)dealModel
{

    FMDBManager *manager = [FMDBManager shareManager];
    NSString *sql = @"SELECT deal_id FROM t_collect_deal;";
   NSArray *resultArray = [manager execRecordSet:sql];
    NSLog(@"%@",resultArray);
    BOOL hasCollected = NO;
    for (NSDictionary *dict in resultArray) {
        if ([dict[@"deal_id"] integerValue] == [dealModel.deal_id integerValue]) {
            hasCollected = YES;
            break;
        }
    }
    return hasCollected;
}
///根据一个dealModel从数据中删除
+ (BOOL)deleteDealWith:(DXDealModel *)dealModel
{
  FMDBManager *manager = [FMDBManager shareManager];

    NSString *sql = [NSString stringWithFormat:@"DELETE FROM t_collect_deal WHERE deal_id=%@;",dealModel.deal_id];
   __block BOOL isSucess = NO;
    [manager.queue inDatabase:^(FMDatabase *db) {
        if ([db executeUpdate:sql]) {
            
            ToastMessage(@"移除收藏成功!");
            isSucess = YES;
        }else{
            ToastMessage(@"移除收藏失败!");

            isSucess = NO;
        }
    }];
    return isSucess;
}
///查询数据,得到dealModel数组
+ (NSArray *)dealModelsWithPage:(NSInteger)page pageSize:(NSInteger )pageSize
{
    FMDBManager *manager = [FMDBManager shareManager];
    
    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM t_collect_deal ORDER BY id LIMIT %ld,%ld",(page - 1)*pageSize,pageSize];
    NSArray *resultArray = [manager execRecordSet:sql];
//    NSString *str = [NSString stringWithFormat:@"查询到 %ld 个数据",resultArray.count];
//    ToastMessage(str);
    NSMutableArray *tempArray = [NSMutableArray array];
    for (NSDictionary *dict in resultArray) {
        NSData *dealData = dict[@"deal"];
       DXDealModel *dealModel = (DXDealModel *)[NSKeyedUnarchiver unarchiveObjectWithData:dealData];
        [tempArray addObject:dealModel];
    }
    return [tempArray copy];
}
///返回收藏个数
+ (NSInteger)countCollected
{
    FMDBManager *manager = [FMDBManager shareManager];
    NSString *sql = @"SELECT deal_id FROM t_collect_deal;";
    NSArray *resultArray = [manager execRecordSet:sql];
    return resultArray.count;
}

@end
