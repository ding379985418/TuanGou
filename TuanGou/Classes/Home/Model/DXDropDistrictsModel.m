//
//  DXDropDistrictsModel.m
//  TuanGou
//
//  Created by simon on 16/3/27.
//  Copyright © 2016年 simon. All rights reserved.
//

#import "DXDropDistrictsModel.h"
#import "DXDropDistrictsSubModel.h"

@implementation DXDropDistrictsModel
+ (NSDictionary *)objectClassInArray{
    return @{@"biz_areas":[DXDropDistrictsSubModel class]};
}
@end
