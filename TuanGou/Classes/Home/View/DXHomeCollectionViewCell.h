//
//  DXHomeCollectionViewCell.h
//  TuanGou
//
//  Created by simon on 16/5/13.
//  Copyright © 2016年 simon. All rights reserved.
//

#import <UIKit/UIKit.h>
@class DXDealModel;
@interface DXHomeCollectionViewCell : UICollectionViewCell
///商品列表模型
@property (nonatomic, strong) DXDealModel *dealModel;
@end
