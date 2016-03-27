//
//  DXHomeNaviBarItem.m
//  TuanGou
//
//  Created by simon on 16/3/26.
//  Copyright © 2016年 simon. All rights reserved.
//

#import "DXHomeNaviBarItem.h"
@interface DXHomeNaviBarItem ()
@property (weak, nonatomic) IBOutlet UILabel *subTitle;
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UIButton *button;


@end

@implementation DXHomeNaviBarItem

- (void)awakeFromNib{
    self.autoresizingMask = UIViewAutoresizingNone;


}
//从XIB中加载视图
+ (instancetype)homeNaviBarItem{

    return [[NSBundle mainBundle]loadNibNamed:@"DXHomeNaviBarItem" owner:nil options:nil].lastObject;
}

//快速创建ItemView
+ (instancetype)homeNaviBarItemWithNorImgName:(NSString *)imgName
                         hightImgName:(NSString *)hightImgName
                                title:(NSString *)title
                             subTitle:(NSString *)subTitle
                               target:(id)target
                               action:(SEL)action
                               events:(UIControlEvents)controlEvents
{
    //   设置ItemView
    DXHomeNaviBarItem *barItemView = [self homeNaviBarItem];
    [barItemView setNormalImag:imgName hightLightImag:hightImgName];
    barItemView.titleString = title;
    barItemView.subTitleString = subTitle;
    [barItemView addTarget:target action:action forControlEvents:controlEvents];
    return barItemView;
}


//设置子标题
- (void)setSubTitleStr:(NSString *)subTitleStr{
    self.subTitle.text = subTitleStr;

}
//设置主标题
- (void)setTitleStr:(NSString *)titleStr{
    self.title.text = titleStr;
    
}

//添加点击事件
- (void)addTarget:(id)target
           action:(SEL)action
 forControlEvents:(UIControlEvents)controlEvents
{
    [self.button addTarget:target action:action forControlEvents:controlEvents];

}

//设置图标
- (void)setNormalImag:(NSString *)normalImagStr hightLightImag:(NSString *) hightImagStr
{

    if (normalImagStr) {
        [self.button setImage:[UIImage imageNamed:normalImagStr] forState:UIControlStateNormal];
    }
    if (hightImagStr) {
        [self.button setImage:[UIImage imageNamed:hightImagStr] forState:UIControlStateHighlighted];
    }
}
//set方法
- (void)setTitleString:(NSString *)titleString{
    [self setTitleStr:titleString];

}
- (void)setSubTitleString:(NSString *)subTitleString{
    [self setSubTitleStr:subTitleString];

}
//get方法
- (NSString *)titleString{

    return self.title.text;
}
- (NSString *)subTitleString
{
    return self.subTitle.text;
}
@end
