//
//  QLGoodDetailVC.m
//  QLMLD
//
//  Created by 英英 on 2017/7/22.
//  Copyright © 2017年 Shreker. All rights reserved.
//  商品详情- 页面布局

#import "QLGoodDetailVC.h"

@interface QLGoodDetailVC (){
    __weak IBOutlet UIView *_viewBGCountNum;
    __weak IBOutlet UIView *_viewBgEdit;

    __weak IBOutlet UIWebView *_webDetial;
    __weak IBOutlet UILabel *_lblCollectionStatus;
    __weak IBOutlet UIImageView *_imgCollectionStatus;
    __weak IBOutlet UITextField *_tfCount;
}

@end

@implementation QLGoodDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadDefaultSetting];
}
- (void)loadDefaultSetting {
    self.title = @"商品详情";
      [_viewBGCountNum setBorder:1 borderColor:QLDividerColor];
    [_viewBgEdit setCornerRadius:QLButtonRadius border:1 borderColor:QLDividerColor];

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
- (IBAction)btnCollection:(id)sender {
}
- (IBAction)btnMinus:(id)sender {
}
- (IBAction)btnPlus:(id)sender {
}
- (IBAction)btnGoodsDetail:(id)sender {
}
//参数
- (IBAction)btnArgument:(id)sender {
}

@end
