//
//  QLBannerView.m
//  Demo_QLBannerView
//
//  Created by Shrek on 3/14/15.
//  Copyright © 2016 Shreker. All rights reserved.
//

#import "QLBannerView.h"
#import "UIImageView+WebCache.h"
#import "Masonry.h"

@interface QLBannerView () <UIScrollViewDelegate>
{
    __weak UIPageControl *_pageControl;
    __weak UIScrollView *_scrollView;
    __weak UIView *_viewContent;
    
    __weak UIImageView *_imvLeft;
    __weak UIImageView *_imvCenter;
    __weak UIImageView *_imvRight;
    
    NSInteger _imageCount;
    NSInteger _currentIndex;
    
    CGFloat _bannerHeight;
    CGFloat _bannerWidth;
    NSTimer *_timer;
    BOOL _isAnimating;
}

@end

@implementation QLBannerView

- (UIImage *)placeHolderImage {
    if (!_placeHolderImage || ![_placeHolderImage isKindOfClass:[UIImage class]]) {
        _placeHolderImage = [UIImage imageNamed:@"QLBannerView.bundle/placeholder"];
    }
    return _placeHolderImage;
}

- (void)setImages:(NSArray<QLBannerViewItem> *)images {
    _images = [images copy];
    _imageCount = _images.count;
    _pageControl.numberOfPages = _images.count;
    _pageControl.backgroundColor = [UIColor clearColor];
    _pageControl.currentPage = 0;
    _pageControl.userInteractionEnabled = NO;
    
    [self loadImageViews];
    [self reloadImages];
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self == [super initWithFrame:frame]) {
        [self loadDefaultSetting];
    }
    return self;
}

/** Load the default UI elements And prepare some datas needed. */
- (void)loadDefaultSetting {
    _currentIndex = 1;
    _timeInterval = 2;
    
    self.backgroundColor = [UIColor darkGrayColor];
    UIScrollView *scrollView = [UIScrollView new];
    scrollView.delegate =self;
    scrollView.bounces = NO;
    scrollView.pagingEnabled = YES;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.directionalLockEnabled = YES;
    [self addSubview:scrollView];
    _scrollView = scrollView;
    
    UITapGestureRecognizer  *gestueTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
    [scrollView addGestureRecognizer:gestueTap];
    
    UIView *viewContent = [UIView new];
    [scrollView addSubview:viewContent];
    _viewContent = viewContent;
    
    UIPageControl *pageControl = [UIPageControl new];
    [self addSubview:pageControl];
    _pageControl = pageControl;
    
    __unsafe_unretained typeof(self) selfUnsafe = self;
    [scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(selfUnsafe);
    }];
    [viewContent mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(scrollView);
        make.centerY.equalTo(scrollView);
        make.width.equalTo(@(3 * selfUnsafe -> _bannerWidth));
    }];
    [pageControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(selfUnsafe);
        make.bottom.equalTo(selfUnsafe);
        make.height.equalTo(@(20));
    }];
}

- (void)didMoveToWindow {
    if (self.window) {
        if (!_isAnimating) {
            [self resumeAnimatng];
        }
        [self layoutIfNeeded];
        _bannerWidth = self.frame.size.width;
        _scrollView.contentOffset = CGPointMake(_bannerWidth, 0);
        __unsafe_unretained typeof(self) selfUnsafe = self;
        [_viewContent mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@(3 * selfUnsafe -> _bannerWidth));
        }];
        [self reloadImages];
    } else {
        [self pauseAnimatng];
    }
}

