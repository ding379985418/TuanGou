//
//  DXChangeCityController.m
//  TuanGou
//
//  Created by simon on 16/3/27.
//  Copyright © 2016年 simon. All rights reserved.
//

#import "DXChangeCityController.h"
#import "DXCityModel.h"
#import "DXHomeNetTool.h"
#import "DXCitySearchResultController.h"
#import "DXDropLeftCell.h"
#import "DXDropNotificationModel.h"
@interface DXChangeCityController ()<UISearchBarDelegate,UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UISearchBar *serarBar;

@property (nonatomic, strong) NSArray *citiesArray;
@property (nonatomic, strong) UIButton *coverButton;
@property (nonatomic, strong) DXCitySearchResultController *searchResultVc;

@property (nonatomic, strong) NSMutableArray *resultArray;


@end

@implementation DXChangeCityController
+ (DXNaviVigationController *)changeCityController
{

    DXChangeCityController *changCityVc = [[UIStoryboard storyboardWithName:@"DXChangeCityController" bundle:nil] instantiateInitialViewController];
    DXNaviVigationController *naVc = [[DXNaviVigationController alloc]initWithRootViewController:changCityVc];
    
    return naVc;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [DXNotificationCenter addObserver:self selector:@selector(changeCityControllerNoticicaton) name:KHomeChangeCityControllerNoticicaton object:nil];
//    请求数据
    [DXHomeNetTool loadHomeCitiesComplete:nil sucess:^(NSArray *result) {
        self.citiesArray = result;
        [self.tableView reloadData];
    } failureBlock:nil];
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem barButtonItemWithName:@"" imageNameNor:@"btn_navigation_close" imageNameHig:@"btn_navigation_close_hl" addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
    self.serarBar.tintColor = KDefaultColor;
    self.coverButton.hidden = YES;

    
    

}

- (void)awakeFromNib {
    self.title = @"切换城市";

}
- (void)dealloc
{
    [DXNotificationCenter removeObserver:self];

}
#pragma mark -prviaMetod
- (void)changeCityControllerNoticicaton{
    [self dismissViewControllerAnimated:YES completion:nil];

}
- (void)searCityWithKeyWord:(NSString *)keyWord
{
    [self.resultArray removeAllObjects];
    [self.citiesArray enumerateObjectsUsingBlock:^(DXCityModel *cityModel, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if ([cityModel.city_name localizedCaseInsensitiveContainsString:keyWord ]||[cityModel.short_name localizedCaseInsensitiveContainsString:keyWord]||[cityModel.city_pinyin localizedCaseInsensitiveContainsString:keyWord]||[cityModel.short_pinyin localizedCaseInsensitiveContainsString:keyWord]) {
//            NSLog(@"%@",cityModel.city_name);
            [self.resultArray addObject:cityModel];
        }
    }];
}

#pragma mark -点击事件
- (void)coverButtonClick{
    [self searchBarTextDidEndEditing:self.serarBar];
    

}
- (void)backClick{
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark -UISearchBarDelegate
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    self.serarBar.backgroundImage = [UIImage imageNamed:@"bg_login_textfield_hl"];
    NSLog(@"BarTextDidBeginEditing");
    self.navigationController.navigationBarHidden = YES;
    searchBar.showsCancelButton = YES;
    self.coverButton.hidden = NO;
    self.coverButton.alpha = 0.5;
    self.searchResultVc.tableView.hidden = YES;
    for (UIView *subView in self.serarBar.subviews[0].subviews) {
        if ([subView isKindOfClass:[UIButton class]]) {
            UIButton *btn = (UIButton *)subView;
            [btn setTitle:@"取消" forState:UIControlStateNormal];
        }
        
    }

}
- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar{
    NSLog(@"DidEndEditing");
    self.serarBar.backgroundImage = [UIImage imageNamed:@"bg_login_textfield"];
    NSLog(@"BarTextDidBeginEditing");
     self.navigationController.navigationBarHidden = NO;
     searchBar.showsCancelButton = NO;
      self.coverButton.hidden = YES;
     self.searchResultVc.tableView.hidden = NO;
    self.serarBar.text = @"";
    [self.resultArray removeAllObjects];
    self.searchResultVc.resultArray = self.resultArray;
    [self.view endEditing:YES];

}
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    [self searCityWithKeyWord:searchText];
    if (searchBar.text.length == 0||self.resultArray.count == 0) {
        [self.resultArray removeAllObjects];
    
        self.coverButton.alpha = 0.5;
        self.searchResultVc.tableView.hidden = YES;
    }else{
        self.coverButton.alpha = 1;
        self.searchResultVc.tableView.hidden = NO;
    
    }
    self.searchResultVc.resultArray = self.resultArray;

     NSLog(@"textDidChange");

}
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
  NSLog(@"CancelButtonClicked");
    
    [self searchBarTextDidEndEditing:self.serarBar];
    
}

#pragma mark -UITableViewDataSource

//返回row
- (NSInteger )tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.citiesArray.count;
}
//返回cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    static NSString *cellIdentifier = @"cellIdentifier";
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
//    if (!cell) {
//        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
//    }
    DXCityModel *model = self.citiesArray[indexPath.row];
//    cell.textLabel.text = model.city_name;
    DXDropLeftCell *cell = [DXDropLeftCell leftDropCellWith:tableView];
    cell.nameStr = model.city_name;
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    DXCityModel *model = self.citiesArray[indexPath.row];
    DXDropNotificationModel *notiModel = [DXDropNotificationModel new];
    notiModel.titleStr = [NSString stringWithFormat:@"%@-全部",model.city_name];;
    notiModel.mas_id = model.city_id;
    [DXNotificationCenter postNotificationName:KHomeChangeCityControllerNoticicaton object:nil userInfo:@{KHomeChangeCityControllerNoticicatonInfo:notiModel}];
}

#pragma mark -懒加载
- (UIButton *)coverButton
{
    if (!_coverButton) {
        _coverButton = [[UIButton alloc]init];
        _coverButton.backgroundColor = [UIColor blackColor];
        _coverButton.alpha = 0.5;
        [_coverButton addTarget:self action:@selector(coverButtonClick) forControlEvents:UIControlEventTouchUpInside];
       
        [self.view addSubview:_coverButton];
        [_coverButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.tableView);
        }];
    }

    return _coverButton;
}

- (DXCitySearchResultController *)searchResultVc{

    if (!_searchResultVc) {
        _searchResultVc = [[DXCitySearchResultController alloc]init];
        _searchResultVc.tableView.frame = self.coverButton.bounds;
        [self.coverButton addSubview:_searchResultVc.tableView];
    }
    
    return _searchResultVc;
}

- (NSMutableArray *)resultArray{

    if (!_resultArray) {
        _resultArray = [NSMutableArray array];
    }
    return _resultArray;
}

@end
