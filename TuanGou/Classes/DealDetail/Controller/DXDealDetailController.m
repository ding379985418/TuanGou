//
//  DXDealDetailController.m
//  TuanGou
//
//  Created by simon on 16/5/13.
//  Copyright © 2016年 simon. All rights reserved.
//

#import "DXDealDetailController.h"
#import "DXDealModel.h"
#import "DXCollectTools.h"

@interface DXDealDetailController ()<UIWebViewDelegate>
///团购图片
@property (weak, nonatomic) IBOutlet UIImageView *dealImageView;
///团购标题
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
///现价
@property (weak, nonatomic) IBOutlet UILabel *currenPriceLabel;
///原价
@property (weak, nonatomic) IBOutlet UILabel *origalPriceLabel;
///团购描述
@property (weak, nonatomic) IBOutlet UILabel *descripLabel;
///收藏
@property (weak, nonatomic) IBOutlet UIButton *collectBtn;
///webView
@property (weak, nonatomic) IBOutlet UIWebView *detailWebView;

@property (weak, nonatomic) IBOutlet UIView *hiddenWebView;
@property (weak, nonatomic) IBOutlet UIButton *deadTime;
@property (weak, nonatomic) IBOutlet UIButton *saleNum;


@end

@implementation DXDealDetailController


- (instancetype)initDetailControllerWith:(DXDealModel *)dealModel{

   self = [[DXDealDetailController alloc]initWithNibName:@"DXDealDetailController" bundle:nil];
    self.dealModel = dealModel;
    return self;
}
- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{

    return UIInterfaceOrientationMaskLandscape;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = KBGColor;
    self.dealModel = self.dealModel;
    [self loadWebView];
    self.collectBtn.selected = [DXCollectTools hasCollectedDealWith:self.dealModel];
    
}

- (void)loadWebView
{
    self.detailWebView.backgroundColor = [UIColor whiteColor];
    self.detailWebView.scrollView.contentInset = UIEdgeInsetsMake(20, 0, 0, 0);
    self.hiddenWebView.hidden = NO;
    self.detailWebView.scrollView.bounces = NO;
    self.detailWebView.scrollView.showsHorizontalScrollIndicator = NO;
    self.detailWebView.scrollView.showsVerticalScrollIndicator = NO;
    self.detailWebView.scalesPageToFit = YES;


    NSURLRequest *quest = [NSURLRequest requestWithURL:[NSURL URLWithString:self.dealModel.deal_url]];
    [self.detailWebView loadRequest:quest];


}
- (void)setDealModel:(DXDealModel *)dealModel
{
    _dealModel = dealModel;
    self.titleLabel.text = dealModel.title;
    [self.dealImageView sd_setImageWithURL:[NSURL URLWithString:dealModel.image] placeholderImage:[UIImage imageNamed:@"placeholder_deal"]];
    
    self.currenPriceLabel.text = [NSString stringWithFormat:@"¥ %.2f",[dealModel.current_price floatValue]/100];
    self.origalPriceLabel.text = [NSString stringWithFormat:@"¥ %.2f",[dealModel.market_price floatValue]/100];
    self.descripLabel.text = dealModel.descriptions;
    [self.saleNum setTitle:[NSString stringWithFormat:@"已售 %@",dealModel.sale_num] forState:UIControlStateNormal];
    
    NSDate *deadDate = [NSDate dateWithTimeIntervalSince1970:[dealModel.purchase_deadline integerValue]];
    NSDate *nowDate = [NSDate date];
    NSCalendar *cal = [NSCalendar currentCalendar];
  NSDateComponents *components = [cal components:NSCalendarUnitDay|NSCalendarUnitHour|NSCalendarUnitMinute fromDate:nowDate toDate:deadDate options:NSCalendarMatchStrictly];
    NSString *deadlineStr = [NSString stringWithFormat:@"%ld天%ld小时%ld分钟",components.day,components.hour,components.minute];
//    ToastMessage(deadlineStr);
    [self.deadTime setTitle:deadlineStr forState:UIControlStateNormal];
    self.deadTime.userInteractionEnabled = NO;
    self.saleNum.userInteractionEnabled = NO;
    
}

- (IBAction)backBtnClick:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)collectBtnClick:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (sender.selected) {
//       收藏
        [DXCollectTools insertDealWith:self.dealModel];
    }else{
//       移除收藏
        if (![DXCollectTools deleteDealWith:self.dealModel]) {
            sender.selected = YES;
        }
    
    }
}
- (IBAction)shareBtnClick:(UIButton *)sender {

}

- (IBAction)buyBtn:(UIButton *)sender {
}

#pragma mark -webView代理

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{

    NSLog(@"%@",request.URL.absoluteString);
    return YES;
}
- (void)webViewDidStartLoad:(UIWebView *)webView
{
    self.hiddenWebView.hidden = NO;
    DXShowProgressingHUD;
}
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    [self deleteElements:webView];
    DXHiddenProgressingHUD;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.hiddenWebView.hidden = YES;
    });
    
}

- (void)deleteElements:(UIWebView *)webView
{

    [webView stringByEvaluatingJavaScriptFromString:@"document.getElementsByClassName(\"search-bar clearfix flexible static-hook-real static-hook-id-2\")[0].remove();"];
    [webView stringByEvaluatingJavaScriptFromString:@"document.getElementsByClassName(\"header-bar static-hook-real static-hook-id-1\")[0].remove();"];
    [webView stringByEvaluatingJavaScriptFromString:@"document.getElementsByClassName(\"nav-bar-header  static-hook-real static-hook-id-3\")[0].remove();"];
    [webView stringByEvaluatingJavaScriptFromString:@"document.getElementsByClassName(\"p-item-info\")[0].remove();"];
    [webView stringByEvaluatingJavaScriptFromString:@"document.getElementsByClassName(\"clearfix\")[0].remove();"];
    [webView stringByEvaluatingJavaScriptFromString:@"document.getElementsByClassName(\"w-buy-2-buy-list\")[0].remove();"];
    [webView stringByEvaluatingJavaScriptFromString:@"document.getElementsByClassName(\"ceiling-buy clearfix static-hook-real static-hook-id-17\")[0].remove();"];
    [webView stringByEvaluatingJavaScriptFromString:@"document.getElementsByClassName(\"recommend-title clearfix\")[0].remove();"];
    [webView stringByEvaluatingJavaScriptFromString:@"document.getElementsByClassName(\"j-see2see-page see2see-page show\")[0].remove();"];
    [webView stringByEvaluatingJavaScriptFromString:@"document.getElementsByClassName(\"w-buy-bottom clearfix\")[0].remove();"];
    [webView stringByEvaluatingJavaScriptFromString:@"document.getElementsByClassName(\"user-bought clearfix\")[0].remove();"];
    [webView stringByEvaluatingJavaScriptFromString:@"document.getElementsByClassName(\"footer-inner clearfix flexible\")[0].remove();"];
    [webView stringByEvaluatingJavaScriptFromString:@"document.getElementsByClassName(\"site-info\")[0].remove();"];
    [webView stringByEvaluatingJavaScriptFromString:@"document.getElementsByClassName(\"icons\")[0].remove();"];
    [webView stringByEvaluatingJavaScriptFromString:@"document.getElementsByClassName(\"user-bought clearfix\")[0].remove();"];
}
@end
