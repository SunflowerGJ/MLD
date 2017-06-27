//
//  QLSetNewViewController.m
//  HeartNet
//
//  Created by Shrek on 15/12/16.
//  Copyright © 2015年 Shreker. All rights reserved.
//

#import "QLSetNewViewController.h"
#import "QLAppDelegate.h"

@interface QLSetNewViewController ()
{
    __weak IBOutlet UITextField *_txfPwd;
    __weak IBOutlet UITextField *_txfPwdConfirm;
}

@end

@implementation QLSetNewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadDefaultSetting];
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

/** Load the default UI elements And prepare some datas needed. */
- (void)loadDefaultSetting {
    UIView *viewPWD = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 20)];
    _txfPwd.leftView = viewPWD;
    _txfPwd.leftViewMode = UITextFieldViewModeAlways;
    
    UIView *viewPWDConfirm = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 20)];
    _txfPwdConfirm.leftView = viewPWDConfirm;
    _txfPwdConfirm.leftViewMode = UITextFieldViewModeAlways;
    
}
- (IBAction)login {
    if ([self checkInput] == NO) {
        return;
    }
    
    
}

- (void)autoLoginWithAccount:(NSString *)account {
    
}

- (BOOL)checkInput {
    if (_txfPwd.text.length < 6 || _txfPwd.text.length > 16) {
        [QLHUDTool showErrorWithStatus:@"密码长度6-16个字符"];
        return NO;
    }
    if (![_txfPwd.text isEqualToString:_txfPwdConfirm.text]) {
        [QLHUDTool showErrorWithStatus:@"两输入密码不一致"];
        return NO;
    }
    
    return YES;
}

@end
