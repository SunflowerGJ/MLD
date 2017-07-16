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
    [_btnNext setCornerRadius:10 border:1 borderColor:[UIColor whiteColor]];
    _txfPhone.text = @"15209214336";
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
    
    QLRegisterFinisheInfoVC *fininshedVC = [[QLRegisterFinisheInfoVC alloc]init];
    [[QLHttpTool getCurrentVC].navigationController pushViewController:fininshedVC animated:YES];
    
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


- (void)verifyCodeRrequest{
    
    NSString *strBaseUrl = [NSString stringWithFormat:@"%@%@", QLBaseUrlString, getVirifyCode_interface];
    
    NSDictionary *dicParams = @{@"user_tel":_txfPhone.text};
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//    manager.securityPolicy = [self customSecurityPolicy1];
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject: @"text/html"];
    //单点登录
    QLUserModel *userModel = [QLUserTool sharedUserTool].userModel;
    NSString *strUserId = userModel.strId;
    NSMutableDictionary *copyDicParams;
    if (strUserId) {
        //如果用户登录的情况下,传入userid和cookie参数
        if(dicParams){
            copyDicParams = [[NSMutableDictionary alloc] initWithDictionary:dicParams] ;
        }else{
            copyDicParams =[[NSMutableDictionary alloc] init] ;
        }
        [copyDicParams setObject:strUserId forKey:@"userid"];
        [copyDicParams setObject:[[UIDevice currentDevice].identifierForVendor UUIDString] forKey:@"cookie"];
    }
    [self loadCredencialForManager:manager];
    [QLHUDTool showLoading];
    [manager POST:strBaseUrl parameters:strUserId?copyDicParams:dicParams success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if([responseObject objectForKey:@"err_code"]&&[[responseObject objectForKey:@"err_code"] isEqualToString:@"ok"]){
            //请求成功
            _code = responseObject[@"checkno"];
            //            _tfVerifyCode.text = _code;
            [QLHUDTool showAlertMessage:@"验证码发送成功"];
            _timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updateTimeWaiting) userInfo:nil repeats:YES];
            _btnGetCode.enabled = NO;
            [_txfCode becomeFirstResponder];
            [QLHUDTool dissmis];
            
        }else if([responseObject objectForKey:@"err_code"]&&[[responseObject objectForKey:@"err_code"] isEqualToString:@"cookie_fail"]){
            [QLHUDTool dissmis];
            if([QLUserTool sharedUserTool].userModel.strId){
                //清除登录信息
                [GeTuiSdk unbindAlias:[QLUserTool sharedUserTool].userModel.strAccount andSequenceNum:KGtSeriNum];
                [[QLUserTool sharedUserTool] clearCurrentUserModel];
                [Tools setCache:SHIPPER_BADGE data:@""];
                [Tools setCache:DRIVER_BADGE data:@""];
                //被踢下线,这里清除用户登录信息
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"当前账号在其他地方登录，被迫下线..." delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alertView show];
            }
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
- (void)loadCredencialForManager:(AFHTTPRequestOperationManager *)manager {
    QLUserModel *user = [QLUserTool sharedUserTool].userModel;
//    if (user) {
//        NSURLCredential *urlCredential = [[NSURLCredential alloc] initWithUser:user.strAccount password:user.strPwd persistence:NSURLCredentialPersistenceForSession];
//        [manager setCredential:urlCredential];
//    }
}
@end
