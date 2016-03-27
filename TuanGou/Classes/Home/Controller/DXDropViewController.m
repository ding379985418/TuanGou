//
//  DXDropViewController.m
//  TuanGou
//
//  Created by simon on 16/3/26.
//  Copyright © 2016年 simon. All rights reserved.
//

#import "DXDropViewController.h"
#import "DXDropLeftCell.h"
#import "DXDropRightCell.h"
#import "DXDropCategoriesModel.h"
#import "DXDropCategoriesSubModel.h"
#import "DXDropDistrictsModel.h"
#import "DXDropDistrictsSubModel.h"
#import "DXDropNotificationModel.h"

@interface DXDropViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *lefeTableView;
@property (weak, nonatomic) IBOutlet UITableView *rightTableView;

///右边数据源
@property (nonatomic, strong) NSArray *rightArrayData;

@end

@implementation DXDropViewController

+ (instancetype)dropViewController
{
    return [[UIStoryboard storyboardWithName:@"DXDropViewController" bundle:nil] instantiateInitialViewController];
}

- (void)awakeFromNib{
//    self.view.autoresizingMask = UIViewAutoresizingNone;
    self.preferredContentSize =  CGSizeMake(KHomepopViewContentWith, KHomepopViewContentWith);
    self.lefeTableView.tableFooterView = [UIView new];
    self.rightTableView.tableFooterView = [UIView new];
    self.lefeTableView.showsVerticalScrollIndicator = NO;
    self.rightTableView.showsVerticalScrollIndicator = NO;
    self.lefeTableView.backgroundColor = [UIColor colorWithR:245 G:245 B:245];
    self.rightTableView.backgroundColor = [UIColor colorWithR:245 G:245 B:245];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpData];
 
}

#pragma mark -privaMetod

//初始化数据
- (void)setUpData {
 
}

#pragma mark -setterMetod
- (void)setLeftCategoriesArrayData:(NSArray *)leftCategoriesArrayData{
    _leftCategoriesArrayData = leftCategoriesArrayData;
     [self.lefeTableView reloadData];
}
- (void)setLeftDistrictArrayData:(NSArray *)leftDistrictArrayData{

    _leftDistrictArrayData = leftDistrictArrayData;
     [self.lefeTableView reloadData];

}

- (void)setRightArrayData:(NSArray *)rightArrayData
{
    _rightArrayData = rightArrayData;
    [self.rightTableView reloadData];

}

#pragma mark -UITableViewDataSource
//返回row
- (NSInteger )tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_isCategories) {
     return tableView == self.lefeTableView?self.leftCategoriesArrayData.count:self.rightArrayData.count;
    }else{
     return tableView == self.lefeTableView?self.leftDistrictArrayData.count:self.rightArrayData.count;
    }
 
}
//返回cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
   
//    左边cell
    if (tableView == self.lefeTableView) {
        DXDropLeftCell *cell = [DXDropLeftCell leftDropCellWith:tableView];
        if (_isCategories) {
            DXDropCategoriesModel *model = self.leftCategoriesArrayData[indexPath.row];
            cell.accessoryType = model.subcategories.count?UITableViewCellAccessoryDisclosureIndicator:UITableViewCellAccessoryNone;
            cell.nameStr = model.cat_name;
        }else{
            DXDropDistrictsModel *districtModel = self.leftDistrictArrayData[indexPath.row];
             cell.accessoryType = districtModel.biz_areas.count?UITableViewCellAccessoryDisclosureIndicator:UITableViewCellAccessoryNone;
              cell.nameStr = districtModel.district_name;
        
        }
        
        return cell;

    }else{
//        右边cell
        DXDropRightCell *cell = [DXDropRightCell leftDropCellWith:tableView];
        if (_isCategories) {
        DXDropCategoriesSubModel *subModel =  self.rightArrayData[indexPath.row];
        cell.nameStr = subModel.subcat_name;
        }else{
            DXDropDistrictsSubModel *districtSubModel = self.rightArrayData[indexPath.row];
            cell.nameStr = districtSubModel.biz_area_name;
        }
        return cell;
    
    }

}

#pragma mark -UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.lefeTableView) {//左边点击
        if (_isCategories) {//分类
            DXDropCategoriesModel *model = self.leftCategoriesArrayData[indexPath.row];
            self.rightArrayData = model.subcategories;
            
            
        }else{//区域
        DXDropDistrictsModel *districtModel = self.leftDistrictArrayData[indexPath.row];
        self.rightArrayData = districtModel.biz_areas;
        }

        [self.rightTableView reloadData];
        
    }else{//右边点击
        DXDropNotificationModel *notiModel = [DXDropNotificationModel new];
    NSIndexPath *leftIndxPath = [self.lefeTableView indexPathForSelectedRow];
     if (_isCategories) {//分类
         
         DXDropCategoriesModel *Catmodel = self.leftCategoriesArrayData[leftIndxPath.row];
          DXDropCategoriesSubModel *model = self.rightArrayData[indexPath.row];
         notiModel.titleStr = Catmodel.cat_name;
         notiModel.mas_id = Catmodel.cat_id;
         notiModel.subTitleStr = model.subcat_name;
         notiModel.sub_id = model.subcat_id;
         [DXNotificationCenter postNotificationName:KHomeCateControllerNoticicaton object:nil userInfo:@{KHomeCateControllerNoticicatonCatInfo:notiModel}];
         
         
     }else{//区域
      DXDropDistrictsModel *districtModel = self.leftDistrictArrayData[leftIndxPath.row];
         
     DXDropDistrictsSubModel *model = self.rightArrayData[indexPath.row];
         notiModel.titleStr = districtModel.district_name;
          notiModel.mas_id = districtModel.district_id;
         notiModel.subTitleStr = model.biz_area_name;
         notiModel.sub_id = model.biz_area_id;

       [DXNotificationCenter postNotificationName:KHomeDistControllerNoticicaton object:nil userInfo:@{KHomeDistControllerNoticicatonDistInfo:notiModel}];
         
     
     }
        [self dismissViewControllerAnimated:YES completion:nil];
        
  }
}

@end
