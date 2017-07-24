//
//  QLClassHomeDataModel.m
//  QLMLD
//
//  Created by syy on 2017/7/6.
//  Copyright © 2017年 Shreker. All rights reserved.
//

#import "QLClassHomeDataModel.h"

@implementation QLClassHomeDataModel
MJCodingImplementation
- (instancetype)init{
    if (self = [super init]) {
        [QLClassHomeDataModel mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
            return @{
                     @"userId":@"user_id",
                     @"userName":@"user_name",
                     @"userPhoto":@"user_photo",
                     @"rowNum":@"ROWNUM_",
                     @"createTime":@"create_time",
                     @"praiseNum":@"praise_num",
                     @"gradeName":@"grade_name",
                     @"photo1":@"photo_1",
                     @"photo2":@"photo_2",
                     @"photo3":@"photo_3",
                     @"photo4":@"photo_4",
                     @"photo5":@"photo_5",
                     @"photo6":@"photo_6"
                     };
        }];
    }
    return self;
}
@end
