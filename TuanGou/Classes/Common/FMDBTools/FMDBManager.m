//
//  DXFMDBTools.m
//  TuanGou
//
//  Created by simon on 16/5/14.
//  Copyright © 2016年 simon. All rights reserved.
//

#import "FMDBManager.h"
#import "FMDB.h"
#import "DXDealModel.h"
@interface FMDBManager ()

@end

@implementation FMDBManager
///数据库名称
static NSString *dbNmae = @"myDealDB.sqlite";

///单例对象
+ (instancetype)shareManager
{
    
    static FMDBManager *manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[FMDBManager alloc]init];
        NSString *path = [DXApplication.documentsPath stringByAppendingPathComponent:dbNmae];
        NSLog(@"%@",path);
     manager.queue = [FMDatabaseQueue databaseQueueWithPath:path];
        [manager createTable];
    });
    return manager;
}
///创建数据表
- (void)createTable
{
    
    NSString *sql = @"CREATE TABLE IF NOT EXISTS t_collect_deal(id integer PRIMARY KEY, deal_id text NOT NULL, deal blob NOT NULL);";
    [self.queue inDatabase:^(FMDatabase *db) {
        if ([db executeStatements:sql]) {
            NSLog(@"创表成功");
        }else{
            NSLog(@"创表失败");
        };
    }];

}
///查询数据
- (NSArray *)execRecordSet:(NSString *)sql
{

    NSMutableArray *resultArray = [NSMutableArray array];
//    打开数据库
    [self.queue inDatabase:^(FMDatabase *db) {
//        查询数据库
     FMResultSet *rs = [db executeQuery:sql];
        if (!rs) {
            NSLog(@"查询失败");
            return ;
        };
//        遍历数据集合
        while ([rs next]) {
            NSMutableDictionary *row = [[NSMutableDictionary alloc]init];
//            得到数据表的列数
            int colCount = [rs columnCount];
//            遍历每一项
            for (int i =0; i < colCount; i++) {
//                遍历每一列的名称
                NSString *colName = [rs columnNameForIndex:i];
//                遍历每一列的值
                id value = [rs objectForColumnIndex:i];
//                赋值给字典
                [row setObject:value forKey:colName];
            }
//            添加到结果数组结果中
            [resultArray addObject:row];
        }
        
    }];
    return [resultArray copy];
}


@end
