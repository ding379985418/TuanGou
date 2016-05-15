//
//  DXHomeCollectionViewCell.m
//  TuanGou
//
//  Created by simon on 16/5/13.
//  Copyright © 2016年 simon. All rights reserved.
//

#import "DXHomeCollectionViewCell.h"
#import "DXDealModel.h"
@interface DXHomeCollectionViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *currentPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *orginalPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *saleNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *descripLabel;
@property (weak, nonatomic) IBOutlet UIImageView *dealImageView;
@property (weak, nonatomic) IBOutlet UIButton *selectedBtn;
@property (weak, nonatomic) IBOutlet UIButton *coverBtn;


@end
@implementation DXHomeCollectionViewCell

- (void)awakeFromNib {

   UIImageView *bgView = [[UIImageView alloc]initWithFrame:self.bounds];
    bgView.image = [UIImage imageNamed:@"bg_dealcell"];
    self.backgroundView = bgView;
    
}

- (void)setDealModel:(DXDealModel *)dealModel
{
    _dealModel = dealModel;
    self.titleLabel.text = dealModel.title;
    self.currentPriceLabel.text = [NSString stringWithFormat:@"¥%.2f",[dealModel.current_price floatValue]/100];
    self.descripLabel.text = dealModel.descriptions;
    self.orginalPriceLabel.text = [NSString stringWithFormat:@"¥%.2f",[dealModel.market_price floatValue]/100];
    NSString *saleText = [NSString stringWithFormat:@"已售 %@",dealModel.sale_num];
    self.saleNumberLabel.text = saleText;
    [self.dealImageView sd_setImageWithURL:[NSURL URLWithString:dealModel.image] placeholderImage:[UIImage imageNamed:@"placeholder_deal"]];
    
    if (dealModel.isEditing) {
        self.coverBtn.alpha = 0.5;
    }else{
        self.coverBtn.alpha = 0.1;
    }
    self.selectedBtn.selected = dealModel.isSelected;
    
}
- (IBAction)dealCellDidClick:(UIButton *)sender {
    
    if (self.dealModel.isEditing) {
        self.dealModel.isSelected = !self.dealModel.isSelected;
        self.dealModel = self.dealModel;
        [DXNotificationCenter postNotificationName:KHomeCollectionCellClickNoticicaton object:nil userInfo:@{KHomeCollectionCellClickNoticicatonKey:self.dealModel}];
        return;
    }
    [DXNotificationCenter postNotificationName:KHomeCollectionCellClickNoticicaton object:nil userInfo:@{KHomeCollectionCellClickNoticicatonKey:self.dealModel}];
//    NSLog(@"KHomeCollectionCellClickNoticicaton:--%@",self.dealModel.title);
}

@end
