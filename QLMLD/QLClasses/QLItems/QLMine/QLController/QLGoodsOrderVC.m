//
//  QLGoodsOrderVC.m
//  QLMLD
//
//  Created by syy on 2017/7/12.
//  Copyright © 2017年 Shreker. All rights reserved.
//

#import "QLGoodsOrderVC.h"

@interface QLGoodsOrderVC ()

@end

@implementation QLGoodsOrderVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadDefaultSetting];
}
- (void)loadDefaultSetting {
    self.title = @"商品详情";
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
