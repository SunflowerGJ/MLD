//
//  QLGuidePageViewController.m
//  HeartNet
//
//  Created by Shrek on 15/12/10.
//  Copyright © 2015年 Shreker. All rights reserved.
//

#import "QLGuidePageViewController.h"
#import "QLAppDelegate.h"
#import "UIImage+QLImage.h"

@interface QLGuidePageViewController ()

@end

@implementation QLGuidePageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadDefaultSetting];
}

/** Load the default UI elements And prepare some datas needed. */
- (void)loadDefaultSetting {
    self.view.backgroundColor = [UIColor whiteColor];
    
    NSString *strImageName = [NSString stringWithFormat:@"guide_%zi", self.currentPage + 1];
    self.view.layer.contents = (id)[UIImage imageForDeviceWithName:strImageName].CGImage;
    
    if (self.isLastPage) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
        [button setBackgroundImage:[UIImage imageNamed:@"img_guide_run"] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:button];
        CGFloat screenHeight = QLScreenHeight;
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@(120));
            make.height.equalTo(@(35));
            make.centerX.equalTo(self.view);
            if (screenHeight <= 480) {
                make.bottom.equalTo(self.view).offset(-15);
            } else {
                make.bottom.equalTo(self.view).offset(-40);
            }
        }];
    }
}

- (void)dismiss {
    QLAppDelegate *delegate = [UIApplication sharedApplication].delegate;
    [delegate changeRootViewControllerToMain];
}

@end
