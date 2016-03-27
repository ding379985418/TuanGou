//
//  DXHomeNetTool.m
//  TuanGou
//
//  Created by simon on 16/3/26.
//  Copyright © 2016年 simon. All rights reserved.
//

#import "DXHomeNetTool.h"
#import "DXDropCategoriesModel.h"
#import "DXDropDistrictsModel.h"
#import "DXCityModel.h"
@implementation DXHomeNetTool
+ (void)loadHomeCategoriesComplete:(void(^)())completeBlock
                            sucess:(void(^)(NSArray *result))sucessBlock
                    failureBlock:(void (^)(NSString *errorStr))failureBlock

{
    
    NSString *urlStr = @"http://apis.baidu.com/baidunuomi/openapi/categories";
    
    [DXNetRequest request:GET urlStr:urlStr params:nil complete:^{
        if (completeBlock) {
            completeBlock();
        }
    } sucess:^(long status, id result) {
        if (sucessBlock) {
            NSMutableArray *arrayM = [DXDropCategoriesModel objectArrayWithKeyValuesArray:result[@"categories"]];
            sucessBlock([arrayM copy]);
        }
        
    } failure:^(long status, NSString *errorStr) {
        NSLog(@"%@",errorStr);
        if (failureBlock) {
            failureBlock(errorStr);
        }
    }];
}
//首页请求区域信息
+ (void)loadHomeDistrictsWith:(NSNumber *)city_id
                     complete:(void(^)())completeBlock
                       sucess:(void(^)(NSArray *result))sucessBlock
                 failureBlock:(void (^)(NSString *errorStr))failureBlock
{
        
    NSString *urlStr = @"http://apis.baidu.com/baidunuomi/openapi/districts";
    NSDictionary *params = @{
                             @"city_id":city_id
                             
                             };
    
    [DXNetRequest request:GET urlStr:urlStr params:params complete:^{
        if (completeBlock) {
            completeBlock();
        }
    } sucess:^(long status, id result) {
        if (sucessBlock) {
            NSMutableArray *arrayM = [DXDropDistrictsModel objectArrayWithKeyValuesArray:result[@"districts"]];
            sucessBlock([arrayM copy]);
        }
        
    } failure:^(long status, NSString *errorStr) {
        NSLog(@"%@",errorStr);
        if (failureBlock) {
            failureBlock(errorStr);
        }
    }];
}
//请求城市数据
+ (void)loadHomeCitiesComplete:(void(^)())completeBlock
                            sucess:(void(^)(NSArray *result))sucessBlock
                      failureBlock:(void (^)(NSString *errorStr))failureBlock

{
    
    NSString *urlStr = @"http://apis.baidu.com/baidunuomi/openapi/cities";
    
    [DXNetRequest request:GET urlStr:urlStr params:nil complete:^{
        if (completeBlock) {
            completeBlock();
        }
    } sucess:^(long status, id result) {
        if (sucessBlock) {
            NSMutableArray *arrayM = [DXCityModel objectArrayWithKeyValuesArray:result[@"cities"]];
            sucessBlock([arrayM copy]);
        }
        
    } failure:^(long status, NSString *errorStr) {
        NSLog(@"%@",errorStr);
        if (failureBlock) {
            failureBlock(errorStr);
        }
    }];
}

@end
