//
//  DXHomeCollectionView.h
//  TuanGou
//
//  Created by simon on 16/5/13.
//  Copyright © 2016年 simon. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DXHomeCollectionView : UICollectionView
///数据源
@property (nonatomic, strong) NSArray *dataArray;
///初始化collectionView
- (instancetype)initWithCustomFrame:(CGRect)frame;

@end
