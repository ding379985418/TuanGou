//
//  DXDealCollectController.m
//  TuanGou
//
//  Created by simon on 16/5/15.
//  Copyright © 2016年 simon. All rights reserved.
//

#import "DXDealCollectController.h"
#import "DXCollectTools.h"
#import "DXHomeCollectionView.h"
#import "DXDealModel.h"
#import "DXDealDetailController.h"

@interface DXDealCollectController ()
///数据源
@property (nonatomic, strong) NSMutableArray *dataArray;
///选中的数据数组
@property (nonatomic, strong) NSMutableArray *deleteArray;
///collectView
@property (nonatomic, strong) DXHomeCollectionView *collectView;
///page
@property (nonatomic, assign) NSInteger page;
///全选按钮
@property (nonatomic, strong) UIBarButtonItem *allSelItem;
///全不选按钮
@property (nonatomic, strong) UIBarButtonItem *allNotSelItem;
///删除按钮
@property (nonatomic, strong) UIBarButtonItem *deleteItem;
@end

@implementation DXDealCollectController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self loadNewData];
    [DXNotificationCenter postNotificationName:KScreenWillChangeNoticicaton object:nil
        userInfo:@{KScreenWillChangeNoticicatonSize:[NSValue valueWithCGSize:self.view.size]}];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUp];

}

#pragma mark -加载收藏数据
- (void)loadDataComplete:(void(^)())completeBlock
                  sucess:(void(^)(NSArray *result))suceesBlock
               failure:(void(^)())failureBlock
{
   NSArray *rsultArray = [DXCollectTools dealModelsWithPage:self.page pageSize:KHomePageSize];
    if (rsultArray.count) {
        if (suceesBlock) {
            suceesBlock(rsultArray);
        }
        if (completeBlock) {
            completeBlock();
        }
    }else{
        if (failureBlock) {
            failureBlock();
        }
        if (completeBlock) {
            completeBlock();
        }
    }
   

}
#pragma mark -加载最新数据
- (void)loadNewData{

    self.page = 1;
    [self loadDataComplete:nil sucess:^(NSArray *result) {
        [self.dataArray removeAllObjects];
        [self.dataArray addObjectsFromArray:result];
        [self showCollectedDeals];
    } failure:^{
        [self showNoData];
    }];
    self.navigationItem.rightBarButtonItem.enabled = self.dataArray.count;
}

#pragma mark -加载更过数据
- (void)loadMoreData{
    NSInteger totalCount = [DXCollectTools countCollected];
    
    if (self.dataArray.count >= totalCount) {
        self.collectView.footer.hidden = YES;
        [MBProgressHUD showError:@"没有更过的收藏了" toView:self.view];
        return;
    }
    self.page ++;
    [self loadDataComplete:^{
        [self.collectView.footer endRefreshing];
    } sucess:^(NSArray *result) {
        [self.dataArray addObjectsFromArray:result];
        self.collectView.dataArray = [self.dataArray copy];
        
    } failure:^{
        NSInteger temp = self.page;
        if (temp --) {
            self.page --;
        }
        [MBProgressHUD showError:@"没有更过的收藏了" toView:self.view];
        self.collectView.footer.hidden = YES;
    }];

}


#pragma mark -点击Cell详情通知
- (void)collectionViewCellClick:(NSNotification *)noti {
    DXDealModel *dealModel =
    noti.userInfo[KHomeCollectionCellClickNoticicatonKey];
    if (dealModel.isEditing) {
//        NSString *str = [NSString stringWithFormat:@"%d",dealModel.isSelected];
//        ToastMessage(str);
        if (dealModel.isSelected) {
            [self.deleteArray addObject:dealModel];
        }else{
            if ([self.deleteArray containsObject:dealModel]) {
                [self.deleteArray removeObject:dealModel];
            }
        }
        UIButton *allSelBtn = (UIButton *)self.allSelItem.customView;
        allSelBtn.enabled = self.deleteArray.count <self.dataArray.count;
        UIButton *allNotSelBtn = (UIButton *)self.allNotSelItem.customView;
        allNotSelBtn.enabled = (self.deleteArray.count != 0);
        
        UIButton *deleteBtn = (UIButton *)self.deleteItem.customView;
        deleteBtn.enabled = (self.deleteArray.count != 0);
        return;
    }
    DXDealDetailController *dealDetailVc =
    [[DXDealDetailController alloc] initDetailControllerWith:dealModel];
    
    dealDetailVc.dealModel = dealModel;
    
    [self presentViewController:dealDetailVc animated:YES completion:nil];
    NSLog(@"----%@", dealModel.title);
}


