//
//  QLAdmissionHome.m
//  QLMLD
//
//  Created by 英英 on 2017/7/2.
//  Copyright © 2017年 Shreker. All rights reserved.
//

#import "QLAdmissionHome.h"

@interface QLAdmissionHome ()

@end

@implementation QLAdmissionHome

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadDefaultSetting];
}
- (void)loadDefaultSetting {
    self.leftBtn.hidden = YES;
    _viewICarousel.delegate = self;
    _viewICarousel.dataSource = self;
    
    _viewICarousel.type = iCarouselTypeCoverFlow;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -

- (NSUInteger)numberOfItemsInCarousel:(iCarousel *)carousel
{
    return 30;
}

- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSUInteger)index
{
    UIView *view = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"%ld.jpg",index]]];
    UILabel *lblTime = [[UILabel alloc]initWithFrame:CGRectMake(0, 30, view.frame.size.width, 30)];
    [view addSubview:lblTime];
    lblTime.text = [NSString stringWithFormat:@"%ld time",index];
    lblTime.textColor = [UIColor redColor];
    
    view.frame = CGRectMake(30, 64+30, QLScreenWidth-80, QLScreenHeight-(64+30)*2);
    return view;
}

- (NSUInteger)numberOfPlaceholdersInCarousel:(iCarousel *)carousel
{
    return 0;
}

- (NSUInteger)numberOfVisibleItemsInCarousel:(iCarousel *)carousel
{
    return 30;
}

- (CGFloat)carouselItemWidth:(iCarousel *)carousel
{
    return QLScreenWidth-40;
}

- (CATransform3D)carousel:(iCarousel *)_carousel transformForItemView:(UIView *)view withOffset:(CGFloat)offset
{
    view.alpha = 1.0 - fminf(fmaxf(offset, 0.0), 1.0);
    
    CATransform3D transform = CATransform3DIdentity;
    transform.m34 = _viewICarousel.perspective;
    transform = CATransform3DRotate(transform, M_PI / 8.0, 0, 1.0, 0);
    return CATransform3DTranslate(transform, 0.0, 0.0, offset * _viewICarousel.itemWidth);
}
- (BOOL)carouselShouldWrap:(iCarousel *)carousel
{
    return YES;
}

@end
