//
//  DXNoDataView.h
//  TuanGou
//
//  Created by simon on 16/5/13.
//  Copyright © 2016年 simon. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSUInteger, DXNoDataViewType) {
    DXNoDataViewType_NetError,//网络错误
    DXNoDataViewType_Order_empty,//订单为空
    DXNoDataViewType_Cinemas_empty,//电影院为空
    DXNoDataViewType_Collects_empty,//收藏为空
    DXNoDataViewType_Deals_empty,//没有符合条件的团购
    DXNoDataViewType_LatestBrowse_empty,//最近浏览为空
    DXNoDataViewType_Map_search_empty//搜索结果为空
};
@interface DXNoDataView : UIImageView
///显示无数据视图
+ (void)ShowNoDataViewWithType:(DXNoDataViewType)type toView:(UIView *)view;
///隐藏无数据 视图
+ (void)hiddenNoDataViewFromView:(UIView *)view;
@end
