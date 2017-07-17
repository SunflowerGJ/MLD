//
//  QLWebViewController.m
//  QLMLD
//
//  Created by 英英 on 2017/7/17.
//  Copyright © 2017年 Shreker. All rights reserved.
//

#import "QLWebViewController.h"

@interface QLWebViewController (){
    
    __weak IBOutlet UIWebView *_webview;
}

@end

@implementation QLWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [_webview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.baidu.com"]]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
