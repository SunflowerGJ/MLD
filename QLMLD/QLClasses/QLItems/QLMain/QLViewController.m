//
//  QLViewController.m
//  LiChi
//  ViewController公共类,继承后实现自定义navigationBar
//  Created by Shrek on 16/4/12.
//  Copyright © 2016年 cn.forp.app. All rights reserved.
//

#import "QLViewController.h"

@interface QLViewController ()

@end

@implementation QLViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.titleView addSubview:self.titleLabel];
    
    [self.titleView addSubview:self.leftBtn];
    
    [self.titleView addSubview:self.rightBtn];
    
    [self.titleView addSubview:self.bottomLine];

    [self.view addSubview:self.titleView];
    self.view.backgroundColor = QLBackGroundColor;
    
    //提示控件
    [self.promptView addSubview:self.promptImg];
    [self.promptView addSubview:self.promptL];
    [self.promptView addSubview:self.clickBtn];
    
    self.promptView.hidden = YES;
    self.clickBtn.hidden = YES;
    
    //防止电池栏向下20像素
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    topView.backgroundColor = [UIColor clearColor];
    [self.view insertSubview:topView atIndex:0];
}

//头部View
- (UIView *)titleView
{
    if (_titleView == nil) {
        _titleView= [[UIView alloc] initWithFrame:CGRectMake(0, 0, QLScreenWidth, 64)];
        _titleView.backgroundColor = QLYellowColor;
    }
    return _titleView;
}

//页面TItile
- (UILabel *)titleLabel
{
    if (_titleLabel == nil) {
        _titleLabel= [[UILabel alloc] initWithFrame:CGRectMake(75, 32, QLScreenWidth-150, 21)];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.textColor = QLFontDarkColor;
        _titleLabel.font = [UIFont systemFontOfSize:16.0];
    }
    
    return _titleLabel;
}

//左边按钮
- (UIButton *)leftBtn
{
    if (_leftBtn == nil) {
        _leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _leftBtn.frame = CGRectMake(0, 28, 50, 30);
        [_leftBtn setImage:[UIImage imageNamed:@"arrowl.png"]  forState:UIControlStateNormal];
//        [_leftBtn setImage:[UIImage imageNamed:@"arrowpress.png"]  forState:UIControlStateHighlighted];
        _leftBtn.backgroundColor = [UIColor clearColor];
        _leftBtn.titleLabel.font = [UIFont systemFontOfSize:17.0];
        _leftBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        [_leftBtn addTarget:self action:@selector(clickBack) forControlEvents:UIControlEventTouchUpInside];
    }
    return _leftBtn;
}

//右边按钮
- (UIButton *)rightBtn
{
    if (_rightBtn == nil) {
        _rightBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        _rightBtn.frame = CGRectMake(QLScreenWidth-40, 28, 30, 30);
        _rightBtn.tintColor = [UIColor whiteColor];
        _rightBtn.backgroundColor = [UIColor clearColor];
        _rightBtn.titleLabel.font = [UIFont systemFontOfSize:17.0];
        [_rightBtn addTarget:self action:@selector(clickRight) forControlEvents:UIControlEventTouchUpInside];
        _rightBtn.hidden = YES;
    }
    return _rightBtn;
}

//底部分割线
- (UIView *)bottomLine
{
    if (_bottomLine == nil) {
        _bottomLine= [[UIView alloc] initWithFrame:CGRectMake(0, 63.5, QLScreenWidth, 0.5)];
        _bottomLine.backgroundColor = QLDividerColor;
    }
    return _bottomLine;
}

//提示View
- (UIView *)promptView
{
    if (_promptView == nil) {
        _promptView= [[UIView alloc] initWithFrame:CGRectMake(20, 110, QLScreenWidth-40, 180)];
        _promptView.backgroundColor = [UIColor clearColor];
    }
    return _promptView;
}

//提示图片
- (UIImageView *)promptImg
{
    if (_promptImg == nil) {
        _promptImg = [[UIImageView alloc] initWithFrame:CGRectMake((self.promptView.frame.size.width-64)/2, 0, 64, 64)];
        _promptImg.image = [UIImage imageNamed:@"failure"];
    }
    return _promptImg;
}

//提示文字
- (UILabel *)promptL
{
    if (_promptL == nil) {
        _promptL = [[UILabel alloc] initWithFrame:CGRectMake(0, 64, self.promptView.frame.size.width, 70)];
        _promptL.textColor = QLFontShallowColor;
        _promptL.textAlignment = NSTextAlignmentCenter;
        _promptL.font = [UIFont systemFontOfSize:15.0];
        _promptL.numberOfLines = 0;
    }
    return _promptL;
}

//提示按钮
- (UIButton *)clickBtn
{
    if (_clickBtn == nil) {
        _clickBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        _clickBtn.frame = CGRectMake(0, 140, self.promptView.frame.size.width, 40);
        _clickBtn.backgroundColor = QLYellowColor;
        _clickBtn.titleLabel.font = [UIFont systemFontOfSize:15.0];
        _clickBtn.layer.cornerRadius = QLButtonRadius;
        _clickBtn.tintColor = [UIColor whiteColor];
        [_clickBtn setTitle:@"去发货" forState:UIControlStateNormal];
        _clickBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        [_clickBtn addTarget:self action:@selector(clickPrompt) forControlEvents:UIControlEventTouchUpInside];
    }
    return _clickBtn;
}

//设置title文字
-(void)setTitle:(NSString *)title{
    [super setTitle:title];
    self.titleLabel.text = title;
    self.titleLabel.textColor = [UIColor whiteColor];
}

//左边按钮点击事件,自定义事件需要重写此方法
- (void)clickBack
{
    [self.navigationController popViewControllerAnimated:YES];
}

//右边按钮点击事件,自定义事件需要重写此方法
- (void)clickRight
{
    
}

//提示按钮点击事件,自定义事件需要重写此方法
- (void)clickPrompt
{
    
}

//无内容调用
- (void)promptNoContent{
    self.promptView.hidden = NO;
    self.clickBtn.hidden = YES;
    self.promptL.text =@"暂无内容";
}
//无网络调用
- (void)promptNoNetwork{
    self.promptView.hidden = NO;
    self.clickBtn.hidden = YES;
    self.promptL.text =@"哎呦 ! 网络出问题了";
}
//无订单调用
- (void)promptNoOrder{
    self.promptView.hidden = NO;
    self.clickBtn.hidden = NO;
    self.promptL.text =@"您当前还没有运单\n现在就去发货吧!";
}

//隐藏调用
- (void)promptHidden{
    self.promptView.hidden = YES;
    self.clickBtn.hidden = YES;
}

@end
