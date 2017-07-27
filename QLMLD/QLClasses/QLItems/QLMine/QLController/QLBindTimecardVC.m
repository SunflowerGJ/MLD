//
//  QLBindTimecardVC.m
//  QLMLD
//
//  Created by 英英 on 2017/7/22.
//  Copyright © 2017年 Shreker. All rights reserved.
//  绑定考勤卡

#import "QLBindTimecardVC.h"

@interface QLBindTimecardVC (){

    __weak IBOutlet UITextField *_tfCardNum;
    __weak IBOutlet UIButton *_btnBind;
}

@end

@implementation QLBindTimecardVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadDefaultSetting];
}
- (void)loadDefaultSetting {
    self.title = @"绑定考勤卡";
    [_btnBind setCornerRadius:QLCornerRadius];
    BOOL isBind = YES;
    if (isBind) {
        _tfCardNum.text = @"ddd";
        _tfCardNum.userInteractionEnabled = NO;
    }else{
        _btnBind.hidden = YES;
         _tfCardNum.userInteractionEnabled = YES;
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - btn
- (IBAction)btnBind:(id)sender {
    NSString *strBaseUrl = [NSString stringWithFormat:@"%@%@",QLBaseUrlString];
    NSDictionary *dicParam = @{};
    [QLHttpTool postWithBaseUrl:strBaseUrl Parameters:dicParam whenSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
    } whenFailure:^{
        
    }];
}

@end
