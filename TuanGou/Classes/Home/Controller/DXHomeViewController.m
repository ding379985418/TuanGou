//
//  DXHomeViewController.m
//  TuanGou
//
//  Created by simon on 16/3/26.
//  Copyright © 2016年 simon. All rights reserved.
//

#import "DXHomeViewController.h"
#import "DXHomeNaviBarItem.h"
#import "DXDropViewController.h"
#import "DXDropCategoriesModel.h"
#import "DXHomeNetTool.h"
#import "DXDistrictDropViewController.h"
#import "DXSortController.h"
#import "DXSortModel.h"
 #import "DXDropNotificationModel.h"
#import "DXHomeViewModel.h"
#import "DXHomeRequestModel.h"
#import "DXHomeCollectionView.h"
@interface DXHomeViewController ()
//分类Item
@property (nonatomic, strong) UIBarButtonItem *categoryItem;
//区域Item
@property (nonatomic, strong) UIBarButtonItem *sortItem;

//排序Item
@property (nonatomic, strong) UIBarButtonItem *districtItem;
//分类模型
@property (nonatomic, strong) DXDropNotificationModel *catModel;
//区域模型
@property (nonatomic, strong) DXDropNotificationModel *districtModel;
//排序模型
@property (nonatomic, strong) DXDropNotificationModel *sortModel;
//城市模型
@property (nonatomic, strong) DXDropNotificationModel *cityModel;
///请求数据页数
@property (nonatomic, assign) NSInteger page;
///collectioView
@property (nonatomic, strong) DXHomeCollectionView *collectionView;
@end

@implementation DXHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self getUserInfoData];
    [self setUpNavibar];
    [self addNoticicatons];
    [self viewWillTransitionToSize:self.view.size withTransitionCoordinator:nil];
    DXWeakSelf;
    [self.collectionView addLegendHeaderWithRefreshingBlock:^{
        [weakSelf loadNewData];
    }];
    [self.collectionView addLegendFooterWithRefreshingBlock:^{
        [weakSelf loadMoreData];
    }];
    [self.collectionView.header beginRefreshing];
    


}
#pragma mark -privateMetod
- (void)loadMoreData{
     self.page ++;
    [self loadDataComplete:^{
        [self.collectionView.footer endRefreshing];
    } sucess:^(NSArray *array) {
        NSMutableArray *tempArray = [NSMutableArray arrayWithArray:self.collectionView.dataArray];
        [tempArray removeLastObject];
        [tempArray addObjectsFromArray:array];
        
        self.collectionView.dataArray = tempArray;
    } failure:^{
        [MBProgressHUD showError:@"网络错误,请稍后重试..." toView:self.view];
        NSInteger tempPage = self.page;
        if (tempPage --) {
            self.page --;
        }
    }];
    

}
- (void)loadNewData{
    self.page = 1;
    [self loadDataComplete:^{
        [self.collectionView.header endRefreshing];
    } sucess:^(NSArray *array) {
        if (array.count == 0) {
            [DXNoDataView ShowNoDataViewWithType:DXNoDataViewType_Deals_empty toView:self.view];
            self.collectionView.footer.hidden = YES;
        }else{
            
            [DXNoDataView hiddenNoDataViewFromView:self.view];
            self.collectionView.dataArray = array;
            self.collectionView.footer.hidden = NO;

        }
       
    } failure:^{
        NSLog(@"********错误");
        [DXNoDataView ShowNoDataViewWithType:DXNoDataViewType_NetError toView:self.view];
        self.collectionView.footer.hidden = YES;

    }];
}

