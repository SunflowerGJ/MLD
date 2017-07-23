//
//  QLAppDelegate.m
//  QLProjectDemo
//
//  Created by Shrek on 15/12/4.
//  Copyright © 2015年 Shreker. All rights reserved.
//

#import "QLAppDelegate.h"
#import "QLNavigationController.h"
#import "QLMainViewController.h"
#import "QLLoginViewController.h"
#import "QLGuideViewController.h"

@interface QLAppDelegate ()

@end

@implementation QLAppDelegate
//个推实现聊天功能
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [[IQKeyboardManager sharedManager] setEnable:YES];
    // Change Root View Controller
    NSString *strVersionKey = (NSString *)kCFBundleVersionKey;
    NSString *strVersionPrevious = [[NSUserDefaults standardUserDefaults] stringForKey:strVersionKey];
    NSString *strVersionCurrent = [NSBundle mainBundle].infoDictionary[strVersionKey];
    if ([strVersionCurrent isEqualToString:strVersionPrevious]) {
        [self changeRootViewControllerToLogin];
    } else {
        [[NSUserDefaults standardUserDefaults] setObject:strVersionCurrent forKey:strVersionKey];
        [[NSUserDefaults standardUserDefaults] synchronize];
        QLGuideViewController *vcNewFeature = [[QLGuideViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
        self.window.rootViewController = vcNewFeature;
    }
    
    return YES;
}

- (void)changeRootViewControllerToMain {
    QLMainViewController *vcMain = [QLMainViewController new];
    self.window.rootViewController = [[QLNavigationController alloc] initWithRootViewController:vcMain];
}
- (void)changeRootViewControllerToLogin {
    
    
    NSString *strUserID = [NSString stringWithFormat:@"%ld",[QLUserTool sharedUserTool].userModel.user_id];
    if (strUserID) {
        QLMainViewController *vcMain = [QLMainViewController new];
        self.window.rootViewController = [[QLNavigationController alloc] initWithRootViewController:vcMain];
    }else{
        QLLoginViewController *loginViewController = [QLLoginViewController new];
        self.window.rootViewController = [[QLNavigationController alloc] initWithRootViewController:loginViewController];
    }
}

@end
