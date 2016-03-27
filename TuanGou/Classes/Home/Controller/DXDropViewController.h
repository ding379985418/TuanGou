//
//  DXDropViewController.h
//  TuanGou
//
//  Created by simon on 16/3/26.
//  Copyright © 2016年 simon. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DXDropViewController : UIViewController
///左边分类数据源
@property (nonatomic, strong) NSArray*leftCategoriesArrayData;

///左边区域数据源
@property (nonatomic, strong) NSArray*leftDistrictArrayData;

///是否为categorie信息的dropVeiw
@property (nonatomic, assign) BOOL isCategories;

///创建dropViewController
+ (instancetype)dropViewController;

@end
