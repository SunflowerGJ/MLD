//
//  QLHUDTool.h
//  HeartNet
//
//  Created by Shrek on 15/12/21.
//  Copyright © 2015年 Shreker. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QLHUDTool : NSObject

+ (void)showLoading;

+ (void)showLoadingWithStatus:(NSString *)status;

+ (void)showSuccessWithStatus:(NSString *)status;

+ (void)showErrorWithStatus:(NSString *)status;

+ (void)showAlertMessage:(NSString *)message;

+ (void)dissmis;

@end
