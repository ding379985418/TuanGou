//
//  DXDropLeftCell.h
//  TuanGou
//
//  Created by simon on 16/3/26.
//  Copyright © 2016年 simon. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DXDropLeftCell : UITableViewCell
@property (nonatomic, copy) NSString *nameStr;
+ (instancetype )leftDropCellWith:(UITableView *)tableView;
@end
