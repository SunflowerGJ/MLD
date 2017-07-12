//
//  KSAutoFootRefreshView.m
//  DLSlideViewDemo
//
//  Created by kn on 15/5/6.
//  Copyright (c) 2015年 dongle. All rights reserved.
//

#import "KSAutoFootRefreshView.h"



#define KSFootRefreshView_T_1 @"加载更多数据"

#define KSFootRefreshView_T_3 @""
#define KSFootRefreshView_T_4 @"已无更新的数据"

@interface KSAutoFootRefreshView ()

@property (nonatomic,assign)BOOL isplay;
@property (nonatomic, strong) UIImageView             * indicatorView;
@property (nonatomic, strong) UIImageView             * arrowImageView;

@end

@implementation KSAutoFootRefreshView
@synthesize isLastPage = _isLastPage;

- (instancetype)init
{
    self = [super init];
    if (self) {
//        self.indicatorView        = [[UIActivityIndicatorView alloc] init];
//        self.indicatorView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
//        self.indicatorView.center = CGPointMake(KS_SCREEN_WIDTH / 2, KSRefreshView_Height / 2);
//        self.indicatorView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
//        
//        
//        self.titleLabel                 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, KS_SCREEN_WIDTH, KSRefreshView_Height)];
//        self.titleLabel.font            = [UIFont systemFontOfSize:16];
//        self.titleLabel.textColor       = [UIColor darkGrayColor];
//        self.titleLabel.backgroundColor = [UIColor clearColor];
//        self.titleLabel.textAlignment   = NSTextAlignmentCenter;
//        self.titleLabel.text            = KSFootRefreshView_T_1;
//        self.titleLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
//        
//        [self addSubview:self.titleLabel];
//        [self addSubview:self.indicatorView];
//        
//        self.hidden = YES;
        self.arrowImageView       = [[UIImageView alloc] initWithFrame:CGRectMake(self.frame.size.width/2, 8, 26.5, 40.5)];
        self.arrowImageView.image = [UIImage imageNamed:@"loading_huo_ico.png"];
        
        self.indicatorView       = [[UIImageView alloc] initWithFrame:CGRectMake(self.frame.size.width/2-15, 0, 55, 55)];
        self.indicatorView.image = [UIImage imageNamed:@"loading_yuan_ico.png"];
        
        
        CABasicAnimation *monkeyAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
        monkeyAnimation.toValue = [NSNumber numberWithFloat:2.0 *M_PI];
        monkeyAnimation.duration = 1.5f;
        monkeyAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
        monkeyAnimation.cumulative = NO;
        monkeyAnimation.removedOnCompletion = NO; //No Remove
        
        monkeyAnimation.repeatCount = FLT_MAX;
        [self.indicatorView.layer addAnimation:monkeyAnimation forKey:@"AnimatedKey"];
        [self.indicatorView stopAnimating];
        
        // 加载动画 但不播放动画
        self.indicatorView.layer.speed = 0.0;
        
        [self addSubview:self.arrowImageView];
        [self addSubview:self.indicatorView];

    }
    return self;
}

-(void)start{
    if (!_isplay) {
        _isplay = YES;
        self.indicatorView.layer.speed = 1.0;
        self.indicatorView.layer.beginTime = 0.0;
        CFTimeInterval pausedTime = [self.indicatorView.layer timeOffset];
        CFTimeInterval timeSincePause = [self.indicatorView.layer convertTime:CACurrentMediaTime() fromLayer:nil] - pausedTime;
        self.indicatorView.layer.beginTime = timeSincePause;
    }
}

-(void)stop{
    //DLog(@".....");
    if (_isplay) {
        _isplay = NO;
        CFTimeInterval pausedTime = [self.indicatorView.layer convertTime:CACurrentMediaTime() fromLayer:nil];
        self.indicatorView.layer.speed = 0.0;
        self.indicatorView.layer.timeOffset = pausedTime;
    }
}


- (void)setIsLastPage:(BOOL)isLastPage
{
    if (isLastPage) {
        
        [self setValue:@(RefreshViewStateDefault) forKeyPath:@"_state"];
     
        [self.indicatorView stopAnimating];
        
        UIEdgeInsets ei = self.targetView.contentInset;
        
        ei.bottom = self.targetViewOriginalEdgeInsets.bottom + KSRefreshView_Height;
        
        self.targetView.contentInset = ei;
        
    } else {
       
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
            [self stop];
            
            break;
        }
        case RefreshViewStateVisible:
        case RefreshViewStateTriggered:
        case RefreshViewStateLoading:
        {
//            [self.titleLabel setText:KSFootRefreshView_T_3];
            [self start];
            
            UIEdgeInsets ei = self.targetView.contentInset;
            
            ei.bottom = self.targetViewOriginalEdgeInsets.bottom + KSRefreshView_Height;
            
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
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionAllowUserInteraction|UIViewAnimationOptionBeginFromCurrentState animations:^{
        self.targetView.contentInset = contentInset;
    } completion:^(BOOL finished) {
        
    }];
}


@end
