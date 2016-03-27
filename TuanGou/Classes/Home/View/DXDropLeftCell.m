//
//  DXDropLeftCell.m
//  TuanGou
//
//  Created by simon on 16/3/26.
//  Copyright © 2016年 simon. All rights reserved.
//

#import "DXDropLeftCell.h"

@implementation DXDropLeftCell

+ (instancetype )leftDropCellWith:(UITableView *)tableView
{
    static NSString *cellIdentifier = @"leftCellIdentifier";
    DXDropLeftCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[DXDropLeftCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    cell.selectedBackgroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"bg_dropdown_left_selected"]];
    cell.backgroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"bg_dropdown_leftpart"]];
    return cell;

}
- (void)setNameStr:(NSString *)nameStr{
    _nameStr = nameStr;
    self.textLabel.text = nameStr;
}

@end
