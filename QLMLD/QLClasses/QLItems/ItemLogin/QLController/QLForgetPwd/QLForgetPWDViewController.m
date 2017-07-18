//
//  QLForgetPWDViewController.m
//  HeartNet
//
//  Created by Shrek on 15/12/16.
//  Copyright © 2015年 Shreker. All rights reserved.
//

#import "QLForgetPWDViewController.h"
#import "QLCodeButton.h"

#define QLIdKey @"idKey"
#define QLPhoneKey @"phoneKey"
static const NSUInteger totalTime = 120;

@interface QLForgetPWDViewController ()
{
    __weak IBOutlet UITextField *_txfPhone;
    __weak IBOutlet UITextField *_txfCode;
    __weak IBOutlet UITextField *_txfPwd;
    __weak IBOutlet UITextField *_tfPwdEnsure;
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
- (IBAction)btnEnsure {
    if ([self checkInput] == NO) {
        return;
    }
    NSString *strUrl = [NSString stringWithFormat:@"%@%@",QLBaseUrlString,foundPwd_interface];
    NSData *dataPwd = [[NSString stringWithFormat:@"%@",_tfPwdEnsure.text] dataUsingEncoding:NSUTF8StringEncoding];

    NSDictionary *dic = @{@"user_tel":_txfPhone.text,@"user_password":[dataPwd md5String]};
    [QLHttpTool getWithBaseUrl:strUrl Parameters:dic whenSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        QLLog(@"found pwd response: %@",responseObject);
    } whenFailure:^{
        
    }];
    
}

#pragma mark - HTTP Request
- (IBAction)requestCode {
    [self.view endEditing:YES];
    if (![NSString isPhoneNumber:_txfPhone.text]) {
        [QLHUDTool showErrorWithStatus:@"手机号格式不正确"];
        return;
    }
    NSString *strUrl = [NSString stringWithFormat:@"%@%@?tel=%@",QLBaseUrlString,getVirifyCode_interface,_txfPhone.text];
    [QLHttpTool getWithBaseUrl:strUrl Parameters:nil whenSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        if([responseObject objectForKey:@"success"]&&[[responseObject objectForKey:@"success"] isEqualToString:@"1"]){
            _code = responseObject[@"smsCode"];
            [QLHUDTool showAlertMessage:@"验证码发送成功"];
            _timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updateTimeWaiting) userInfo:nil repeats:YES];
            _btnGetCode.enabled = NO;
        }else{
            [QLHUDTool showAlertMessage:@"验证码发送失败"];
        }
    } whenFailure:^{
        [QLHUDTool showAlertMessage:@"验证码发送失败"];
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
    if ((_txfPwd.text.length < 6 || _txfPwd.text.length > 16)||(_tfPwdEnsure.text.length < 6 || _tfPwdEnsure.text.length > 16)) {
        [QLHUDTool showErrorWithStatus:@"密码长度6-16个字符"];
        return NO;
    }
    if (![_txfPwd.text isEqualToString:_tfPwdEnsure.text]) {
        [QLHUDTool showErrorWithStatus:@"俩次密码输入不一致"];
        return NO;
    }

    if ([_txfCode.text isEmptyString]) {
        [QLHUDTool showErrorWithStatus:@"请输入验证码"];
        return NO;
    }
    if (![_txfCode.text isEqualToString:_code]) {
        [QLHUDTool showAlertMessage:@"请输入正确的验证码"];
        return NO;
    }
    return YES;
}

@end
