//
//  QLAdmissionEditVC.m
//  QLMLD
//
//  Created by 英英 on 2017/7/30.
//  Copyright © 2017年 Shreker. All rights reserved.
//

#import "QLAdmissionEditVC.h"

@interface QLAdmissionEditVC (){
    
    __weak IBOutlet UITextView *_textContent;
}

@end

@implementation QLAdmissionEditVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadDefaultSetting];
}
- (void)loadDefaultSetting {
    self.title = @"添加描述";
    self.rightBtn.hidden = NO;
    self.rightBtn.frame = CGRectMake(QLScreenWidth-60, 28, 45, 30);
    [self.rightBtn setTitle:@"确认" forState:UIControlStateNormal];
}
- (void)clickRight{
    NSString *strBaseUrl = [NSString stringWithFormat:@"%@%@",QLBaseUrlString,admissionAddOrUpdate_interface];
    
    NSDictionary *dic = @{@"sign_detail_id":@"",@"sign_id":@"",@"sign_detail_remark":@"",@"sign_photo":@""};
    [QLHttpTool postWithBaseUrl:strBaseUrl Parameters:dic whenSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        self.blockSuccess();
        
        [[QLHttpTool getCurrentVC].navigationController popViewControllerAnimated:YES];
    } whenFailure:^{
        
    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
