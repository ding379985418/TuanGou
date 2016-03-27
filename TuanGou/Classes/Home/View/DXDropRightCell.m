//
//  DXDropRightCell.m
//  TuanGou
//
//  Created by simon on 16/3/26.
//  Copyright © 2016年 simon. All rights reserved.
//

#import "DXDropRightCell.h"

@implementation DXDropRightCell

+ (instancetype )leftDropCellWith:(UITableView *)tableView
{
    static NSString *cellIdentifier = @"rightCellIdentifier";
    DXDropRightCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[DXDropRightCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.selectedBackgroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"bg_dropdown_right_selected"]];
        cell.backgroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"bg_dropdown_rightpart"]];
    }
    return cell;
    
}
- (void)setNameStr:(NSString *)nameStr{
    _nameStr = nameStr;
    self.textLabel.text = nameStr;
}
@end
