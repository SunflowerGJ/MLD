//
//  QLRegisterViewController.m
//  HeartNet
//
//  Created by Shrek on 15/12/14.
//  Copyright © 2015年 Shreker. All rights reserved.
//

#import "QLRegisterViewController.h"
#import <CoreLocation/CoreLocation.h>
#import "QLRegisterFinisheInfoVC.h"
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
    
    __weak IBOutlet UIButton *_btnNext;

}

@end

@implementation QLRegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:YES];
    [self loadDefaultSetting];
}

/** Load the default UI elements And prepare some datas needed. */
- (void)loadDefaultSetting {
    [self setTitle:@"新用户注册"];
    self.leftBtn.hidden = NO;
                                                       

    [_btnGetCode setCornerRadius:QLCornerRadius];
    _timeWaiting = totalTime;
    [_txfPwd setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
    [_txfCode setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
    [_txfPhone setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
    [_txfPwdConfirm setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
    [_btnNext setCornerRadius:10 border:1 borderColor:[UIColor whiteColor]];
    _txfPhone.text = @"15209214336";
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textFiledEditChanged:) name:@"UITextFieldTextDidChangeNotification"
                                              object:_txfPwd];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textFiledEditChanged:) name:@"UITextFieldTextDidChangeNotification"
                                              object:_txfPwdConfirm];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textFiledEditChanged:) name:@"UITextFieldTextDidChangeNotification"
                                              object:_txfCode];
    
}
- (void)textFiledEditChanged:(NSNotification *)notifi{
    if (_txfPwd) {
        if (_txfPwd.text.length > PasswordInputLengthMax) {
            _txfPwd.text = [_txfPwd.text substringToIndex:PasswordInputLengthMax];
        }
    }
    if (_txfPwdConfirm) {
        if (_txfPwdConfirm.text.length > PasswordInputLengthMax) {
            _txfPwdConfirm.text = [_txfPwdConfirm.text substringToIndex:PasswordInputLengthMax];
        }
    }
    if (_txfCode) {
        if (_txfCode.text.length > 6) {
            _txfCode.text = [_txfCode.text substringToIndex:6];
        }
    }
    
}
#pragma mark - Actions
//获取二维码
- (IBAction)requestCode {
    [self.view endEditing:YES];
    if (![NSString isPhoneNumber:_txfPhone.text]) {
        [QLHUDTool showErrorWithStatus:@"手机号格式不正确"];
        return;
    }
    [self verifyCodeRrequest];
    return ;
//    [QLHttpTool getWithBaseUrl:strUrl Parameters:dicParams whenSuccess:(AFHTTPRequestOperation *operation, id responseObject)^{
//    } whenFailure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        NSInteger statusCode = operation.response.statusCode;
//        if (statusCode == 200) {
//            NSString *strResponse = operation.responseString;
//            strResponse = [strResponse componentsSeparatedByString:@","][1];
//            NSString *code = [[strResponse componentsSeparatedByString:@"\n"] firstObject];
//            if ([code isEqualToString:@"0"]) {
//                QLLog(@"%@", @"验证码发送成功");
//                [QLHUDTool showAlertMessage:@"验证码发送成功"];
//                _timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updateTimeWaiting) userInfo:nil repeats:YES];
//                _btnGetCode.enabled = NO;
//            } else {
//                QLLog(@"验证码发送失败:code:%@", code);
//            }
//        } else {
//            QLLog(@"验证码发送失败,statusCode:%zd", statusCode);
//        }
//    }];
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
//验证短信验证码是否正确
- (IBAction)btnNext {
//    QLRegisterFinisheInfoVC *finishedVC = [[QLRegisterFinisheInfoVC alloc]init];
//    finishedVC.strCode = _code;
//    [[QLHttpTool getCurrentVC].navigationController pushViewController:finishedVC animated:YES];
//    return ;

    if ([self checkInput] == NO) {
        return;
    }
    [self registerUser];
}


- (void)registerUser {
    if ([_code isEqualToString:_txfCode.text]) {
        QLRegisterFinisheInfoVC *finishedVC = [[QLRegisterFinisheInfoVC alloc]init];
        finishedVC.strCode = _code;
        finishedVC.userPwd = _txfPwdConfirm.text;
        finishedVC.userTel = _txfPhone.text;
        [[QLHttpTool getCurrentVC].navigationController pushViewController:finishedVC animated:YES];
    }else{
        [QLHUDTool showAlertMessage:@"验证码不正确，请重新输入"];
    }
}

- (BOOL)checkInput {
    if ([_txfPhone.text isEmptyString]) {
        [QLHUDTool showErrorWithStatus:@"请输入手机号"];
        return NO;
    }
    if (![NSString isPhoneNumber:_txfPhone.text]) {
        [QLHUDTool showErrorWithStatus:@"手机号格式不正确"];
        return NO;
    }
    if ([_txfPwd.text isEmptyString]) {
        [QLHUDTool showAlertMessage:@"请输入密码"];
        return NO;
    }
    if (_txfPwd.text.length < 6 || _txfPwd.text.length > 16) {
        [QLHUDTool showErrorWithStatus:@"密码长度6-16个字符"];
        return NO;
    }

    if([_txfPwdConfirm.text isEmptyString]){
        [QLHUDTool showAlertMessage:@"请输入确认密码"];
        return NO;
    }
    if (![_txfPwd.text isEqualToString:_txfPwdConfirm.text]) {
        [QLHUDTool showErrorWithStatus:@"两输入密码不一致"];
        return NO;
    }
    if ([_txfCode.text isEmptyString]) {
        [QLHUDTool showAlertMessage:@"请输入验证码"];
        return NO;
    }
//    if (_txfCode.text.length != 6) {
//        [QLHUDTool showErrorWithStatus:@"请输入正确的验证码"];
//        return NO;
//    }
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
- (void)verifyCodeRrequest{
    
    NSString *strBaseUrl = [NSString stringWithFormat:@"%@%@?tel=%@", QLBaseUrlString, getVirifyCode_interface,_txfPhone.text];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//    manager.securityPolicy = [self customSecurityPolicy1];
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject: @"text/html"];
   
    [QLHUDTool showLoading];
    [manager GET:strBaseUrl parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        QLLog(@"code== %@",responseObject);
        if([responseObject objectForKey:@"success"]&&[[responseObject objectForKey:@"success"] boolValue]){
            //请求成功
            _code = [NSString stringWithFormat:@"%@",[responseObject[@"smsCode"] stringValue]];
            [QLHUDTool showAlertMessage:@"验证码发送成功"];
            _timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updateTimeWaiting) userInfo:nil repeats:YES];
            _btnGetCode.enabled = NO;
            [_txfCode becomeFirstResponder];
            [QLHUDTool dissmis];
            
        }else if([responseObject objectForKey:@"err_code"]&&[[responseObject objectForKey:@"err_code"] isEqualToString:@"cookie_fail"]){
            [QLHUDTool dissmis];
        }else{
            if([responseObject objectForKey:@"err_code"]&&[[responseObject objectForKey:@"err_code"] isEqualToString:@"ng"]){
                //请求错误(服务器错误)
                [QLHUDTool showErrorWithStatus:[responseObject objectForKey:@"err_msg"]];
                QLLog(@"错误信息== %@",[responseObject objectForKey:@"err_msg"]);
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [QLHUDTool showErrorWithStatus:@"请求失败,请稍后再试"];
    }];
}

@end
