//
//  DXDropModel.m
//  TuanGou
//
//  Created by simon on 16/3/26.
//  Copyright © 2016年 simon. All rights reserved.
//

#import "DXDropCategoriesModel.h"
#import "DXDropCategoriesSubModel.h"
@implementation DXDropCategoriesModel
+ (NSDictionary *)objectClassInArray{
    return @{@"subcategories":[DXDropCategoriesSubModel class]};
}
@end
