//
//  QLChannelListDataModel.m
//  QLMLD
//
//  Created by syy on 2017/7/27.
//  Copyright © 2017年 Shreker. All rights reserved.
//

#import "QLChannelListDataModel.h"

@implementation QLChannelListDataModel
MJCodingImplementation
- (instancetype)init{
    if (self = [super init]) {
        [QLChannelListDataModel mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
            return @{
                     //                     @"userId":@"user_id",
                     };
        }];
    }
    return self;
}

@end
