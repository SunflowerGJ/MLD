//
//  QLGoodDetailVC.m
//  QLMLD
//
//  Created by 英英 on 2017/7/22.
//  Copyright © 2017年 Shreker. All rights reserved.
//  商品详情- 页面布局

#import "QLGoodDetailVC.h"
#define maxNum 90

@interface QLGoodDetailVC (){
    __weak IBOutlet UIView *_viewBGCountNum;
    __weak IBOutlet UIView *_viewBgEdit;

    __weak IBOutlet UIWebView *_webDetial;
    __weak IBOutlet UILabel *_lblCollectionStatus;
    __weak IBOutlet UIImageView *_imgCollectionStatus;
    __weak IBOutlet UITextField *_tfCount;
    
    NSInteger countNum;
    BOOL isCollection;
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
    [_viewBgEdit setBorder:1 borderColor:QLDividerColor];
    isCollection = NO;

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)textFieldDidEndEditing:(UITextField *)textField{
    NSInteger input = [textField.text integerValue];
    if (input>maxNum) {
        [QLHUDTool showAlertMessage:@"超出最大限额"];
        countNum = maxNum;
    }else{
        countNum = input;
    }
    _tfCount.text = [NSString stringWithFormat:@"%zd",countNum];
    [[IQKeyboardManager sharedManager] setEnable:YES];
    [[IQKeyboardManager sharedManager] setEnableAutoToolbar:YES];
}

#pragma mark -
- (IBAction)btnCollection:(id)sender {
    isCollection = !isCollection;
    if (!isCollection) {
        _imgCollectionStatus.image = [UIImage imageNamed:@"unCollection_icon"];
    }else{
        _imgCollectionStatus.image = [UIImage imageNamed:@"collection_icon"];
    }
}
- (IBAction)btnMinus:(id)sender {
    if ([_cartModel.cartCount integerValue]<=0) {
        return ;
    }else{
        NSInteger count = [_tfCount.text integerValue];
        count--;
        [_cartModel setValue:[NSString stringWithFormat:@"%zd",count] forKey:NSStringFromSelector(@selector(cartCount))];
        NSLog(@"value changed==: %@", _cartModel.cartCount);
        _tfCount.text = [NSString stringWithFormat:@"%zd",count];
    }
}
- (IBAction)btnPlus:(id)sender {
    
    if ([_cartModel.cartCount integerValue]>maxNum) {
        return ;
    }else{
        NSInteger count = [_tfCount.text integerValue];
        count++;
        [_cartModel setValue:[NSString stringWithFormat:@"%zd",count] forKey:NSStringFromSelector(@selector(cartCount))];
        _tfCount.text = [NSString stringWithFormat:@"%zd",count];
    }
}
- (IBAction)btnGoodsDetail:(id)sender {
    
}
//参数
- (IBAction)btnArgument:(id)sender {
}

@end
