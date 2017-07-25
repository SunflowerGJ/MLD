//
//  QLAdmissionPublishVC.m
//  QLMLD
//
//  Created by syy on 2017/7/25.
//  Copyright © 2017年 Shreker. All rights reserved.
//  成长印记 发布

#import "QLAdmissionPublishVC.h"

@interface QLAdmissionPublishVC ()

@end

@implementation QLAdmissionPublishVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - data Request
- (void)dataPublish {
    NSString *strBaseUrl = [NSString stringWithFormat:@"%@%@",QLBaseUrlString,admissionPublish_interface];
    NSString *theme = [NSString getValidStringWithObject:nil];
    NSString *photo = [NSString getValidStringWithObject:nil];
    NSString *isTeacher = @"1";
    NSDictionary *dicParam = @{@"sign_theme":theme,@"sign_photo":photo,@"is_teacher":isTeacher};
    [QLHttpTool postWithBaseUrl:strBaseUrl Parameters:dicParam whenSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
    } whenFailure:^{
        
    }];
}
@end
