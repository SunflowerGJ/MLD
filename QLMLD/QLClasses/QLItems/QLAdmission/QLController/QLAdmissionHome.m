//
//  QLAdmissionHome.m
//  QLMLD
//
//  Created by 英英 on 2017/7/2.
//  Copyright © 2017年 Shreker. All rights reserved.
//

#import "QLAdmissionHome.h"
#import "QLShareVC.h"
#import "QLAdmissionDetailVC.h"
#import "QLAdmisiionSlideVC.h"
#import "QLAdmissionHomeDataModel.h"
@interface QLAdmissionHome (){
    
    QLAdmisiionSlideVC *slideVC;
}

@end

@implementation QLAdmissionHome

- (void)viewDidLoad {
    [super viewDidLoad];
    [self dataRequest];
    [self loadDefaultSetting];
    
}
- (void)loadDefaultSetting {
    _viewICarousel.delegate = self;
    _viewICarousel.dataSource = self;
    _viewICarousel.type = iCarouselTypeCoverFlow;
    
    self.leftBtn.frame = CGRectMake(0, 28, 50, 30);
    [self.leftBtn setImage:[UIImage imageNamed:@"moreTime_icon"]  forState:UIControlStateNormal];
    
    self.rightBtn.hidden = NO;
    self.rightBtn.frame = CGRectMake(QLScreenWidth-40, 28, 30, 30);
    [self.rightBtn setImage:[UIImage imageNamed:@"camera_icon"] forState:UIControlStateNormal];
    
    UIImageView *line = [[UIImageView alloc]initWithFrame:CGRectMake(self.rightBtn.frame.origin.x-5, 28, .5, 30)];
    line.backgroundColor = [UIColor whiteColor];
    [self.titleView addSubview:line];
    
    UIButton *share = [UIButton buttonWithType:UIButtonTypeSystem];
    share.frame = CGRectMake(self.rightBtn.frame.origin.x-40, 28, 30, 30);
    share.tintColor = [UIColor whiteColor];
    share.backgroundColor = [UIColor clearColor];
    [share setImage:[UIImage imageNamed:@"share_icon"] forState:UIControlStateNormal];
    [self.titleView addSubview:share];
    [share addTarget:self action:@selector(clickShare) forControlEvents:UIControlEventTouchUpInside];
}
- (void)clickBack{
    QLLog(@"more");
    slideVC = [[QLAdmisiionSlideVC alloc]initWithNibName:@"QLAdmisiionSlideVC" bundle:[NSBundle mainBundle]];
    slideVC.view.frame = self.view.frame;
    [self.view addSubview:slideVC.view];
    [slideVC startAnimation];
}
- (void)clickRight{
    QLLog(@"拍照");
}
- (void)clickShare{
    QLLog(@"分享");
    QLShareVC *shareVC = [[QLShareVC alloc]init];
    [[QLHttpTool getCurrentVC].navigationController pushViewController:shareVC animated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - data request 
- (void)dataRequest {
    NSString *strBaseUrl = [NSString stringWithFormat:@"%@%@",QLBaseUrlString,admissionHomeData_interface];
    [QLHttpTool postWithBaseUrl:strBaseUrl Parameters:nil whenSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
    } whenFailure:^{
        
    }];
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
    
    view.frame = CGRectMake(_viewICarousel.frame.origin.x, _viewICarousel.frame.origin.y, _viewICarousel.frame.size.width, _viewICarousel.frame.size.height);
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(detail)];
    [view addGestureRecognizer:tap];
    
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
#pragma mark - 
- (void)detail {
    QLAdmissionDetailVC *detailVC = [[QLAdmissionDetailVC alloc]init];
    [[QLHttpTool getCurrentVC].navigationController pushViewController:detailVC animated:YES];
}
@end
