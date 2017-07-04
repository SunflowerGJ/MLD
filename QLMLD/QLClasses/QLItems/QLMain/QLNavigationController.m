//
//  QLNavigationController.m
//  HeartNet
//
//  Created by Shrek on 15/12/8.
//  Copyright © 2015年 Shreker. All rights reserved.
//

#import "QLNavigationController.h"

@interface QLNavigationController () <UINavigationControllerDelegate>

@end

@implementation QLNavigationController

+ (void)initialize {
//    UINavigationBar *navBar = [UINavigationBar appearance];
//    [navBar setBarTintColor:QLMainNavColor];
//    [navBar setTintColor:[UIColor whiteColor]];
//    [navBar setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]}];
//    
//    UIBarButtonItem
//    *barButtonItem = [UIBarButtonItem appearanceWhenContainedIn:[QLNavigationController class], nil];
//    [barButtonItem setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]} forState:UIControlStateNormal];
//    
//    [barButtonItem setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor lightGrayColor]} forState:UIControlStateDisabled];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadDefaultSetting];
}

/** Load the default UI elements And prepare some datas needed. */
- (void)loadDefaultSetting {
    self.navigationBar.hidden = YES;
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
//    viewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"icon_back"] style:UIBarButtonItemStylePlain target:self action:@selector(backAction)];
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:nil style:0 target:nil action:nil];
    [super pushViewController:viewController animated:animated];
}

- (void)backAction {
    [self popViewControllerAnimated:YES];
}
@end
