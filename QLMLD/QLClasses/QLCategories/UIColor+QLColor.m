//
//  UIColor+QLColor.m
//  QLMLD
//
//  Created by 英英 on 2017/7/12.
//  Copyright © 2017年 Shreker. All rights reserved.
//

#import "UIColor+QLColor.h"

@implementation UIColor (QLColor)
+ (instancetype)randomColor {
    
    CGFloat red = arc4random_uniform(255) / 255.0;
    CGFloat green = arc4random_uniform(255) / 255.0;
    CGFloat blue = arc4random_uniform(255) / 255.0;
    return [self colorWithRed:red green:green blue:blue alpha:1.0];
}
@end
