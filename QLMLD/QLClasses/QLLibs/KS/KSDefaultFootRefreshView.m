//
//  KSDefaultFootRefreshView.m
//  DLSlideViewDemo
//
//  Created by kn on 15/5/6.
//  Copyright (c) 2015年 dongle. All rights reserved.
//

#import "KSDefaultFootRefreshView.h"

#define KSFootRefreshView_T_1 @"加载中... "
#define KSFootRefreshView_T_2 @"加载中..."
#define KSFootRefreshView_T_3 @"加载中..."
#define KSFootRefreshView_T_4 @"没有更多数据..."
@interface KSDefaultFootRefreshView ()

@property (nonatomic, strong) UIImageView             * indicatorView;
@property (nonatomic, strong) UIImageView             * arrowImageView;
@property (nonatomic, strong) UILabel                 * titleLabel;

@end
@implementation KSDefaultFootRefreshView

@synthesize isLastPage = _isLastPage;

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.indicatorView       = [[UIImageView alloc] initWithFrame:CGRectMake(self.frame.size.width/2-22, 9, 44, 44)];
        self.indicatorView.image = [UIImage imageNamed:@"loading_yuan_ico.png"];
        
        self.arrowImageView       = [[UIImageView alloc] initWithFrame:CGRectMake(self.frame.size.width/2-8.5, 23, 16.2, 24)];
        self.arrowImageView.image = [UIImage imageNamed:@"loading_huo_ico.png"];
        self.indicatorView.alpha=0;
        self.arrowImageView.alpha=0;
        CABasicAnimation *monkeyAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
        monkeyAnimation.toValue = [NSNumber numberWithFloat:2.0 *M_PI];
        monkeyAnimation.duration = 1.5f;
        monkeyAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
        monkeyAnimation.cumulative = NO;
        monkeyAnimation.removedOnCompletion = NO; //No Remove
        
        monkeyAnimation.repeatCount = FLT_MAX;
        [self.indicatorView.layer addAnimation:monkeyAnimation forKey:@"AnimatedKeyFoot"];
        
        // 加载动画 但不播放动画
        self.indicatorView.layer.speed = 0.0;
        
        
        self.titleLabel                 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 50)];
        self.titleLabel.font            = [UIFont boldSystemFontOfSize:13];
        self.titleLabel.textColor       = [UIColor colorWithRed:(150)/255.0 green:(150)/255.0 blue:(150)/255.0 alpha:1.0];
        self.titleLabel.backgroundColor = [UIColor clearColor];
        self.titleLabel.textAlignment   = NSTextAlignmentCenter;
        self.titleLabel.text            = KSFootRefreshView_T_1;
        //self.titleLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        
        [self addSubview:self.titleLabel];
        //[self addSubview:self.indicatorView];
        //[self addSubview:self.arrowImageView];
        self.hidden = YES;
    }
    return self;
}

- (void)setIsLastPage:(BOOL)isLastPage
{
    if (isLastPage) {
        
        [self setValue:@(RefreshViewStateDefault) forKeyPath:@"_state"];
        [self.titleLabel setText:KSFootRefreshView_T_4];
        [self stop];
        UIEdgeInsets ei = self.targetView.contentInset;
        
        ei.bottom = self.targetViewOriginalEdgeInsets.bottom + 50;
        
        self.targetView.contentInset = ei;
        
    } else {
        [self.titleLabel setText:KSFootRefreshView_T_1];
    }
    
    _isLastPage = isLastPage;
}

- (void)setState:(RefreshViewState)state
{
    if (_isLastPage) {
        return;
    }
    
    [super setState:state];
    
    switch (state) {
        case RefreshViewStateDefault:
        {
            [self.titleLabel setText:KSFootRefreshView_T_1];
            [self stop];
            UIEdgeInsets ei = self.targetView.contentInset;
            
            ei.bottom = self.targetViewOriginalEdgeInsets.bottom + 50;
            
            [self setScrollViewContentInset:ei];
            
            break;
        }
        case RefreshViewStateVisible:
        {
            [self.titleLabel setText:KSFootRefreshView_T_1];
            [self stop];
            UIEdgeInsets ei = self.targetView.contentInset;
            
            ei.bottom = self.targetViewOriginalEdgeInsets.bottom + 50;
            
            [self setScrollViewContentInset:ei];
            
            break;
        }
        case RefreshViewStateTriggered:
        {
            [self.titleLabel setText:KSFootRefreshView_T_2];
            break;
        }
        case  RefreshViewStateLoading:
        {
            [self.titleLabel setText:KSFootRefreshView_T_3];
            [self start];
            UIEdgeInsets ei = self.targetView.contentInset;
            
            ei.bottom = self.targetViewOriginalEdgeInsets.bottom + 50;
            
            [self setScrollViewContentInset:ei];
            
            if ([self.delegate respondsToSelector:@selector(refreshViewDidLoading:)]) {
                [self.delegate refreshViewDidLoading:self];
            }
            
            break;
        }
    }
}

- (void)setScrollViewContentInset:(UIEdgeInsets)contentInset
{
    self.targetView.contentInset = contentInset;
//    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionAllowUserInteraction|UIViewAnimationOptionBeginFromCurrentState animations:^{
//        
//    } completion:^(BOOL finished) {
//        
//    }];
}


-(void)start{
    self.indicatorView.alpha=1;
    self.arrowImageView.alpha=1;
        self.indicatorView.layer.speed = 1.0;
        self.indicatorView.layer.beginTime = 0.0;
        CFTimeInterval pausedTime = [self.indicatorView.layer timeOffset];
        CFTimeInterval timeSincePause = [self.indicatorView.layer convertTime:CACurrentMediaTime() fromLayer:nil] - pausedTime;
        self.indicatorView.layer.beginTime = timeSincePause;
}

-(void)stop{
    self.indicatorView.alpha=0;
    self.arrowImageView.alpha=0;
        CFTimeInterval pausedTime = [self.indicatorView.layer convertTime:CACurrentMediaTime() fromLayer:nil];
        self.indicatorView.layer.speed = 0.0;
        self.indicatorView.layer.timeOffset = pausedTime;
}

@end
