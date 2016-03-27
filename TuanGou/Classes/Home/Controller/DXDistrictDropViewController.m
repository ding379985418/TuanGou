//
//  DXDistrictDropViewController.m
//  TuanGou
//
//  Created by simon on 16/3/27.
//  Copyright © 2016年 simon. All rights reserved.
//

#import "DXDistrictDropViewController.h"
#import "DXDropViewController.h"
#import "DXHomeNetTool.h"
#import "DXNaviVigationController.h"
#import "DXChangeCityController.h"
#import "DXCityModel.h"
@interface DXDistrictDropViewController ()
@property (weak, nonatomic) IBOutlet UIButton *changeCityButton;
@property (weak, nonatomic) IBOutlet UIView *placeHolderView;

@property (nonatomic, strong) DXDropViewController *dropVc;


@end

@implementation DXDistrictDropViewController
//初始化
+ (instancetype)dropViewController
{
    
  DXDistrictDropViewController *vc = [[UIStoryboard storyboardWithName:@"DXDistrictDropViewController" bundle:nil] instantiateInitialViewController];
    
    
   

    
    return vc;

}

- (void)setCityId:(NSNumber *)cityId{

    _cityId = cityId;
    [DXHomeNetTool loadHomeDistrictsWith:cityId complete:nil sucess:^(NSArray *result) {
        self.dropVc.leftDistrictArrayData = result;
    } failureBlock:nil];

}
- (void)awakeFromNib{
    self.dropVc = [DXDropViewController dropViewController];
    self.dropVc.isCategories = NO;
    self.view.autoresizingMask = UIViewAutoresizingNone;
    self.preferredContentSize =  CGSizeMake(KHomepopViewContentWith, KHomepopViewContentWith);

}
- (void)viewDidLoad {
    [super viewDidLoad];
    [DXNotificationCenter addObserver:self selector:@selector(homeDistControllerNoticicaton:) name:KHomeDistControllerNoticicaton object:nil];
    self.dropVc.view.frame = self.placeHolderView.bounds;
    [self.placeHolderView addSubview:self.dropVc.view];
    
    

}
//点击切换城市
- (IBAction)changCity:(UIButton *)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
    DXNaviVigationController *changeCityVc = [DXChangeCityController changeCityController];
    changeCityVc.modalPresentationStyle = UIModalPresentationFormSheet;
    changeCityVc.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    
//    [self presentViewController:changeCityVc animated:YES completion:nil];
    [DXApplication.windows.lastObject.rootViewController presentViewController:changeCityVc animated:YES completion:nil];
    
    
    
}
- (void)homeDistControllerNoticicaton:(NSNotification *)notify
{

    [self dismissViewControllerAnimated:YES completion:nil];

}

- (void)dealloc{
    [DXNotificationCenter removeObserver:self];

}
@end
