//
//  DXSearchController.m
//  TuanGou
//
//  Created by simon on 16/5/15.
//  Copyright © 2016年 simon. All rights reserved.
//

#import "DXSearchController.h"
#import "DXHomeCollectionView.h"
#import "DXHomeViewModel.h"
#import "DXHomeRequestModel.h"
#import "DXDealModel.h"
#import "DXDealDetailController.h"

@interface DXSearchController ()<UISearchBarDelegate>
@property (nonatomic, strong) DXHomeCollectionView *resultCollectionView;
@property (nonatomic, strong) NSMutableArray *resultArray;

@property (nonatomic, strong) UISearchBar *searchBar;

@property (nonatomic, assign) NSInteger page;
@end

@implementation DXSearchController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUp];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [DXNotificationCenter postNotificationName:KScreenWillChangeNoticicaton object:nil
                                      userInfo:@{KScreenWillChangeNoticicatonSize:[NSValue valueWithCGSize:self.view.size]}];
}
#pragma mark -初始化UI
- (void)setUp{
    [self setUpSearchNaviBar];
    [self showNoData];
    self.page = 1;
    [DXNotificationCenter addObserver:self
                             selector:@selector(collectionViewCellClick:)
                                 name:KHomeCollectionCellClickNoticicaton
                               object:nil];
}
#pragma mark -点击通知
- (void)collectionViewCellClick:(NSNotification *)noti {
    DXDealModel *dealModel =
    noti.userInfo[KHomeCollectionCellClickNoticicatonKey];
    if (dealModel.isEditing) {
        return;
    }
    DXDealDetailController *dealDetailVc =
    [[DXDealDetailController alloc] initDetailControllerWith:dealModel];
    
    dealDetailVc.dealModel = dealModel;
    
    [self presentViewController:dealDetailVc animated:YES completion:nil];
    NSLog(@"----%@", dealModel.title);
}

#pragma mark -显示结果
- (void)showResult{
    [self.view endEditing:YES];
    if (self.resultArray.count==0) {
        ToastMessage(@"没有搜索到条件的团购");
        return;
    }
    [DXNoDataView hiddenNoDataViewFromView:self.view];
    self.resultCollectionView.dataArray = [self.resultArray copy];
    self.resultCollectionView.hidden = NO;

}
#pragma mark -显示无数据
- (void)showNoData{
    [self.view endEditing:YES];
    [DXNoDataView ShowNoDataViewWithType:DXNoDataViewType_Deals_empty toView:self.view];
    self.resultCollectionView.hidden = YES;
    [self.resultArray removeAllObjects];
    self.resultCollectionView.dataArray = [self.resultArray copy];
}
#pragma mark -设置搜索bar
- (void)setUpSearchNaviBar
{
    UISearchBar *searchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0, 0, KScreenWith - 300, 44)];
    self.searchBar = searchBar;
//    searchBar.tintColor = [UIColor greenColor];
    searchBar.placeholder = @"请输入搜索的内容";
    [searchBar setBackgroundColor:[UIColor clearColor]];
    searchBar.delegate = self;
    searchBar.showsCancelButton = YES;
    for (UIView *subView in searchBar.subviews[0].subviews) {
        if ([subView isKindOfClass:[UIButton class]]) {
            UIButton *btn = (UIButton *)subView;
            [btn setTitle:@"取消" forState:UIControlStateNormal];
        }
    }
    self.navigationItem.titleView = searchBar;
}
#pragma mark -请求数据
- (void)loadDataComplete:(void(^)())completeBlock
                  sucess:(void(^)(NSArray *result))sucessBlock failure:(void(^)())failureBlock
{
    DXHomeRequestModel *model = [DXHomeRequestModel new];
    DXHomeViewModel *viewModel = [DXHomeViewModel new];
    model.cityModel = viewModel.cityModel;
    //    model.catModel = viewModel.catModel;
    //    model.districtModel = viewModel.districtModel;
    //    model.sortModel = viewModel.sortModel;
    model.keyWord = self.searchBar.text;
    [DXHomeViewModel loadHomeDealsWithRequestModel:model page:@(self.page) complete:^{
        DXHiddenProgressingHUD;
        if (completeBlock) {
            completeBlock();
        }
    } sucess:^(NSArray *result) {
        if (sucessBlock) {
            sucessBlock(result);
        }
    } failureBlock:^(NSString *errorStr) {
        ToastMessage(@"网络错误,请检查网络");
        if (failureBlock) {
            failureBlock();
        }
    }];


}


- (void)loadMoreData
{
    self.page++;
    [self loadDataComplete:^{
        [self.resultCollectionView.footer endRefreshing];
    } sucess:^(NSArray *result) {
        if (result.count > 0) {
            [self.resultArray addObjectsFromArray:result];
            self.resultCollectionView.dataArray = [self.resultArray copy];
        }
    } failure:^{
        NSInteger tempPage = self.page;
        if (tempPage --) {
            self.page --;
        }
    }];

}

- (void)loadNewData
{
    self.page = 1;
    [self loadDataComplete:nil sucess:^(NSArray *result) {
        NSMutableArray *temp = [NSMutableArray arrayWithArray:result];
        self.resultArray = temp;
        [self showResult];
    } failure:nil];

}

#pragma mark -UISearchBarDelegate
//开始编辑  清空原来数组数据,隐藏taleview
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{

}
//结束编辑
- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{

}
//搜索内容变化,当为空是
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{

}
//搜索关键字
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    if (searchBar.text.length <=0 || [searchBar.text isEqualToString:@" "]) {
        ToastMessage(@"请输入正确的关键字搜索");
        return;
    }
    [self loadNewData];
    DXShowProgressingHUD;
   }
//取消,
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [self showNoData];
}
#pragma mark -懒加载
- (DXHomeCollectionView *)resultCollectionView
{
    if (!_resultCollectionView) {
        _resultCollectionView = [[DXHomeCollectionView alloc]initWithCustomFrame:self.view.bounds];
        _resultCollectionView.hidden = YES;
        [self.view addSubview:_resultCollectionView];
        DXWeakSelf;
        [_resultCollectionView addLegendFooterWithRefreshingBlock:^{
            [weakSelf loadMoreData];
        }];
    }
    return _resultCollectionView;
}

- (NSMutableArray *)resultArray
{
    if (!_resultArray) {
        _resultArray = [NSMutableArray array];
    }
    return _resultArray;
}
- (void)dealloc{
    [DXNotificationCenter removeObserver:self];
    
}

@end
