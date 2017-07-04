//
//  QLRegisterViewController.m
//  HeartNet
//
//  Created by Shrek on 15/12/14.
//  Copyright © 2015年 Shreker. All rights reserved.
//

#import "QLRegisterViewController.h"
#import <CoreLocation/CoreLocation.h>

static const NSUInteger totalTime = 120;

@interface QLRegisterViewController () <UITextFieldDelegate, CLLocationManagerDelegate, UIAlertViewDelegate>
{
    __weak IBOutlet UITextField *_txfPwd;
    __weak IBOutlet UITextField *_txfPwdConfirm;
    __weak IBOutlet UITextField *_txfPhone;
    __weak IBOutlet UITextField *_txfCode;
    __weak IBOutlet UIButton *_btnGetCode;
    __weak IBOutlet UILabel *_lblTimer;
    
    NSTimer *_timer;
    NSInteger _timeWaiting;
    NSString *_code;     
    

}

@end

@implementation QLRegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadDefaultSetting];
}

/** Load the default UI elements And prepare some datas needed. */
- (void)loadDefaultSetting {
    [self setTitle:@"新用户注册"];
    _timeWaiting = totalTime;
    [_txfPwd setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
    [_txfCode setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
    [_txfPhone setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
    [_txfPwdConfirm setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];

    
}

#pragma mark - Actions
- (IBAction)requestCode {
    [self.view endEditing:YES];
    if (![NSString isPhoneNumber:_txfPhone.text]) {
        [QLHUDTool showErrorWithStatus:@"手机号格式不正确"];
        return;
    }
    _code = [NSString stringWithFormat:@"%d%d%d%d%d%d", arc4random_uniform(9), arc4random_uniform(9), arc4random_uniform(9), arc4random_uniform(9), arc4random_uniform(9), arc4random_uniform(9)];
    NSDictionary *dicParams = @{@"account": @"xdrj_hy",
                                @"pswd": @"xdrj_hy123",
                                @"mobile": _txfPhone.text,
                                @"msg": [NSString stringWithFormat:@"【FramWork】您的验证为:%@", _code],
                                @"needstatus": @"true"};
    QLLog(@"%@", dicParams);
    [QLHttpTool getWithBaseUrl:@"http://120.26.66.24/msg/HttpBatchSendSM" Parameters:dicParams whenSuccess:nil whenFailure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSInteger statusCode = operation.response.statusCode;
        if (statusCode == 200) {
            NSString *strResponse = operation.responseString;
            strResponse = [strResponse componentsSeparatedByString:@","][1];
            NSString *code = [[strResponse componentsSeparatedByString:@"\n"] firstObject];
            if ([code isEqualToString:@"0"]) {
                QLLog(@"%@", @"验证码发送成功");
                [QLHUDTool showAlertMessage:@"验证码发送成功"];
                _timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updateTimeWaiting) userInfo:nil repeats:YES];
                _btnGetCode.enabled = NO;
            } else {
                QLLog(@"验证码发送失败:code:%@", code);
            }
        } else {
            QLLog(@"验证码发送失败,statusCode:%zd", statusCode);
        }
    }];
}
- (void)updateTimeWaiting {
    [_lblTimer setText:[NSString stringWithFormat:@"%zd秒", -- _timeWaiting]];
    if (_timeWaiting <= 0) {
        [_timer invalidate];
        _timer = nil;
        [_lblTimer setText:@"重新获取"];
        _btnGetCode.enabled = YES;
        _timeWaiting = totalTime;
    }
}
- (IBAction)next {
    if ([self checkInput] == NO) {
        return;
    }
    
    if (_txfPwd.text.length < 6 || _txfPwd.text.length > 16) {
        [QLHUDTool showErrorWithStatus:@"密码长度6-16个字符"];
        return;
    }
    if (![_txfPwd.text isEqualToString:_txfPwdConfirm.text]) {
        [QLHUDTool showErrorWithStatus:@"两输入密码不一致"];
        return;
    }
    [self registerUser];
}

- (void)registerUser {
    if ([_code isEqualToString:_txfCode.text]) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}

- (BOOL)checkInput {
    if (![NSString isPhoneNumber:_txfPhone.text]) {
        [QLHUDTool showErrorWithStatus:@"手机号格式不正确"];
        return NO;
    }
    if (_txfCode.text.length != 6) {
        [QLHUDTool showErrorWithStatus:@"请输入正确的验证码"];
        return NO;
    }
    return YES;
}

#pragma mark - Delegates
#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
    }
}

#pragma mark - HTTP Request
// 验证用户名是否存在
- (void)requestUserExist {
    
}

@end
