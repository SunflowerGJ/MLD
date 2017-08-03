//
//  QLAdmissionHomeDataModel.m
//  QLMLD
//
//  Created by syy on 2017/7/25.
//  Copyright © 2017年 Shreker. All rights reserved.
//

#import "QLAdmissionHomeDataModel.h"

@implementation QLAdmissionHomeDataModel
MJCodingImplementation
- (instancetype)init{
    if (self = [super init]) {
        [QLAdmissionHomeDataModel mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
            return @{
//                     @"userId":@"user_id",
                     };
        }];
    }
    return self;
}

@end
