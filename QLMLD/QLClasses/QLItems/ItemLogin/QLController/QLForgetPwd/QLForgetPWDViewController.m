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
    __weak IBOutlet UIButton *_btnEnsure;
    
    NSTimer *_timer;
    NSInteger _timeWaiting;
    NSString *_code;
}

@end

@implementation QLForgetPWDViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:YES];
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
    [_btnEnsure setCornerRadius:QLCornerRadius border:.5 borderColor:[UIColor whiteColor]];
    [_btnGetCode setCornerRadius:QLCornerRadius];
    [_txfPhone setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
    [_txfPwd setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
    [_tfPwdEnsure setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
    [_txfCode setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];

    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textFiledEditChanged:) name:@"UITextFieldTextDidChangeNotification"
                                              object:_txfCode];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textFiledEditChanged:) name:@"UITextFieldTextDidChangeNotification"
                                              object:_txfPwd];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textFiledEditChanged:) name:@"UITextFieldTextDidChangeNotification"
                                              object:_tfPwdEnsure];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textFiledEditChanged:) name:@"UITextFieldTextDidChangeNotification"
                                              object:_txfPhone];
    
}
- (void)textFiledEditChanged:(NSNotification *)notifi{
    if (_txfPhone) {
        if (_txfPhone.text.length > 11) {
            _txfPhone.text = [_txfPhone.text substringToIndex:6];
        }
    }
    if (_txfPwd) {
        if (_txfPwd.text.length > PasswordInputLengthMax) {
            _txfPwd.text = [_txfPwd.text substringToIndex:PasswordInputLengthMax];
        }
    }
    if (_tfPwdEnsure) {
        if (_tfPwdEnsure.text.length > PasswordInputLengthMax) {
            _tfPwdEnsure.text = [_tfPwdEnsure.text substringToIndex:PasswordInputLengthMax];
        }
    }
    if (_txfCode) {
        if (_txfCode.text.length > 6) {
            _txfCode.text = [_txfCode.text substringToIndex:6];
        }
    }
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
    if (_txfPhone.text.length<=0) {
        [QLHUDTool showAlertMessage:@"请输入手机号"];
        return;
    }
    if (![NSString isPhoneNumber:_txfPhone.text]) {
        [QLHUDTool showErrorWithStatus:@"手机号格式不正确"];
        return;
    }
    NSString *strUrl = [NSString stringWithFormat:@"%@%@?tel=%@",QLBaseUrlString,getVirifyCode_interface,_txfPhone.text];
    [QLHUDTool showLoading];
    [QLHttpTool getWithBaseUrl:strUrl Parameters:nil whenSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        [QLHUDTool dissmis];
        if([responseObject objectForKey:@"success"]&&[[responseObject objectForKey:@"success"] boolValue]){
            QLLog(@"code==%@",responseObject);
            _code = [NSString stringWithFormat:@"%ld",[responseObject[@"smsCode"] integerValue]];
            [QLHUDTool showAlertMessage:@"验证码发送成功"];
            _timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updateTimeWaiting) userInfo:nil repeats:YES];
            _btnGetCode.enabled = NO;
        }else{
            [QLHUDTool showAlertMessage:@"验证码发送失败"];
        }
    } whenFailure:^{
        [QLHUDTool dissmis];
        [QLHUDTool showAlertMessage:@"验证码发送失败"];
    }];
   
}
//确定
- (IBAction)btnEnsure:(id)sender {
    if ([self checkInput] == NO) {
        return;
    }
    NSString *strBaseUrl = [NSString stringWithFormat:@"%@%@",QLBaseUrlString,foundPwd_interface];
    NSData *dataPwd = [[NSString stringWithFormat:@"%@",_tfPwdEnsure.text] dataUsingEncoding:NSUTF8StringEncoding];

    NSDictionary *dicParam = @{@"user_tel":_txfPhone.text,@"user_password":[dataPwd md5String],@"smsCode":_txfCode.text};
    [QLHttpTool postWithBaseUrl:strBaseUrl Parameters:dicParam whenSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        QLLog(@"forget PWD == %@",responseObject);
    } whenFailure:^{
        
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
    if (_txfPhone.text.length<=0) {
        [QLHUDTool showAlertMessage:@"请输入手机号"];
        return NO;
    }
    if (![NSString isPhoneNumber:_txfPhone.text]) {
        [QLHUDTool showErrorWithStatus:@"手机号格式不正确"];
        return NO;
    }
    if (_txfPwd.text.length<=0) {
        [QLHUDTool showAlertMessage:@"请输入密码"];
        return NO;
    }
    if((_txfPwd.text.length < 6 || _txfPwd.text.length > 16)){
        [QLHUDTool showErrorWithStatus:@"密码长度6-16个字符"];
        return NO;
    }
    if(_tfPwdEnsure.text.length<=0) {
        [QLHUDTool showAlertMessage:@"请确认密码"];
        return NO;
    }
    if (_tfPwdEnsure.text.length < 6 || _tfPwdEnsure.text.length > 16) {
        [QLHUDTool showErrorWithStatus:@"密码长度6-16个字符"];
        return NO;
    }
    if (![_txfPwd.text isEqualToString:_tfPwdEnsure.text]) {
        [QLHUDTool showErrorWithStatus:@"两次密码输入不一致"];
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
