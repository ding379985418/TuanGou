//
//  DXCitySearchResultController.m
//  TuanGou
//
//  Created by simon on 16/3/27.
//  Copyright © 2016年 simon. All rights reserved.
//

#import "DXCitySearchResultController.h"
#import "DXDropLeftCell.h"
#import "DXCityModel.h"
#import "DXDropNotificationModel.h"
//static NSString *identifier = @"reuseIdentifier";
@interface DXCitySearchResultController ()

@end

@implementation DXCitySearchResultController

- (void)viewDidLoad {
    [super viewDidLoad];
//    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:identifier];
    self.tableView.tableFooterView = [UIView new];
//    self.view.autoresizingMask = UIViewAutoresizingNone;
    self.automaticallyAdjustsScrollViewInsets = NO;
}

- (void)setResultArray:(NSArray *)resultArray {
    _resultArray = resultArray;

    [self.tableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.resultArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
//    cell.textLabel.text = self.resultArray[indexPath.row];
    DXDropLeftCell *cell = [DXDropLeftCell leftDropCellWith:tableView];
    DXCityModel *model = self.resultArray[indexPath.row];
    cell.nameStr = model.city_name;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    DXCityModel *model = self.resultArray[indexPath.row];
    DXDropNotificationModel *notiModel = [DXDropNotificationModel new];
    notiModel.titleStr = [NSString stringWithFormat:@"%@-全部",model.city_name];
    notiModel.mas_id = model.city_id;
    [DXNotificationCenter postNotificationName:KHomeChangeCityControllerNoticicaton object:nil userInfo:@{KHomeChangeCityControllerNoticicatonInfo:notiModel}];
}

@end