- (void)loadDataComplete:(void(^)())completeBlock sucess:(void(^)(NSArray *array))sucessBlock failure:(void(^)())failureBlock
{
    [MBProgressHUD showMessage:@"正在加载..." toView:self.view];
    
    DXHomeRequestModel *requestModel = [DXHomeRequestModel new];
    requestModel.catModel = self.catModel;
    requestModel.cityModel = self.cityModel;
//    requestModel.districtModel = self.districtModel;
    requestModel.sortModel = self.sortModel;
    self.collectionView.footer.hidden = NO;
    [DXHomeViewModel loadHomeDealsWithRequestModel:requestModel page:@(self.page) complete:^{
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        if (completeBlock) {
            completeBlock();
        }
    } sucess:^(NSArray *result) {
        [DXNoDataView hiddenNoDataViewFromView:self.view];

        if (sucessBlock) {
            sucessBlock(result);
        }
        NSLog(@"%@",result);
    } failureBlock:^(NSString *errorStr) {
        NSLog(@"%@",errorStr);
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (failureBlock) {
            failureBlock();
        }
    }];
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator
{
    [UIView animateWithDuration:coordinator.transitionDuration animations:^{
       self.collectionView.size = size;
    }];

    [DXNotificationCenter postNotificationName:KScreenWillChangeNoticicaton object:nil userInfo:@{KScreenWillChangeNoticicatonSize:[NSValue valueWithCGSize:size]}];
}

//添加通知
- (void)addNoticicatons
{
    [DXNotificationCenter addObserver:self selector:@selector(homeSortControllerNoticicaton:) name:KHomeSortControllerNoticicaton object:nil];
    
    [DXNotificationCenter addObserver:self selector:@selector(homeCateControllerNoticicaton:) name:KHomeCateControllerNoticicaton object:nil];
    
    [DXNotificationCenter addObserver:self selector:@selector(homeDistControllerNoticicaton:) name:KHomeDistControllerNoticicaton object:nil];
     [DXNotificationCenter addObserver:self selector:@selector(homeChangeCityControllerNoticicaton:) name:KHomeChangeCityControllerNoticicaton object:nil];
   
    

}
//获取数据
- (void)getUserInfoData
{
    DXHomeViewModel *viewModel = [DXHomeViewModel new];
    self.catModel = viewModel.catModel;
    self.districtModel = viewModel.districtModel;
    self.sortModel = viewModel.sortModel;
    self.cityModel = viewModel.cityModel;
    self.page = 1;

}
//设置导航栏
- (void)setUpNavibar {
    [self setUpLeftItems];
    [self setUpRightItems];
    self.collectionView = [[DXHomeCollectionView alloc]initWithCustomFrame:CGRectMake(0, 0,KScreenWith, KScreenHeight - 44)];
    [self.view addSubview:self.collectionView];
}
//设置导航栏右边按钮
- (void)setUpRightItems{
//    设置地图Item
    UIBarButtonItem *localItem = [UIBarButtonItem barButtonItemWithName:nil imageNameNor:@"icon_map" imageNameHig:@"icon_map_highlighted" addTarget:self action:@selector(mapBarButtonClick) forControlEvents:UIControlEventTouchUpInside];
    localItem.customView.width = KHomeNaviBarMapWith;
//    设置搜索Item
    UIBarButtonItem *searchItem = [UIBarButtonItem barButtonItemWithName:nil imageNameNor:@"icon_search" imageNameHig:@"icon_search_highlighted" addTarget:self action:@selector(searchBarButtonClick) forControlEvents:UIControlEventTouchUpInside];
    searchItem.customView.width = KHomeNaviBarMapWith;
    
    self.navigationItem.rightBarButtonItems = @[localItem,searchItem];
    
}

//设置导航栏左边按钮
- (void)setUpLeftItems{

//    设置logItem
    UIBarButtonItem *logoItem = [UIBarButtonItem barButtonItemWithName:nil imageNameNor:@"icon_meituan_logo" imageNameHig:@"icon_meituan_logo" addTarget:nil action:nil forControlEvents:UIControlEventTouchUpInside];
    logoItem.customView.width = 100;
    
//   设置分类Item
    DXHomeNaviBarItem *categoryView = [DXHomeNaviBarItem homeNaviBarItemWithNorImgName:@"icon_category_-1" hightImgName:@"icon_category_highlighted_-1" title:self.catModel.titleStr subTitle:self.catModel.subTitleStr target:self action:@selector(categoryItemClick) events:UIControlEventTouchUpInside];
       UIBarButtonItem *categoryItem = [[UIBarButtonItem alloc]initWithCustomView:categoryView];
    self.categoryItem = categoryItem;
    
//   设置区域Item
    DXHomeNaviBarItem *districtView = [DXHomeNaviBarItem homeNaviBarItemWithNorImgName:@"icon_district" hightImgName:@"icon_district_highlighted" title:self.districtModel.titleStr subTitle:self.districtModel.subTitleStr target:self action:@selector(districtItemClick) events:UIControlEventTouchUpInside];
    UIBarButtonItem *districtItem = [[UIBarButtonItem alloc]initWithCustomView:districtView];
      self.districtItem = districtItem;
    
//   设置排序Item
    DXHomeNaviBarItem *sortView = [DXHomeNaviBarItem homeNaviBarItemWithNorImgName:@"icon_sort" hightImgName:@"icon_sort_highlighted" title:self.sortModel.titleStr subTitle:self.sortModel.subTitleStr target:self action:@selector(sortItemClick) events:UIControlEventTouchUpInside];
    UIBarButtonItem *sortItem = [[UIBarButtonItem alloc]initWithCustomView:sortView];
     self.sortItem = sortItem;
    
    self.navigationItem.leftBarButtonItems = @[logoItem,categoryItem,districtItem,sortItem];
    
}





#pragma mark -按钮响应事件
//地图barItem点击
- (void)mapBarButtonClick{

      NSLog(@"mapBarButtonClick");
}

//搜索barItem点击
- (void)searchBarButtonClick{
        NSLog(@"searchBarButtonClick");
}

//分类Item点击
- (void)categoryItemClick{
        NSLog(@"categoryItemClick");
    
 [DXHomeNetTool loadHomeCategoriesComplete:^{
     
 } sucess:^(NSArray *result) {
//     NSLog(@"%@",result);
     DXDropViewController *dropVc = [DXDropViewController dropViewController];
     dropVc.isCategories = YES;
     dropVc.leftCategoriesArrayData = result;
     UIPopoverController *popVc = [[UIPopoverController alloc]initWithContentViewController:dropVc];
     [popVc presentPopoverFromBarButtonItem:self.categoryItem permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
 } failureBlock:nil];
    

}

//区域Item点击
- (void)districtItemClick{
        NSLog(@"districtItemClick");
    DXDistrictDropViewController *distDropVc = [[DXDistrictDropViewController alloc]initWithCityId:self.cityModel.mas_id];//[DXDistrictDropViewController dropViewController];
//    distDropVc.cityId =self.cityModel.mas_id;
    UIPopoverController *popVc = [[UIPopoverController alloc]initWithContentViewController:distDropVc];
    [popVc presentPopoverFromBarButtonItem:self.districtItem permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];

}

//排序Item点击
- (void)sortItemClick{
    NSLog(@"sortItemClick");

    DXSortController *sortDropVc = [DXSortController new];
    UIPopoverController *popVc = [[UIPopoverController alloc]initWithContentViewController:sortDropVc];
    [popVc presentPopoverFromBarButtonItem:self.sortItem permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
}


- (void)homeCateControllerNoticicaton:(NSNotification *)notification
{
    
    DXDropNotificationModel *model = notification.userInfo[KHomeCateControllerNoticicatonCatInfo];
    DXHomeNaviBarItem *cateView = self.categoryItem.customView;
    cateView.titleString = model.titleStr;
    cateView.subTitleString = model.subTitleStr;
    self.catModel = model;
    [self loadNewData];
    [DXUserDefaults setObject:model.keyValues forKey:KHomeUserCatInfoKey];
   
}
- (void)homeDistControllerNoticicaton:(NSNotification *)notification
{
    DXDropNotificationModel *model = notification.userInfo[KHomeDistControllerNoticicatonDistInfo];
    
    DXHomeNaviBarItem *districtView = self.districtItem.customView;
    districtView.titleString = model.titleStr;
     districtView.subTitleString = model.subTitleStr;
    self.districtModel = model;
    [self loadNewData];
    [DXUserDefaults setObject:model.keyValues forKey:KHomeUserDistrictInfoKey];
    
    
}
- (void)homeSortControllerNoticicaton:(NSNotification *)notification
{
    DXDropNotificationModel *model = notification.userInfo[KHomeSortControllerNoticicatonSort];
    
    DXHomeNaviBarItem *sortView = self.sortItem.customView;
    sortView.titleString = model.titleStr;
    sortView.subTitleString = model.subTitleStr;
    self.sortModel = model;
    [self loadNewData];
    [DXUserDefaults setObject:model.keyValues forKey:KHomeUserSortInfoKey];
}

- (void)homeChangeCityControllerNoticicaton:(NSNotification *)notification
{
    DXDropNotificationModel *model = notification.userInfo[KHomeChangeCityControllerNoticicatonInfo];
    DXHomeNaviBarItem *districtView = self.districtItem.customView;
    districtView.titleString = model.titleStr;
    districtView.subTitleString = model.subTitleStr;
    self.cityModel = model;
    [self loadNewData];
    [DXUserDefaults setObject:model.keyValues forKey:KHomeUserCityInfoKey];
}

- (void)dealloc
{
    [DXNotificationCenter removeObserver:self];

}



























@end
