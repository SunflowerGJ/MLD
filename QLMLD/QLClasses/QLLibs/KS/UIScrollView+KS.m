//
//  UIScrollView+KS.m
//  DLSlideViewDemo
//
//  Created by kn on 15/5/6.
//  Copyright (c) 2015年 dongle. All rights reserved.
//

#import "UIScrollView+KS.h"
#import <objc/runtime.h>

static void * MyKey1 = (void *)@"HeadRefreshView";
static void * MyKey2 = (void *)@"FootRefreshView";
@implementation UIScrollView (KS)
@dynamic header;
@dynamic footerKS;

- (KSHeadRefreshView *)header
{
    return objc_getAssociatedObject(self, MyKey1);
}

- (void)setHeader:(KSHeadRefreshView *)header
{
    id curr = [self header];
    if (curr) {
        [curr removeFromSuperview];
    }
    if (header) {
        [self addSubview:header];
    }
    objc_setAssociatedObject(self, MyKey1, header, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (KSFootRefreshView *)footerKS
{
    return objc_getAssociatedObject(self, MyKey2);
}

- (void)setFooterKS:(KSFootRefreshView *)footer
{
    id curr = [self footerKS];
    if (curr) {
        [curr removeFromSuperview];
    }
    if (footer) {
        [self addSubview:footer];
    }
    objc_setAssociatedObject(self, MyKey2, footer, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
