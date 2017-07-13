//
//  QLUserInfoVC.m
//  QLMLD
//
//  Created by syy on 2017/7/12.
//  Copyright © 2017年 Shreker. All rights reserved.
//

#import "QLUserInfoVC.h"
#import "QLAlterPwdVC.h"
@interface QLUserInfoVC (){
    
    __weak IBOutlet UIButton *_btnImageHead;
    
    __weak IBOutlet UILabel *_lblName;
    
    __weak IBOutlet UILabel *_lblAccount;
    __weak IBOutlet UIButton *_btnLogout;
}

@end

@implementation QLUserInfoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadDefaultSetting];
}
- (void)loadDefaultSetting {
    self.title = @"个人信息";
    [_btnLogout setBorder:.5 borderColor:QLDividerColor];
    [_btnImageHead setCornerRadius:20];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//修改密码
- (IBAction)touchToAlterPwd:(id)sender {
    QLAlterPwdVC *alterVC = [[QLAlterPwdVC alloc]init];
    [[QLHttpTool getCurrentVC].navigationController pushViewController:alterVC animated:YES];
}

- (IBAction)btnLogout:(id)sender {
}

@end
