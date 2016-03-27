//
//  DXNaviVigationController.m
//  TuanGou
//
//  Created by simon on 16/3/26.
//  Copyright © 2016年 simon. All rights reserved.
//

#import "DXNaviVigationController.h"

@interface DXNaviVigationController ()

@end

@implementation DXNaviVigationController

//一次性设置
+ (void)initialize{

    UINavigationBar *naviBar = [UINavigationBar appearance];
//    naviBar.backgroundColor = [UIColor blueColor];
    naviBar.translucent = NO;
    
    [naviBar setBackgroundImage:[UIImage imageNamed:@"bg_navigationBar_normal"] forBarMetrics:UIBarMetricsDefault];
}

- (void)viewDidLoad{
    [super viewDidLoad];
    

}


@end
