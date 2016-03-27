//
//  DXSortController.m
//  TuanGou
//
//  Created by simon on 16/3/27.
//  Copyright © 2016年 simon. All rights reserved.
//

#import "DXSortController.h"
#import "DXSortModel.h"
#import "DXDropLeftCell.h"
#import "DXDropNotificationModel.h"
@interface DXSortController ()
@property (nonatomic, strong) NSMutableArray *dataArray;
@end

@implementation DXSortController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.dataArray = [DXSortModel objectArrayWithFilename:@"sorts.plist"];
    self.preferredContentSize = CGSizeMake(KHomepopViewContentWith *0.3, 44 * self.dataArray.count);

}


#pragma mark - Table view data source


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.dataArray.count;
}

//返回cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    DXDropLeftCell *cell = [DXDropLeftCell leftDropCellWith:tableView];
    DXSortModel *sortModel =  self.dataArray[indexPath.row];
    cell.nameStr = sortModel.label;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    DXSortModel *sortModel =  self.dataArray[indexPath.row];
    DXDropNotificationModel *notiModel = [DXDropNotificationModel new];
    notiModel.titleStr = sortModel.label;
    notiModel.subTitleStr = @"排序";
    notiModel.sub_id = sortModel.vaule;
    [DXNotificationCenter postNotificationName:KHomeSortControllerNoticicaton object:nil userInfo:@{KHomeSortControllerNoticicatonSort:notiModel}];

    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
