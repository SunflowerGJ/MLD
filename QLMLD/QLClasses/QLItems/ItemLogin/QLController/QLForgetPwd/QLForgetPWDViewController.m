//
//  QLForgetPWDViewController.m
//  HeartNet
//
//  Created by Shrek on 15/12/16.
//  Copyright © 2015年 Shreker. All rights reserved.
//

#import "QLForgetPWDViewController.h"
#import "QLFillCodeViewController.h"
#import "QLCodeButton.h"

#define QLIdKey @"idKey"
#define QLPhoneKey @"phoneKey"
static const NSUInteger totalTime = 120;

@interface QLForgetPWDViewController ()
{
    __weak IBOutlet UITextField *_txfPhone;
    __weak IBOutlet UITextField *_txfCode;
    __weak IBOutlet UITextField *_txfPwd;
    __weak IBOutlet UIButton *_btnGetCode;
    __weak IBOutlet UILabel *_lblTimer;
    
    NSTimer *_timer;
    NSInteger _timeWaiting;
    NSString *_code;
}

@end

@implementation QLForgetPWDViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadDefaultSetting];
}

/** Load the default UI elements And prepare some datas needed. */
- (void)loadDefaultSetting {
    self.title = @"忘记密码";
    UIView *viewUser = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 20)];
    _txfPhone.leftView = viewUser;
    _txfPhone.leftViewMode = UITextFieldViewModeAlways;
    
    UIView *viewCode = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 20)];
    _txfCode.leftView = viewCode;
    _txfCode.leftViewMode = UITextFieldViewModeAlways;
    _timeWaiting = totalTime;
}

#pragma mark - Actions
- (IBAction)next {
    if ([self checkInput] == NO) {
        return;
    }
    
    if (_txfPwd.text.length < 6 || _txfPwd.text.length > 16) {
        [QLHUDTool showErrorWithStatus:@"密码长度6-16个字符"];
        return;
    }
    
    [self.navigationController popToRootViewControllerAnimated:YES];
}

#pragma mark - HTTP Request
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

@end
