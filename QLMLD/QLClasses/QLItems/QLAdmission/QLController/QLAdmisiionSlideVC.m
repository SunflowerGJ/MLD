//
//  QLAdmisiionSlideVC.m
//  QLMLD
//
//  Created by 英英 on 2017/7/23.
//  Copyright © 2017年 Shreker. All rights reserved.
//

#import "QLAdmisiionSlideVC.h"

@interface QLAdmisiionSlideVC ()

@end

@implementation QLAdmisiionSlideVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//点击背景
- (IBAction)clickBackGround:(id)sender {
    [self stopAnimation];
}

//开始动画
-(void)startAnimation{
    self.backGroundView.alpha = 0 ;
    self.mainView.frame = CGRectMake(-QLScreenWidth+60, 0, QLScreenWidth-60, QLScreenHeight);
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationSlide];
    [UIView animateWithDuration:0.35 delay:0 options:UIViewAnimationOptionAllowUserInteraction animations:^{
        self.backGroundView.alpha = 0.3;
        self.mainView.frame = CGRectMake(0, 0, QLScreenWidth-60, QLScreenHeight);
    } completion:^(BOOL finished) {
        
    }];
}
//结束动画
-(void)stopAnimation{
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationSlide];
    [UIView animateWithDuration:0.35 delay:0 options:UIViewAnimationOptionAllowUserInteraction animations:^{
        self.backGroundView.alpha = 0;
        self.mainView.frame = CGRectMake(-QLScreenWidth+60, 0, QLScreenWidth-60, QLScreenHeight);
    } completion:^(BOOL finished) {
        [self.view removeFromSuperview];
    }];
}
@end
