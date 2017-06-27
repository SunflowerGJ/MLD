//
//  QLFillCodeViewController.m
//  HeartNet
//
//  Created by Shrek on 15/12/16.
//  Copyright © 2015年 Shreker. All rights reserved.
//

#import "QLFillCodeViewController.h"
#import "QLSetNewViewController.h"

static const NSUInteger totalTime = 120;

@interface QLFillCodeViewController ()
{
    __weak IBOutlet UITextField *_txfCode;
    __weak IBOutlet UILabel *_lblPhone;
    __weak IBOutlet UIButton *_btnGetCode;
    __weak IBOutlet UILabel *_lblTime;
    
    NSTimer *_timer;
    NSInteger _timeWaiting;
}

@end

@implementation QLFillCodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadDefaultSetting];
    [self requestSendPwd];
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

/** Load the default UI elements And prepare some datas needed. */
- (void)loadDefaultSetting {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 20)];
    _txfCode.leftView = view;
    _txfCode.leftViewMode = UITextFieldViewModeAlways;
    
    _lblPhone.text = [self.strPhone stringByReplacingCharactersInRange:NSMakeRange(3, 4) withString:@"****"];;
    _timeWaiting = totalTime;
}

#pragma mark - Actions
- (IBAction)next { // setNewPwd
    if (_txfCode.text.length != 6) {
        [QLHUDTool showErrorWithStatus:@"请输入正确的验证码"];
        return;
    }
    
    
}

#pragma mark - HTTP Request
- (IBAction)requestSendPwd {
    
}

- (void)updateTimeWaiting {
    [_lblTime setText:[NSString stringWithFormat:@"重新获取验证码(%zd秒)", -- _timeWaiting]];
    if (_timeWaiting <= 0) {
        [_timer invalidate];
        _timer = nil;
        NSString *strTemp = @"收不到验证码?重发短信获取验证码";
        NSMutableAttributedString *strMATemp = [[NSMutableAttributedString alloc] initWithString:strTemp];
        [strMATemp addAttribute:NSForegroundColorAttributeName value:[UIColor blueColor] range:[strTemp rangeOfString:@"重发短信"]];
        [_lblTime setAttributedText:strMATemp];
        _btnGetCode.enabled = YES;
        _timeWaiting = totalTime;
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"setNewPwd"]) {
        QLSetNewViewController *vcSetNew = segue.destinationViewController;
        vcSetNew.strId = self.strId;
    }
}

@end
