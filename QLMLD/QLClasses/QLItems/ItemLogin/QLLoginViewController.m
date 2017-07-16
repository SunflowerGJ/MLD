//
//  QLLoginViewController.m
//  HeartNet
//
//  Created by Shrek on 15/12/9.
//  Copyright © 2015年 Shreker. All rights reserved.
//

#import "QLLoginViewController.h"
#import "QLRegisterViewController.h"
#import "QLAppDelegate.h"
#import "QLForgetPWDViewController.h"

/** User */
static NSString * const QLKeyUserShouldRememberLoginName = @"QLKeyUserShouldRememberLoginName";

@interface QLLoginViewController ()
{
    __weak IBOutlet UITextField *_txfTele;
    __weak IBOutlet UITextField *_txfPwd;
    __weak IBOutlet UIButton *_btnLogin;
    __weak IBOutlet UIButton *_btnRememberUser;
    __weak IBOutlet UIButton *_btnForgetPwd;
    __weak IBOutlet UIButton *_btnRegister;    
    __weak IBOutlet UIView *_viewContent;
    __weak IBOutlet UILabel *_lblProtocal;
}

@property (nonatomic, assign) BOOL shouldRememberLoginName;

@end

@implementation QLLoginViewController

- (BOOL)shouldRememberLoginName {
    if (!_shouldRememberLoginName) {
        _shouldRememberLoginName = [[NSUserDefaults standardUserDefaults] boolForKey:QLKeyUserShouldRememberLoginName];
    }
    return _shouldRememberLoginName;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadDefaultSetting];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO];
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
//    if (_txfTele.text.length <= 0) {
//        [_txfTele becomeFirstResponder];
//    } else if (_txfPwd.text.length <= 0) {
//        [_txfPwd becomeFirstResponder];
//    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

/** Load the default UI elements And prepare some datas needed. */
- (void)loadDefaultSetting {
    self.title = @"登录";
    self.view.layer.contents = (id)[UIImage imageNamed:@"img_login_bg"].CGImage;
    
    [_btnLogin setCornerRadius:QLCornerRadius border:QLBorderWidth borderColor:[UIColor whiteColor]];
    [_btnRegister setCornerRadius:QLCornerRadius border:QLBorderWidth borderColor:[UIColor whiteColor]];
    [_viewContent setCornerRadius:QLCornerRadius];
    
    if (self.shouldRememberLoginName) {
        _txfTele.text = [[NSUserDefaults standardUserDefaults] objectForKey:@""];
    }
    
    _btnRememberUser.selected = self.shouldRememberLoginName;
    NSMutableAttributedString *title = [[NSMutableAttributedString alloc] initWithString:_btnForgetPwd.titleLabel.text];
    NSRange titleRange = {0,[title length]};
    [title addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:titleRange];
    [_btnForgetPwd setAttributedTitle:title
                      forState:UIControlStateNormal];

    NSMutableAttributedString *content = [[NSMutableAttributedString alloc]initWithString:_lblProtocal.text];
    NSRange contentRange = {0,[content length]};
    [content addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:contentRange];
    _lblProtocal.attributedText = content;
    
    [_txfTele setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
    [_txfPwd setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];

}

#pragma mark - Actions

- (IBAction)login {
    QLAppDelegate *delegate = (QLAppDelegate *)[UIApplication sharedApplication].delegate;
    [delegate changeRootViewControllerToMain];

    NSString *strUser = _txfTele.text;
    if (strUser.length <= 0) {
        [QLHUDTool showErrorWithStatus:@"请输入用户名"];
        return;
    }
    
    NSString *strPwd = _txfPwd.text;
    if (strPwd.length <= 0) {
        [QLHUDTool showErrorWithStatus:@"请输入密码"];
        return;
    }

    //    [QLUserTool loginWithUser:_txfTele.text pwd:_txfPwd.text whenSuccess:^{
//        
//    } whenFailure:^{
//        
//    }];
    
}
//协议
- (IBAction)btnProtocal:(id)sender {
}

- (IBAction)registerUser {
    QLRegisterViewController *vcRegister = [QLRegisterViewController new];
    [self.navigationController pushViewController:vcRegister animated:YES];
}
- (IBAction)rememberUser:(UIButton *)button {
    button.selected = !button.selected;
    [[NSUserDefaults standardUserDefaults] setBool:button.selected forKey:QLKeyUserShouldRememberLoginName];
    [QLUserDefaults synchronize];
    [self.view endEditing:YES];
}
- (IBAction)forgetPwd {
    QLForgetPWDViewController *vcForgetPwd = [QLForgetPWDViewController new];
    [self.navigationController pushViewController:vcForgetPwd animated:YES];
}

- (IBAction)backAction {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)dealloc {
    QLLog(@"%@", @"");
}

@end
