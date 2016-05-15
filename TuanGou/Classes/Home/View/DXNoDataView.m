//
//  DXNoDataView.m
//  TuanGou
//
//  Created by simon on 16/5/13.
//  Copyright © 2016年 simon. All rights reserved.
//

#import "DXNoDataView.h"

@implementation DXNoDataView


+ (void)ShowNoDataViewWithType:(DXNoDataViewType)type toView:(UIView *)toview
{
    NSString *imgeStr = @"";
    switch (type) {
        case DXNoDataViewType_NetError:
            imgeStr = @"bg_rotNetwork";
            break;
        case DXNoDataViewType_Order_empty:
            imgeStr = @"ic_order_empty";
            break;
        case DXNoDataViewType_Cinemas_empty:
            imgeStr = @"icon_cinemas_empty";
            break;
        case DXNoDataViewType_Collects_empty:
            imgeStr = @"icon_collects_empty";
            break;
        case DXNoDataViewType_Deals_empty:
            imgeStr = @"icon_deals_empty";
            break;
        case DXNoDataViewType_LatestBrowse_empty:
            imgeStr = @"icon_latestBrowse_empty";
            break;
        case DXNoDataViewType_Map_search_empty:
            imgeStr = @"icon_map_search_empty";
            break;
        default:
            break;
    }
    
   
    BOOL hasNoDataView = NO;
    for (UIView *subView in toview.subviews) {
        if ([subView isKindOfClass:[DXNoDataView class]]) {
            hasNoDataView = YES;
            subView.center = toview.center;
        }
    }
    if (hasNoDataView == NO) {
         DXNoDataView *noDataView = [[DXNoDataView alloc]initWithImage:[UIImage imageNamed:imgeStr]];
        [toview addSubview:noDataView];
        noDataView.center = toview.center;
    }

}

+ (void)hiddenNoDataViewFromView:(UIView *)view{
    
    NSEnumerator *subviewsEnum = [view.subviews reverseObjectEnumerator];
    
    for (UIView *subView in subviewsEnum) {
        if ([subView isKindOfClass:self]) {
            subView.alpha = 0;
            [subView removeFromSuperview];
        }
    }
}

- (instancetype)initWithImage:(UIImage *)image{
    self = [super initWithImage:image];
    [DXNotificationCenter addObserver:self selector:@selector(orientChange:) name:KScreenWillChangeNoticicaton object:nil];
    return self;
}

- (void)orientChange:(NSNotification *)noti{
    NSDictionary *dic = noti.userInfo;
    CGSize size = [dic[KScreenWillChangeNoticicatonSize] CGSizeValue];
    NSLog(@"%@",NSStringFromCGSize(size));
    self.centerX = size.width * 0.5;
    self.centerY = size.height * 0.5;
}
@end
