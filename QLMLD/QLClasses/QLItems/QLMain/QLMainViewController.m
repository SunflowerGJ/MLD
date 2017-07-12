//
//  QLMainViewController.m
//  QLProjectDemo
//
//  Created by Shrek on 15/12/4.
//  Copyright © 2015年 Shreker. All rights reserved.
//

#import "QLMainViewController.h"
#import "QLMineViewController.h"
#import "UIImage+QLImage.h"

@interface QLMainViewController () <UITabBarControllerDelegate>

@end

@implementation QLMainViewController

#pragma mark - Life Circle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadDefaultSetting];
}

/** Load the default UI elements And prepare some datas needed. */
- (void)loadDefaultSetting {
    NSArray *controllerProperties = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"controllers" ofType:@"plist"]];
    NSMutableArray *controllers = [NSMutableArray arrayWithCapacity:controllerProperties.count];
    for (NSDictionary *dicData in controllerProperties) {
        Class cls = NSClassFromString(dicData[@"controller"]);
        UIViewController *viewController = [cls new];
        viewController.title = dicData[@"title"];
        UIImage *image=[UIImage imageForOriginalWithImageName:dicData[@"tab_icon"]];
        viewController.tabBarItem.image = image;
        // 设置 tabbarItem 选中状态下的文字颜色(不被系统默认渲染,显示文字自定义颜色)
        NSDictionary *dictHome = [NSDictionary dictionaryWithObject:QLYellowColor forKey:NSForegroundColorAttributeName];
        [viewController.tabBarItem setTitleTextAttributes:dictHome forState:UIControlStateSelected];
        [controllers addObject:viewController];
    }
    self.delegate = self;
    self.viewControllers = [controllers copy];
    [self syncNavgationItemsFromViewController:controllers.firstObject];
}

#pragma mark - UITabBarControllerDelegate
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController {
    [self syncNavgationItemsFromViewController:viewController];
}
- (void)syncNavgationItemsFromViewController:(UIViewController *)viewController {
    self.navigationItem.leftBarButtonItem = viewController.navigationItem.leftBarButtonItem;
    self.navigationItem.leftBarButtonItems = viewController.navigationItem.leftBarButtonItems;
    self.navigationItem.rightBarButtonItem = viewController.navigationItem.rightBarButtonItem;
    self.navigationItem.rightBarButtonItems = viewController.navigationItem.rightBarButtonItems;
    self.navigationItem.titleView = viewController.navigationItem.titleView;
    self.navigationItem.title = viewController.navigationItem.title;
}

- (void)dealloc {
    // RELEASE OBJECTS TO FREE THE MEMORIES HERE!
    __unsafe_unretained typeof(self) selfUnsafe = self;
    QLLog(@"🌜A instance of type %@ was DESTROYED!🌛", NSStringFromClass([selfUnsafe class]));
}

@end
