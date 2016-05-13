//
//  DXDealModel.m
//  TuanGou
//
//  Created by simon on 16/5/13.
//  Copyright © 2016年 simon. All rights reserved.
//

#import "DXDealModel.h"
#import "DXShopModel.h"

@implementation DXDealModel

+ (NSDictionary *)objectClassInArray{
    return @{@"shops":[DXShopModel class]};
}
+ (NSDictionary *)replacedKeyFromPropertyName{

    return @{@"descriptions":@"description"};
}
@end
