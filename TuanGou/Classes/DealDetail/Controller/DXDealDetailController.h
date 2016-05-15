//
//  DXDealDetailController.h
//  TuanGou
//
//  Created by simon on 16/5/13.
//  Copyright © 2016年 simon. All rights reserved.
//

#import "DXBaseViewController.h"
@class DXDealModel;
@interface DXDealDetailController : DXBaseViewController
@property (nonatomic, strong) DXDealModel *dealModel;
- (instancetype)initDetailControllerWith:(DXDealModel *)dealModel;
@end
