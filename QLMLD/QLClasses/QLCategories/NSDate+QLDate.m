//
//  NSDate+QLDate.m
//  HeartNet
//
//  Created by Shrek on 16/2/15.
//  Copyright © 2016年 Shreker. All rights reserved.
//

#import "NSDate+QLDate.h"

@implementation NSDate (QLDate)

//- (NSString *)dateDescription {
//    NSString *suffix = @"前"; // ago
//    
//    CGFloat different = [self timeIntervalSinceNow];
////    if (different < 0) {
////        different = -different;
////        suffix = @"from now";// from now
////    }
//    
//    // days = different / (24 * 60 * 60), take the floor value
//    CGFloat dayDifferent = floor(different / 86400);
//    
//    NSInteger days   = (NSInteger)dayDifferent;
//    NSInteger weeks  = (NSInteger)ceil(dayDifferent / 7);
//    NSInteger months = (NSInteger)ceil(dayDifferent / 30);
//    NSInteger years  = (NSInteger)ceil(dayDifferent / 365);
//    
//    // It belongs to today
//    if (dayDifferent <= 0) {
//        
//        if (different < 60) { // lower than 60 seconds
//            return @"just now"; // just now
//        }
//        
//        if (different < 120) { // lower than 120 seconds => one minute and lower than 60 seconds
//            return [NSString stringWithFormat:@"1分钟%@", suffix];
//        }
//        
//        if (different < 660 * 60) { // lower than 60 minutes
//            return [NSString stringWithFormat:@"%zd分钟%@", (NSInteger)floor(different / 60), suffix];
//        }
//        
//        if (different < 7200) { // lower than 60 * 2 minutes => one hour and lower than 60 minutes
//            return [NSString stringWithFormat:@"1小时%@", suffix];
//        }
//        
//        if (different < 86400) { // lower than one day
//            return [NSString stringWithFormat:@"%zd小时%@", (NSInteger)floor(different / 3600), suffix];
//        }
//    } else if (days < 7) { // lower than one week
//        return [NSString stringWithFormat:@"%zd天%@", days, suffix];
//    } else if (weeks < 4) { // lager than one week but lower than a month
//        return [NSString stringWithFormat:@"%zd周%@", weeks, suffix];
//    } else if (months < 12) { // lager than a month and lower than a year
//        return [NSString stringWithFormat:@"%zd月%@", months, suffix];
//    } else { // lager than a year
//        return [NSString stringWithFormat:@"%zd年%@", years, suffix];
//    }
//    
//    return self.description;  
//}

/**
 
 * 计算指定时间与当前的时间差
 
 * @param compareDate   某一指定时间
 
 * @return 多少(秒or分or天or月or年)+前 (比如，3天前、10分钟前)
 
 */

- (NSString *)dateDescription {
    NSTimeInterval  timeInterval = [self timeIntervalSinceNow];
    timeInterval = -timeInterval;
    long temp = 0;
    NSString *result = nil;
    if (timeInterval < 60) {
        result = [NSString stringWithFormat:@"刚刚"];
    } else if((temp = timeInterval/60) <60){
        result = [NSString stringWithFormat:@"%zd分前",temp];
    } else if((temp = temp/60) <24){
        result = [NSString stringWithFormat:@"%zd小时前",temp];
    } else if((temp = temp/24) <30){
        result = [NSString stringWithFormat:@"%zd天前",temp];
    } else if((temp = temp/30) <12){
        result = [NSString stringWithFormat:@"%zd月前",temp];
    } else {
        temp = temp/12;
        result = [NSString stringWithFormat:@"%zd年前",temp];
    }
    return  result;
}

@end
