//
//  QLViewController.h
//  LiChi
//
//  Created by Shrek on 16/4/12.
//  Copyright © 2016年 cn.forp.app. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QLViewController : UIViewController

@property(nonatomic,strong) UIButton *leftBtn;
@property(nonatomic,strong) UIButton *rightBtn;
@property(nonatomic,strong) UILabel *titleLabel;
@property(nonatomic,strong) UIView *titleView;
@property(nonatomic,strong) UIView *bottomLine;

//提示显示
@property(nonatomic,strong) UIView *promptView;
@property(nonatomic,strong) UIImageView *promptImg;
@property(nonatomic,strong) UILabel *promptL;
@property(nonatomic,strong) UIButton *clickBtn;

- (void)clickBack;
- (void)clickRight;
- (void)clickPrompt;
//无内容调用
- (void)promptNoContent;
//无网络调用
- (void)promptNoNetwork;
//无订单调用
- (void)promptNoOrder;
//隐藏调用
- (void)promptHidden;
@end
