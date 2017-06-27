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

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Change Root View Controller
    NSString *strVersionKey = (NSString *)kCFBundleVersionKey;
    NSString *strVersionPrevious = [[NSUserDefaults standardUserDefaults] stringForKey:strVersionKey];
    NSString *strVersionCurrent = [NSBundle mainBundle].infoDictionary[strVersionKey];
    if ([strVersionCurrent isEqualToString:strVersionPrevious]) {
        [self changeRootViewControllerToMain];
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
    QLLoginViewController *vcLogin = [QLLoginViewController new];
    self.window.rootViewController = [[QLNavigationController alloc] initWithRootViewController:vcLogin];
}

@end
