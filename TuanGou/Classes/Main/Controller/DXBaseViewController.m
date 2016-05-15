//
//  DXBaseViewController.m
//  TuanGou
//
//  Created by simon on 16/3/26.
//  Copyright © 2016年 simon. All rights reserved.
//

#import "DXBaseViewController.h"
#import "DXNaviVigationController.h"

@interface DXBaseViewController ()

@end

@implementation DXBaseViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpBaseUI];
    
}

- (void)setUpBaseUI {
    self.view.backgroundColor = KBGColor;
    DXApplication.keyWindow.backgroundColor = KBGColor;
    [self setBackItem];
   
}
- (void)setBackItem{
    
    UIBarButtonItem *backItem = [UIBarButtonItem barButtonItemWithName:@"返回" imageNameNor:@"icon_back" imageNameHig:@"icon_back_highlighted" addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = backItem;
    
}

- (void)back{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
