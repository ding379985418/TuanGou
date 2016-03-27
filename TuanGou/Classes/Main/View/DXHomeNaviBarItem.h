//
//  DXHomeNaviBarItem.h
//  TuanGou
//
//  Created by simon on 16/3/26.
//  Copyright © 2016年 simon. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DXHomeNaviBarItem : UIView
//主标题字符串
@property (nonatomic, copy) NSString *titleString;
//副标题字符串
@property (nonatomic, copy) NSString *subTitleString;

///初始化barItem
+ (instancetype)homeNaviBarItem;

///快速创建ItemView
+ (instancetype)homeNaviBarItemWithNorImgName:(NSString *)imgName
                             hightImgName:(NSString *)hightImgName
                                    title:(NSString *)title
                                 subTitle:(NSString *)subTitle
                                   target:(id)target
                                   action:(SEL)action
                                   events:(UIControlEvents)controlEvents;

///设置子标题
- (void)setSubTitleStr:(NSString *)subTitleStr;

///设置主标题
- (void)setTitleStr:(NSString *)titleStr;

///添加点击事件
- (void)addTarget:(id)target
            action:(SEL)action
  forControlEvents:(UIControlEvents)controlEvents;

///设置图标
- (void)setNormalImag:(NSString *)normalImagStr hightLightImag:(NSString *) hightImagStr;

@end
