//
//  KSDefaultHeadRefreshView.m
//  DLSlideViewDemo
//
//  Created by kn on 15/5/6.
//  Copyright (c) 2015年 dongle. All rights reserved.
//

#import "KSDefaultHeadRefreshView.h"

@interface KSDefaultHeadRefreshView ()
@property (nonatomic,assign)BOOL isplay;
@property (nonatomic, strong) UIImageView             * indicatorView;
@property (nonatomic, strong) UIImageView             * arrowImageView;


@end

@implementation KSDefaultHeadRefreshView


- (instancetype)init
{
    self = [super init];
    if (self) {

        self.indicatorView       = [[UIImageView alloc] initWithFrame:CGRectMake(self.frame.size.width/2-30, 9, 60, 60)];
        self.indicatorView.image = [UIImage imageNamed:@"load_img_normal.png"];
       
        
        self.arrowImageView       = [[UIImageView alloc] initWithFrame:CGRectMake(self.frame.size.width/2-26, 12, 55, 55)];
        self.arrowImageView.image = [UIImage imageNamed:@"load2_img_normal.png"];

        
        CABasicAnimation *monkeyAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
        monkeyAnimation.toValue = [NSNumber numberWithFloat:(2 * M_PI) * -1];
        monkeyAnimation.duration = 1.0f;
        monkeyAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
        monkeyAnimation.cumulative = NO;
        monkeyAnimation.removedOnCompletion = NO; //No Remove
        
        monkeyAnimation.repeatCount = FLT_MAX;
        [self.indicatorView.layer addAnimation:monkeyAnimation forKey:@"AnimatedKey"];
        
        // 加载动画 但不播放动画
        self.indicatorView.layer.speed = 0.0;
        UIView *colorView = [[UIView alloc] initWithFrame:CGRectMake(0, -1000, self.frame.size.width, 1078)];
        
        [self addSubview:colorView];
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
    if (_isplay) {
        _isplay = NO;
        CFTimeInterval pausedTime = [self.indicatorView.layer convertTime:CACurrentMediaTime() fromLayer:nil];
        self.indicatorView.layer.speed = 0.0;
       self.indicatorView.layer.timeOffset = pausedTime;
    }
}

- (void)setState:(RefreshViewState)state
{
    [super setState:state];
    
    switch (state) {
        case RefreshViewStateDefault:
        {
            
            UIEdgeInsets curInsets = self.targetView.contentInset;
            curInsets.top = self.targetViewOriginalEdgeInsets.top;
            
            [self setScrollViewContentInset:curInsets];
            [self stop];
            [self rotateArrow:0 hide:YES];
            break;
        }
        case RefreshViewStateVisible:
        {
            [self rotateArrow:0 hide:YES];
            break;
        }
        case RefreshViewStateTriggered:
        {
            [self rotateArrow:0 hide:YES];
            break;
        }
        case  RefreshViewStateLoading:
        {

            [self start];
            
            UIEdgeInsets ei = self.targetView.contentInset;
            
            ei.top = fabs(self.frame.origin.y) + self.targetViewOriginalEdgeInsets.top;
            
            [self setScrollViewContentInset:ei];
           
           
            if ([self.delegate respondsToSelector:@selector(refreshViewDidLoading:)]) {
                [self.delegate refreshViewDidLoading:self];
                
            }
            [self rotateArrow:0 hide:YES];
            break;
        }
    }
}

- (void)rotateArrow:(float)degrees hide:(BOOL)hide
{
    [UIView animateWithDuration:0 delay:0 options:UIViewAnimationOptionAllowUserInteraction animations:^{
        self.indicatorView.layer.opacity = hide;
        //self.indicatorView.alpha  = hide?1:0;
    } completion:NULL];
}

- (void)setScrollViewContentInset:(UIEdgeInsets)contentInset
{
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionAllowUserInteraction|UIViewAnimationOptionBeginFromCurrentState animations:^{
        self.targetView.contentInset = contentInset;
    } completion:^(BOOL finished) {
        //if(self.state == RefreshViewStateDefault && contentInset.top == self.targetViewOriginalEdgeInsets.top)
           //[self rotateArrow:0 hide:NO];
    }];
}


@end
