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
    if ([_tfOldPwd.text isEmptyString]) {
        [QLHUDTool showAlertMessage:@"请输入旧密码"];
        return ;
    }
    if (_tfOldPwd.text.length<6 || _tfOldPwd.text.length>16) {
        [QLHUDTool showAlertMessage:@"密码长度6至16位"];
        return ;
    }
    if ([_tfNewPwd.text isEmptyString] || [_tfEnsurePwd.text isEmptyString]) {
        [QLHUDTool showAlertMessage:@"请输入新密码"];
        return ;
    }
    if ((_tfNewPwd.text.length<6 || _tfNewPwd.text.length>16)||(_tfEnsurePwd.text.length<6 || _tfEnsurePwd.text.length>16)) {
        [QLHUDTool showAlertMessage:@"密码长度6至16位"];
        return ;
    }
    if (![_tfNewPwd.text isEqualToString:_tfEnsurePwd.text]) {
        [QLHUDTool showAlertMessage:@"两次新密码输入不一致"];
        return ;
    }
    NSString *strUrl = [NSString stringWithFormat:@"%@%@",QLBaseUrlString,alterPwd_interface];
    NSData *dataOld = [[NSString stringWithFormat:@"%@",_tfOldPwd.text] dataUsingEncoding:NSUTF8StringEncoding];
    NSData *dataNew = [[NSString stringWithFormat:@"%@",_tfNewPwd.text] dataUsingEncoding:NSUTF8StringEncoding];
    
    NSDictionary *dic = @{@"oldPassword"
                          :[dataOld md5String],@"newPassword":[dataNew md5String]};
    [QLHUDTool showLoading];
    [QLHttpTool getWithBaseUrl:strUrl Parameters:dic whenSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        [QLHUDTool showAlertMessage:@"密码修改成功"];
        //密码修改成功后，跳至登录页
        [[QLUserTool sharedUserTool] logout];
        QLLog(@"alter pwd response: %@",responseObject);
    } whenFailure:^{
        
    }];
}


@end
