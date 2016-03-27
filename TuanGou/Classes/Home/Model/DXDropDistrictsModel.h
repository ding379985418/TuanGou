//
//  DXDropDistrictsModel.h
//  TuanGou
//
//  Created by simon on 16/3/27.
//  Copyright © 2016年 simon. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DXDropDistrictsModel : NSObject
@property (nonatomic, strong) NSNumber *district_id; //行政区id
@property (nonatomic, copy) NSString *district_name; //行政区名称
@property (nonatomic, strong) NSArray *biz_areas; //二级分类数组
@end


          