#pragma mark - 🎬 Action Methods
- (void)tapAction:(UITapGestureRecognizer *)gesture{
    NSInteger index = _pageControl.currentPage;
    QLLog(@"%@", @(index));
}
- (void)loadImageViews {
    for (UIView *view in _scrollView.subviews) {
        if ([view isKindOfClass:[UIImageView class]]) {
            [view removeFromSuperview];
        }
    }
    
    UIImageView *imvLeft = [UIImageView new];
    UIImageView *imvCenter = [UIImageView new];
    UIImageView *imvRight = [UIImageView new];
    [imvLeft setContentMode:UIViewContentModeScaleToFill];
    [imvCenter setContentMode:UIViewContentModeScaleToFill];
    [imvRight setContentMode:UIViewContentModeScaleToFill];
    
    [_viewContent addSubview:imvLeft];
    _imvLeft = imvLeft;
    
    [_viewContent addSubview:imvCenter];
    _imvCenter = imvCenter;
    
    [_viewContent addSubview:imvRight];
    _imvRight = imvRight;
    
    __unsafe_unretained typeof(self) selfUnsafe = self;
    [imvLeft mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.top.and.bottom.equalTo(selfUnsafe -> _viewContent);
    }];
    [imvCenter mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(selfUnsafe -> _imvLeft.mas_right);
        make.top.and.bottom.equalTo(selfUnsafe -> _viewContent);
        make.width.equalTo(selfUnsafe -> _imvLeft);
    }];
    [imvRight mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(selfUnsafe -> _imvCenter.mas_right);
        make.top.and.bottom.and.right.equalTo(selfUnsafe -> _viewContent);
        make.width.equalTo(selfUnsafe -> _imvCenter);
    }];
}
- (void)reloadImages {
    if (_imageCount == 0) {
        return;
    }
    _currentIndex = (_currentIndex + _imageCount) % _imageCount;
    _pageControl.currentPage = _currentIndex;
    _scrollView.contentOffset = CGPointMake(_bannerWidth, 0);
    
    NSInteger index0 = (_currentIndex - 1 + _imageCount) % _imageCount;
    NSInteger index1 = _currentIndex;
    NSInteger index2 = (_currentIndex + 1) % _imageCount;
    
    [self loadImage:self.images[index0] imageView:_imvLeft];
    [self loadImage:self.images[index1] imageView:_imvCenter];
    [self loadImage:self.images[index2] imageView:_imvRight];
}
- (void)loadImage:(id<QLBannerViewItem>)imageItem imageView:(UIImageView *)imageView {
    UIImage *image = [imageItem image];
    if ([image isKindOfClass:[UIImage class]]) {
        [imageView setImage:[imageItem image]];
        return; // priority
    }
    
    NSURL *url = [imageItem url];
    if ([url isKindOfClass:[NSURL class]]) {
        [imageView sd_setImageWithURL:url placeholderImage:self.placeHolderImage];
    }
}
- (void)scrollToNext {
    [_scrollView setContentOffset:CGPointMake(2 * _bannerWidth, 0) animated:YES];
}
- (void)pauseAnimatng {
    [_timer setFireDate:[NSDate distantFuture]];
    _isAnimating = NO;
}
- (void)resumeAnimatng {
    if (!_timer) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:_timeInterval target:self selector:@selector(scrollToNext) userInfo:nil repeats:YES];
    }
    [_timer setFireDate:[NSDate dateWithTimeIntervalSinceNow:_timeInterval]];
    _isAnimating = YES;
}

#pragma mark scrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView.contentOffset.x == 2 * _bannerWidth) {
        _currentIndex ++;
    } else if (scrollView.contentOffset.x == 0) {
        _currentIndex --;
    } else {
        return;
    }
    
    if (self.images.count >= 3) {
        [self reloadImages];
    }
}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self pauseAnimatng];
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    [self resumeAnimatng];
}

- (void)dealloc {
    // RELEASE OBJECTS TO FREE THE MEMORIES HERE!
    [_timer invalidate];
    _timer = nil;
    __unsafe_unretained typeof(self) selfUnsafe = self;
    QLLog(@"🌜A instance of type %@ was DESTROYED!🌛", NSStringFromClass([selfUnsafe class]));
}

@end
