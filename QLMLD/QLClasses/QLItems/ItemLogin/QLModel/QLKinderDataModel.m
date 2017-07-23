//
//  QLKinderDataModel.m
//  QLMLD
//
//  Created by syy on 2017/7/18.
//  Copyright © 2017年 Shreker. All rights reserved.
//

#import "QLKinderDataModel.h"

@implementation QLKinderDataModel
MJCodingImplementation
- (instancetype)init{
    if (self = [super init]) {
        [QLKinderDataModel mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
            return @{
                     @"school_id" : @"school_id"
                     };
        }];
    }
    return self;
}

@end