#pragma mark -初始化
- (void)setUp {
    self.title = @"我的收藏板块";
    self.page = 1;
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithTitle:@"编辑" style:UIBarButtonItemStylePlain target:self action:@selector(editMyDeals:)];
    [rightItem setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor grayColor]} forState:UIControlStateDisabled];
    self.navigationItem.rightBarButtonItem = rightItem;
    [self.navigationItem.rightBarButtonItem setTintColor:KDefaultColor];
    [self showNoData];
    DXWeakSelf;
    [self.collectView addLegendFooterWithRefreshingBlock:^{
        [weakSelf loadMoreData];
    }];
    [DXNotificationCenter addObserver:self
                             selector:@selector(collectionViewCellClick:)
                                 name:KHomeCollectionCellClickNoticicaton
                               object:nil];
    [self setUpNavi];
}

#pragma mark -初始化naviBar
- (void)setUpNavi{
    UIBarButtonItem *backItem = [UIBarButtonItem barButtonItemWithName:@"返回" imageNameNor:@"icon_back" imageNameHig:@"icon_back_highlighted" addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    self.allSelItem = [self createItemTitle:@"全选" target:self action:@selector(selectAllDeals)];
    self.allNotSelItem = [self createItemTitle:@"全不选" target:self action:@selector(allDealsNotSelect)];
    self.deleteItem = [self createItemTitle:@"删除" target:self action:@selector(deleteDeals)];
    self.navigationItem.leftBarButtonItems = @[backItem,self.allSelItem,self.allNotSelItem,self.deleteItem];
}
#pragma mark -全选
- (void)selectAllDeals
{
    UIButton *btn = (UIButton *)self.allSelItem.customView;
    for (DXDealModel *model in self.dataArray) {
        model.isSelected = YES;
    }
    self.collectView.dataArray = [self.dataArray copy];
    [self.deleteArray removeAllObjects];
    [self.deleteArray addObjectsFromArray:[self.dataArray copy]];
    btn.enabled = NO;
   
    UIButton *allNotSelBtn = (UIButton *)self.allNotSelItem.customView;
    UIButton *deleteBtn = (UIButton *)self.deleteItem.customView;
    allNotSelBtn.enabled = YES;
    deleteBtn.enabled = YES;
    
}

#pragma mark -全不选
- (void)allDealsNotSelect
{
    UIButton *btn = (UIButton *)self.allNotSelItem.customView;
    for (DXDealModel *dealModel in self.dataArray) {
        dealModel.isSelected = NO;
    }
    self.collectView.dataArray = self.dataArray;
    [self.deleteArray removeAllObjects];
    btn.enabled = NO;
    UIButton *allSelBtn = (UIButton *)self.allSelItem.customView;
    allSelBtn.enabled = YES;
    UIButton *deleteBtn = (UIButton *)self.deleteItem.customView;
    deleteBtn.enabled = NO;
    
}
#pragma mark -删除
- (void)deleteDeals
{
    UIButton *btn = (UIButton *)self.deleteItem.customView;
    for (DXDealModel *dealModel in self.deleteArray) {
        [self.dataArray removeObject:dealModel];
        [DXCollectTools deleteDealWith:dealModel];
    }
    [self.deleteArray removeAllObjects];
    self.collectView.dataArray = [self.dataArray copy];
    btn.enabled  = NO;
    UIButton *allNotSelBtn = (UIButton *)self.allNotSelItem.customView;
    allNotSelBtn.enabled = NO;
    UIButton *allSelBtn = (UIButton *)self.allSelItem.customView;
    allSelBtn.enabled = self.deleteArray.count < self.dataArray.count;
}


#pragma mark -编辑
- (void)editMyDeals:(UIBarButtonItem *)sender
{
    if ([sender.title isEqualToString:@"编辑"]) {
//        编辑状态
        [self editDealCollecteds];
        [sender setTitle:@"完成"];
    }else{
        [self editeDealFinish];
        [sender setTitle:@"编辑"];
//        编辑完成
    }

}
#pragma mark -编辑中
- (void)editDealCollecteds{
    UIButton *allSelBtn = (UIButton *)self.allSelItem.customView;
   UIButton *allNotSelBtn = (UIButton *)self.allNotSelItem.customView;
    UIButton *deleteBtn = (UIButton *)self.deleteItem.customView;
    allSelBtn.enabled = self.deleteArray.count < self.dataArray.count;
    allSelBtn.hidden = NO;
    allNotSelBtn.hidden = NO;
    allNotSelBtn.enabled = NO;
    deleteBtn.hidden = NO;
    deleteBtn.enabled = NO;
    self.collectView.footer.hidden = YES;
    for (DXDealModel *dealModel in self.dataArray) {
        dealModel.isEditing = YES;
    }
    self.collectView.dataArray = self.dataArray;
}
#pragma mark -编辑完成
- (void)editeDealFinish{
    self.collectView.footer.hidden = NO;
    UIButton *allSelBtn = (UIButton *)self.allSelItem.customView;
UIButton *allNotSelBtn = (UIButton *)self.allNotSelItem.customView;
    UIButton *deleteBtn = (UIButton *)self.deleteItem.customView;
    allSelBtn.hidden = YES;
    allNotSelBtn.hidden = YES;
    deleteBtn.hidden = YES;
    for (DXDealModel *dealModel in self.dataArray) {
        dealModel.isEditing = NO;
        dealModel.isSelected = NO;
    }
    self.collectView.dataArray = self.dataArray;
    [self.deleteArray removeAllObjects];
    [self loadNewData];
}


#pragma mark -点击事件
- (void)back{
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (UIBarButtonItem *)createItemTitle:(NSString *)title
                              target:(id)target
                              action:(SEL)action
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitle:title forState:UIControlStateDisabled];
    [btn setTitleColor:KDefaultColor forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled];
    btn.titleLabel.font = [UIFont systemFontOfSize:14];
    [btn sizeToFit];
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchDown];
    btn.hidden = YES;
    return [[UIBarButtonItem alloc]initWithCustomView:btn];
}
#pragma mark -显示收藏的数据
- (void)showCollectedDeals{
    self.collectView.hidden = NO;
    [DXNoDataView hiddenNoDataViewFromView:self.view];
    self.collectView.dataArray = [self.dataArray copy];
}

#pragma mark -显示无数据
- (void)showNoData{
   [DXNoDataView ShowNoDataViewWithType:DXNoDataViewType_Collects_empty toView:self.view];
    self.collectView.hidden = YES;
    self.collectView.dataArray = @[];
}

#pragma mark -懒加载
- (NSMutableArray *)deleteArray{
    if (!_deleteArray) {
        _deleteArray = [NSMutableArray array];
    }
    return _deleteArray;
}
- (NSMutableArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    
    return _dataArray;
}

- (DXHomeCollectionView *)collectView{
    if (!_collectView) {
        _collectView = [[DXHomeCollectionView alloc]initWithCustomFrame:self.view.bounds];
        [self.view addSubview:_collectView];
        _collectView.hidden = YES;
    }
    return _collectView;
}

- (void)dealloc{
    [DXNotificationCenter removeObserver:self];

}
@end
