//
//  DXDropModel.h
//  TuanGou
//
//  Created by simon on 16/3/26.
//  Copyright © 2016年 simon. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DXDropCategoriesModel : NSObject
@property (nonatomic, strong) NSNumber *cat_id; //一级分类id
@property (nonatomic, copy) NSString *cat_name; //一级分类名称
@property (nonatomic, strong) NSArray *subcategories; //二级分类数组

@end
