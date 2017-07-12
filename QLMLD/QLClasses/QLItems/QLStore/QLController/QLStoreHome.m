//
//  QLStoreHome.m
//  QLMLD
//
//  Created by 英英 on 2017/7/2.
//  Copyright © 2017年 Shreker. All rights reserved.
//

#import "QLStoreHome.h"

@interface QLStoreHome ()

@end

@implementation QLStoreHome

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self loadDefaultSetting];
}
- (void)loadDefaultSetting {
    self.rightBtn.hidden = NO;
    self.leftBtn.hidden = YES;
    self.rightBtn.frame= CGRectMake(QLScreenWidth-60, 28, 60, 30);
    [self.rightBtn setImage:[UIImage imageNamed:@"cart_icon"] forState:UIControlStateNormal];
}

- (void)clickRight {
    
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
