
//
//  QLClassHome.m
//  QLMLD
//
//  Created by 英英 on 2017/7/2.
//  Copyright © 2017年 Shreker. All rights reserved.
//

#import "QLClassHome.h"

@interface QLClassHome (){
    
    IBOutlet UIView *_viewCustomTitle;
}

@end

@implementation QLClassHome

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadDefaultSetting];
}
- (void)loadDefaultSetting{
    
//    self.rightBtn.hidden = NO;
//    self.rightBtn.frame= CGRectMake(QLScreenWidth-60, 28, 60, 30);
//    [self.rightBtn setImage:[UIImage imageNamed:@"camera_icon"] forState:UIControlStateNormal];
    
    UIView *viewRight = [[UIView alloc]init];
    self.titleView = _viewCustomTitle;
    
    /*
    UIButton *right = [UIButton buttonWithType:UIButtonTypeCustom];
    [right setImage:[UIImage imageNamed:@"camera_icon"] forState:UIControlStateNormal];
    [viewRight addSubview:right];
    [right mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(viewRight).offset(0);
        make.width.equalTo(@60);
        make.height.equalTo(@30);
    }];
    UIImageView *line = [[UIImageView alloc]init];
    [viewRight addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(right).offset(5);
        make.width.equalTo(@0.5);
        make.topMargin.equalTo(right);
        make.bottomMargin.equalTo(right);
    }];
    line.backgroundColor = [UIColor whiteColor];
    
    UIButton *left = [UIButton buttonWithType:UIButtonTypeCustom];
    [left setImage:[UIImage imageNamed:@"share_icon"] forState:UIControlStateNormal];
    [viewRight addSubview:left];
    [left mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(viewRight).offset(5);
        make.width.equalTo(right);
        make.height.equalTo(right);
        make.centerY.equalTo(right);
    }];

    
    [viewRight mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.titleView).offset(15);
        make.centerY.equalTo(self.titleView).offset(40);
    }];
    
*/
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
