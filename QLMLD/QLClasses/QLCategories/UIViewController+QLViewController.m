//
//  UIViewController+QLViewController.m
//  HeartNet
//
//  Created by Shrek on 15/12/28.
//  Copyright © 2015年 Shreker. All rights reserved.
//

#import "UIViewController+QLViewController.h"
#import "QLLoginViewController.h"
#import "QLNavigationController.h"

@implementation UIViewController (QLViewController)

- (void)presentLoginViewController {
    UIStoryboard *sbLogin = [UIStoryboard storyboardWithName:@"Login" bundle:nil];
    QLNavigationController *vcNav = [sbLogin instantiateViewControllerWithIdentifier:@"loginNav"];
    QLLoginViewController *vcLogin = vcNav.viewControllers.firstObject;
    vcLogin.isFromMine = YES;
    [self presentViewController:vcNav animated:YES completion:nil];
}

@end
