//
//  DXDealModel.h
//  TuanGou
//
//  Created by simon on 16/5/13.
//  Copyright © 2016年 simon. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DXDealModel : NSObject
///商品id
@property (nonatomic, strong) NSNumber *deal_id;
///图片
@property (nonatomic, copy) NSString *image;
///缩略图片
@property (nonatomic, copy) NSString *tiny_image;
///标题
@property (nonatomic, copy) NSString *title;
///描述
@property (nonatomic, copy) NSString *descriptions;
///团单原价，单位分
@property (nonatomic, strong) NSNumber *market_price;
///团购价格,单位分
@property (nonatomic, strong) NSNumber *current_price;
///团单的促销价格，如果没有促销，价格是当前的团购价格，单位分
@property (nonatomic, strong) NSNumber *promotion_price;
///已售多少份
@property (nonatomic, strong) NSNumber *sale_num;
///评分
@property (nonatomic, strong) NSNumber *score;
///评论数
@property (nonatomic, strong) NSNumber *comment_num;
///团单发布时间
@property (nonatomic, strong) NSNumber *publish_time;
///团单购买的最后期限
@property (nonatomic, strong) NSNumber *purchase_deadline;
///移动端详情页
@property (nonatomic, copy) NSString *deal_url;
///商家
@property (nonatomic, strong) NSArray *shops;
///cell是否处在编辑状态
@property (nonatomic, assign) BOOL isEditing;
///是否被选中
@property (nonatomic, assign) BOOL isSelected;
@end
