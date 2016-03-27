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
@property (nonatomic, strong) NSNumber *cityId;
+ (instancetype)dropViewController;

@end
