//
//  UIScrollView+KS.h
//  DLSlideViewDemo
//
//  Created by kn on 15/5/6.
//  Copyright (c) 2015年 dongle. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KSDefaultHeadRefreshView.h"
#import "KSDefaultFootRefreshView.h"
#import "KSAutoFootRefreshView.h"
@interface UIScrollView (KS)
@property (nonatomic, strong) KSHeadRefreshView * header;
@property (nonatomic, strong) KSFootRefreshView * footerKS;
@end
