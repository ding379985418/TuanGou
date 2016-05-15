//
//  DXFMDBTools.h
//  TuanGou
//
//  Created by simon on 16/5/14.
//  Copyright © 2016年 simon. All rights reserved.
//

#import <Foundation/Foundation.h>
@class FMDatabaseQueue;
@interface FMDBManager : NSObject
///全局查询队列
@property (nonatomic, strong) FMDatabaseQueue *queue;

///创建单例对象
+ (instancetype)shareManager;
///查询数据
- (NSArray *)execRecordSet:(NSString *)sql;
@end
