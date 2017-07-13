//
//  QLAlterPwdVC.m
//  QLMLD
//
//  Created by 英英 on 2017/7/13.
//  Copyright © 2017年 Shreker. All rights reserved.
//

#import "QLAlterPwdVC.h"

@interface QLAlterPwdVC (){

    __weak IBOutlet UITextField *_tfOldPwd;
    
    __weak IBOutlet UITextField *_tfNewPwd;
    
    __weak IBOutlet UITextField *_tfEnsurePwd;
    __weak IBOutlet UIButton *_btnEnsure;
}

@end

@implementation QLAlterPwdVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadDefaultSetting];
}
- (void)loadDefaultSetting {
    self.title = @"修改密码";
    [_btnEnsure setCornerRadius:10];

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)btnEnsure:(id)sender {
}


@end
