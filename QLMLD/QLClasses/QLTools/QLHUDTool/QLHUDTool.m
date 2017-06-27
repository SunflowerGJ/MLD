//
//  QLHUDTool.m
//  HeartNet
//
//  Created by Shrek on 15/12/21.
//  Copyright © 2015年 Shreker. All rights reserved.
//

#import "QLHUDTool.h"
#import "SVProgressHUD.h"

@implementation QLHUDTool

+ (void)showLoading {
    [self showLoadingWithStatus:@"请稍后..."];
}

+ (void)showLoadingWithStatus:(NSString *)status {
    [SVProgressHUD showWithStatus:status maskType:SVProgressHUDMaskTypeClear];
}

+ (void)showSuccessWithStatus:(NSString *)status {
    [SVProgressHUD showSuccessWithStatus:status];
}

+ (void)showErrorWithStatus:(NSString *)status {
    [SVProgressHUD showErrorWithStatus:status];
}

+ (void)showAlertMessage:(NSString *)message {
    [SVProgressHUD showAlterMessage:message];
}

+ (void)dissmis {
    [SVProgressHUD dismiss];
}

@end
