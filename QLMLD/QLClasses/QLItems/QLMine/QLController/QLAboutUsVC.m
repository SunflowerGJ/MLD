//
//  QLAboutUsVC.m
//  QLMLD
//
//  Created by 英英 on 2017/7/22.
//  Copyright © 2017年 Shreker. All rights reserved.
//  关于我们

#import "QLAboutUsVC.h"

@interface QLAboutUsVC ()

@end

@implementation QLAboutUsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadDefaultSetting];
}
- (void)loadDefaultSetting {
    self.title = @"关于我们";
    
    NSString *versionInfo = [NSString stringWithFormat:@"Copyright ©2016 \n fahuola.cn All Rights Reserved."];
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    // app名称
    NSString *app_Name = [NSString stringWithFormat:@"关于%@",[infoDictionary objectForKey:@"CFBundleDisplayName"]];
    // app版本
    NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    NSString *name = [NSString stringWithFormat:@"%@  V%@",app_Name,app_Version];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
