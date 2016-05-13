//
//  DXHomeCollectionView.m
//  TuanGou
//
//  Created by simon on 16/5/13.
//  Copyright © 2016年 simon. All rights reserved.
//

#import "DXHomeCollectionView.h"
#import "DXHomeCollectionViewCell.h"
#import "DXDealModel.h"
@interface DXHomeCollectionView () <UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>


@end
@implementation DXHomeCollectionView
static NSString *collectionReuseIdentifier = @"collectionReuseIdentifier";

- (instancetype)initWithCustomFrame:(CGRect)frame{

    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
  
    layout.itemSize = CGSizeMake(KHomeCollectionCellWith, KHomeCollectionCellWith);

    self = [super initWithFrame:frame collectionViewLayout:layout];
    self.backgroundColor = [UIColor clearColor];
    self.dataSource = self;
    self.dataSource = self;
    [self registerNib:[UINib nibWithNibName:@"DXHomeCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:collectionReuseIdentifier];
    [DXNotificationCenter addObserver:self selector:@selector(orientChange:) name:KScreenWillChangeNoticicaton object:nil];
    return self;
}


#pragma mark -私有方法
- (void)orientChange:(NSNotification *)noti{
    NSDictionary *dic = noti.userInfo;
   CGSize size = [dic[KScreenWillChangeNoticicatonSize] CGSizeValue];
    NSLog(@"%@",NSStringFromCGSize(size));
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)self.collectionViewLayout;
    NSInteger colNum = size.width == 1024?3:2;
    CGFloat inset = (size.width - colNum *KHomeCollectionCellWith )/(colNum + 1);

    layout.sectionInset = UIEdgeInsetsMake(inset, inset, inset, inset);
    layout.minimumLineSpacing = inset;
    

}
#pragma mark -setter方法
- (void)setDataArray:(NSArray *)dataArray{
    _dataArray = dataArray;
    [self reloadData];
}
#pragma mark -数据源方法
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{

    return self.dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    DXHomeCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:collectionReuseIdentifier forIndexPath:indexPath];
    DXDealModel *dealModel = self.dataArray[indexPath.item];
    cell.dealModel = dealModel;
    return cell;
}

- (void)dealloc{
    [DXNotificationCenter removeObserver:self];
}
@end
