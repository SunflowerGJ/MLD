//
//  QLGuideViewController.m
//  HeartNet
//
//  Created by Shrek on 15/12/9.
//  Copyright © 2015年 Shreker. All rights reserved.
//

#import "QLGuideViewController.h"
#import "QLGuidePageViewController.h"

@interface QLGuideViewController () <UIPageViewControllerDataSource, UIPageViewControllerDelegate>
{
    NSArray *_arrViewControllers;
}

@end

@implementation QLGuideViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadDefaultSetting];
}

/** Load the default UI elements And prepare some datas needed. */
- (void)loadDefaultSetting {
    self.title = @"Guide";
    self.view.backgroundColor = [UIColor whiteColor];
    
    NSUInteger count = 4;
    NSMutableArray *arrMGuidePages = [NSMutableArray arrayWithCapacity:count];
    for (NSUInteger index = 0; index < count; index ++) {
        QLGuidePageViewController *vcGuide = [QLGuidePageViewController new];
        vcGuide.currentPage = index;
        if (index == count - 1) {
            vcGuide.isLastPage = YES;
        }
        [arrMGuidePages addObject:vcGuide];
    }
    
    _arrViewControllers = [arrMGuidePages copy];
    
    [self setViewControllers:@[[_arrViewControllers firstObject]] direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
    
    self.dataSource = self;
    self.delegate = self;
}

#pragma mark - UIPageViewControllerDataSource
- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    UIViewController *controller = nil;
    NSInteger count = _arrViewControllers.count;
    for (NSInteger index = 0; index < count; index ++) {
        UIViewController *vc = _arrViewControllers[index];
        if ([vc isEqual:viewController]) {
            if (index - 1 < 0) break;
            controller = _arrViewControllers[index - 1];
            break;
        }
    }
    return controller;
}
- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    UIViewController *controller = nil;
    NSInteger count = _arrViewControllers.count;
    for (NSInteger index = 0; index < count; index ++) {
        UIViewController *vc = _arrViewControllers[index];
        if ([vc isEqual:viewController]) {
            if (index + 1 >= count) break;
            controller = _arrViewControllers[index + 1];
            break;
        }
    }
    return controller;
}

@end
