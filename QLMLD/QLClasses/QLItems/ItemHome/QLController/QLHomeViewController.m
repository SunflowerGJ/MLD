//
//  QLHomeViewController.m
//  QLProjectDemo
//
//  Created by Shrek on 15/12/4.
//  Copyright © 2015年 Shreker. All rights reserved.
//

#import "QLHomeViewController.h"
#import "QLBannerView.h"
#import "QLImageModel.h"

@interface QLHomeViewController ()
{
    __weak QLBannerView * _bannerView;;
}

@end

@implementation QLHomeViewController

#pragma mark - Life Circle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadDefaultSetting];
}

/** Load the default UI elements And prepare some datas needed. */
- (void)loadDefaultSetting {
    self.view.backgroundColor = [UIColor whiteColor];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    QLBannerView *bannerView = [QLBannerView new];
    [bannerView setBackgroundColor:[UIColor colorWithWhite:0.8 alpha:1]];
    [self.view addSubview:bannerView];
    _bannerView = bannerView;
    [bannerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(64);
        make.left.and.right.equalTo(self.view);
        make.height.equalTo(@(150));
    }];
    NSArray *arrUrlStrings = @[@"http://pic3.nipic.com/20090616/1441505_172123068_2.jpg",
                               @"http://pic19.nipic.com/20120315/4758005_091854125000_2.jpg",
                               @"http://img3.3lian.com/2013/v11/41/d/61.jpg"];
    NSMutableArray<QLBannerViewItem> *arrImages = (NSMutableArray<QLBannerViewItem> *)[NSMutableArray arrayWithCapacity:arrUrlStrings.count];
    for (NSString *strUrl in arrUrlStrings) {
        QLImageModel *imageModel = [QLImageModel new];
        imageModel.url = [NSURL URLWithString:strUrl];
        [arrImages addObject:imageModel];
    }
    [bannerView setImages:[arrImages copy]];
}


- (void)dealloc {
    // RELEASE OBJECTS TO FREE THE MEMORIES HERE!
    __unsafe_unretained typeof(self) selfUnsafe = self;
    QLLog(@"🌜A instance of type %@ was DESTROYED!🌛", NSStringFromClass([selfUnsafe class]));
}

@end
