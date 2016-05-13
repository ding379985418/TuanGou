//
//  DXDistrictDropViewController.h
//  TuanGou
//
//  Created by simon on 16/3/27.
//  Copyright © 2016年 simon. All rights reserved.
//

#import "DXBaseViewController.h"
@class  DXCityModel;
@interface DXDistrictDropViewController : DXBaseViewController

+ (instancetype)dropViewController;
///初始化控制器
- (instancetype)initWithCityId:(NSNumber *)cityId;

@end
