//
//  QLSchoolInfoVC.m
//  QLMLD
//
//  Created by 英英 on 2017/7/22.
//  Copyright © 2017年 Shreker. All rights reserved.
//  学校介绍

#import "QLSchoolInfoVC.h"

@interface QLSchoolInfoVC ()

@end

@implementation QLSchoolInfoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadDefaultSetting];
}
- (void)loadDefaultSetting {
    self.title = @"学校介绍";
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
