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
@interface DXHomeViewController ()
//分类Item
@property (nonatomic, strong) UIBarButtonItem *categoryItem;
//区域Item
@property (nonatomic, strong) UIBarButtonItem *sortItem;

//排序Item
@property (nonatomic, strong) UIBarButtonItem *districtItem;

@property (nonatomic, strong) DXDropNotificationModel *catModel;

@property (nonatomic, strong) DXDropNotificationModel *districtModel;

@property (nonatomic, strong) DXDropNotificationModel *sortModel;

@property (nonatomic, strong) DXDropNotificationModel *cityModel;

@end

@implementation DXHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self getUserInfoData];
    [self setUpNavibar];
    [self addNoticicatons];
//    NSLog(@"%@", DXApplication.documentsPath);

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
   NSDictionary *catDict = [DXUserDefaults objectForKey:KHomeUserCatInfoKey];
    if (catDict) {
           self.catModel = [DXDropNotificationModel objectWithKeyValues:catDict];
    }else{
        self.catModel = [DXDropNotificationModel new];
        self.catModel.titleStr = @"全部分类";
    }
    
    
    NSDictionary *districtDict = [DXUserDefaults objectForKey:KHomeUserDistrictInfoKey];
    if (catDict) {
        self.districtModel = [DXDropNotificationModel objectWithKeyValues:districtDict];
    }else{
        self.districtModel = [DXDropNotificationModel new];
        self.districtModel.titleStr = @"北京-全部";
        self.districtModel.mas_id = @(100010000);
        
    }
    
    
    NSDictionary *sortDict = [DXUserDefaults objectForKey:KHomeUserSortInfoKey];
    if (catDict) {
        self.sortModel = [DXDropNotificationModel objectWithKeyValues:sortDict];
    }else{
        self.sortModel = [DXDropNotificationModel new];
        self.sortModel.titleStr = @"默认排序";
        self.sortModel.subTitleStr = @"排序";
    }
    
    NSDictionary *cityDict = [DXUserDefaults objectForKey:KHomeUserCityInfoKey];
    if (cityDict) {
        self.cityModel = [DXDropNotificationModel objectWithKeyValues:cityDict];
    }else{
        self.cityModel = [DXDropNotificationModel new];
        self.cityModel.titleStr = @"北京市-全部";
        self.cityModel.mas_id = @100010000;
    }


}
//设置导航栏
- (void)setUpNavibar {
    [self setUpLeftItems];
    [self setUpRightItems];
    
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

#pragma mark -privateMetod



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
    DXDistrictDropViewController *distDropVc = [DXDistrictDropViewController dropViewController];
    distDropVc.cityId =self.cityModel.mas_id;
    UIPopoverController *popVc = [[UIPopoverController alloc]initWithContentViewController:distDropVc];
    [popVc presentPopoverFromBarButtonItem:self.districtItem permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];

}

//排序Item点击
- (void)sortItemClick{
    NSLog(@"sortItemClick");
    #import "DXSortController.h"
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
    
    [DXUserDefaults setObject:model.keyValues forKey:KHomeUserCatInfoKey];
   
}
- (void)homeDistControllerNoticicaton:(NSNotification *)notification
{
    DXDropNotificationModel *model = notification.userInfo[KHomeDistControllerNoticicatonDistInfo];
    
    DXHomeNaviBarItem *districtView = self.districtItem.customView;
    districtView.titleString = model.titleStr;
     districtView.subTitleString = model.subTitleStr;
    
    [DXUserDefaults setObject:model.keyValues forKey:KHomeUserDistrictInfoKey];
    
    
}
- (void)homeSortControllerNoticicaton:(NSNotification *)notification
{
    DXDropNotificationModel *model = notification.userInfo[KHomeSortControllerNoticicatonSort];
    
    DXHomeNaviBarItem *sortView = self.sortItem.customView;
    sortView.titleString = model.titleStr;
    sortView.subTitleString = model.subTitleStr;
    [DXUserDefaults setObject:model.keyValues forKey:KHomeUserSortInfoKey];
}


- (void)homeChangeCityControllerNoticicaton:(NSNotification *)notification
{
    DXDropNotificationModel *model = notification.userInfo[KHomeChangeCityControllerNoticicatonInfo];
    DXHomeNaviBarItem *districtView = self.districtItem.customView;
    districtView.titleString = model.titleStr;
    districtView.subTitleString = model.subTitleStr;

    [DXUserDefaults setObject:model.keyValues forKey:KHomeUserCityInfoKey];
}



- (void)dealloc
{
    [DXNotificationCenter removeObserver:self];

}



























@end
