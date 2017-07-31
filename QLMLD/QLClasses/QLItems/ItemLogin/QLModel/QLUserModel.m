//
//  QLUserModel.m
//  HeartNet
//
//  Created by Shrek on 15/12/9.
//  Copyright © 2015年 Shreker. All rights reserved.
//

#import "QLUserModel.h"
@implementation QLUserModel
MJCodingImplementation
- (instancetype)init{
    if (self = [super init]) {
        [QLUserModel mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
            return @{
//                     @"user_id" : @"user_id"
                     };
        }];
    }
    return self;
}

@end
