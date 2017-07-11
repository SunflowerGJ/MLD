//
//  QLRegisterFinisheInfoVC.m
//  QLMLD
//
//  Created by 英英 on 2017/7/11.
//  Copyright © 2017年 Shreker. All rights reserved.
//

#import "QLRegisterFinisheInfoVC.h"

@interface QLRegisterFinisheInfoVC (){

    __weak IBOutlet UIButton *_btnApply;
    __weak IBOutlet UIView *_viewOne;
    __weak IBOutlet UIView *_viewTwo;
    __weak IBOutlet UIView *_viewThree;
}

@end

@implementation QLRegisterFinisheInfoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadDefaultSetting];
}

/** Load the default UI elements And prepare some datas needed. */
- (void)loadDefaultSetting {
    [self setTitle:@"完成资料"];
    [_btnApply setCornerRadius:10];
    [_viewOne setBorder:.5 borderColor:QLDividerColor];
    [_viewTwo setBorder:.5 borderColor:QLDividerColor];
    [_viewThree setBorder:.5 borderColor:QLDividerColor];

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
