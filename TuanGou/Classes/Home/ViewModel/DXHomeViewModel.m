//
//  DXHomeViewModel.m
//  TuanGou
//
//  Created by simon on 16/5/12.
//  Copyright © 2016年 simon. All rights reserved.
//

#import "DXHomeViewModel.h"
#import "DXDropNotificationModel.h"
#import "DXHomeRequestModel.h"
#import "DXHomeNetTool.h"
#import "DXDealModel.h"

@implementation DXHomeViewModel
-(DXDropNotificationModel *)catModel{

    DXDropNotificationModel *catModel = [DXDropNotificationModel new];
    NSDictionary *catDict = [DXUserDefaults objectForKey:KHomeUserCatInfoKey];
    if (catDict) {
        catModel = [DXDropNotificationModel objectWithKeyValues:catDict];
    }else{

    catModel.titleStr = @"全部分类";
    }
    return catModel;
}

- (DXDropNotificationModel *)districtModel{
    DXDropNotificationModel *districtModel = [DXDropNotificationModel new];
    
    NSDictionary *districtDict = [DXUserDefaults objectForKey:KHomeUserDistrictInfoKey];
    if (districtDict) {
        districtModel = [DXDropNotificationModel objectWithKeyValues:districtDict];
    }else{

        districtModel.titleStr = @"北京-全部";
        districtModel.mas_id = @(100010000);
        
    }
    return districtModel;
}

- (DXDropNotificationModel *)sortModel{


    DXDropNotificationModel *sortModel = [DXDropNotificationModel new];
    NSDictionary *sortDict = [DXUserDefaults objectForKey:KHomeUserSortInfoKey];
    if (sortDict) {
        sortModel = [DXDropNotificationModel objectWithKeyValues:sortDict];
    }else{
        sortModel.titleStr = @"默认排序";
        sortModel.subTitleStr = @"排序";
    }
    return sortModel;
    
}

- (DXDropNotificationModel *)cityModel{
    DXDropNotificationModel *cityModel = [DXDropNotificationModel new];
    NSDictionary *cityDict = [DXUserDefaults objectForKey:KHomeUserCityInfoKey];
    if (cityDict) {
        cityModel = [DXDropNotificationModel objectWithKeyValues:cityDict];
    }else{
     cityModel = [DXDropNotificationModel new];
     cityModel.titleStr = @"北京市-全部";
     cityModel.mas_id = @100010000;
    }

    
    return cityModel;
}

+ (void)loadHomeDealsWithRequestModel:(DXHomeRequestModel *)requestMoel
                                 page:(NSNumber *)page
                             complete:(void(^)())completeBlock
                               sucess:(void(^)(NSArray *result))sucessBlock
                         failureBlock:(void (^)(NSString *errorStr))failureBlock
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc]initWithDictionary:@{}];
    if (requestMoel.cityModel.mas_id) {
        [params setObject:requestMoel.cityModel.mas_id forKey:@"city_id"];
    }
 
    if (requestMoel.catModel.mas_id) {
        [params setObject:requestMoel.catModel.mas_id forKey:@"cat_ids"];
    }
//    if (requestMoel.catModel.sub_id) {
//        [params setObject:requestMoel.catModel.sub_id forKey:@"subcat_ids"];
//    }
    if (requestMoel.districtModel.mas_id &&requestMoel.cityModel.mas_id != requestMoel.districtModel.mas_id) {
        [params setObject:requestMoel.districtModel.mas_id forKey:@"district_ids"];
    }
    if (requestMoel.districtModel.sub_id) {
        [params setObject:requestMoel.districtModel.sub_id forKey:@"bizarea_ids"];
    }
    if (requestMoel.sortModel.mas_id) {
        [params setObject:requestMoel.sortModel.mas_id forKey:@"sort"];
    }
    if (requestMoel.keyWord) {
        [params setObject:requestMoel.keyWord forKey:@"keyword"];
    }
    
    [params setObject:page forKey:@"page"];
    [params setObject:@(KHomePageSize) forKey:@"page_size"];
    NSLog(@"params:%@",params);
    

    [DXHomeNetTool loadHomeDealsWithParams:params complete:completeBlock sucess:^(NSArray *result) {
        if (sucessBlock) {
            NSMutableArray *array = [DXDealModel objectArrayWithKeyValuesArray:result];
            sucessBlock([array copy]);
        }
    }  failureBlock:failureBlock];
}

@end
