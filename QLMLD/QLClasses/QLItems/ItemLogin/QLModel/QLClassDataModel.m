//
//  QLClassDataModel.m
//  QLMLD
//
//  Created by syy on 2017/7/18.
//  Copyright © 2017年 Shreker. All rights reserved.
//

#import "QLClassDataModel.h"

@implementation QLClassDataModel
MJCodingImplementation
- (instancetype)init{
    if (self = [super init]) {
        [QLClassDataModel mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
            return @{
                     @"ROWNUM" : @"ROWNUM_"
                     };
        }];
    }
    return self;
}
@end
