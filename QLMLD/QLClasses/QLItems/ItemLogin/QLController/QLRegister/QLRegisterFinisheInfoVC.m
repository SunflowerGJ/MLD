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
    
    __weak IBOutlet UITextField *_tfParentName;
    __weak IBOutlet UITextField *_tfChindName;
    
    
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
- (IBAction)touchSelectedClass:(id)sender {
}

- (IBAction)btnApply:(id)sender {
}

@end
