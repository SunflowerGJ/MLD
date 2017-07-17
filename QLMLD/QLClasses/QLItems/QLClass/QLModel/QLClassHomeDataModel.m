//
//  QLClassHomeDataModel.m
//  QLMLD
//
//  Created by syy on 2017/7/6.
//  Copyright © 2017年 Shreker. All rights reserved.
//

#import "QLClassHomeDataModel.h"

@implementation QLClassHomeDataModel
-(instancetype)initClassDataDictionary:(NSDictionary *)dicData{
    if (self = [super init]) {
    }
    _strId = [NSString getValidStringWithObject:dicData[@"id"]];
    _grade_name = [NSString getValidStringWithObject:dicData[@"fkopenCityId"]];
    _photo_1 = [NSString getValidStringWithObject:dicData[@"photo_1"]];
    _photo_2 = [NSString getValidStringWithObject:dicData[@"photo_2"]];
    _photo_3 = [NSString getValidStringWithObject:dicData[@"photo_3"]];
    _photo_4 = [NSString getValidStringWithObject:dicData[@"photo_4"]];
    _photo_5 = [NSString getValidStringWithObject:dicData[@"photo_5"]];
    _photo_6 = [NSString getValidStringWithObject:dicData[@"photo_6"]];
    _praise_num = [NSString getValidStringWithObject:dicData[@"praise_num"]];
    _user_name = [NSString getValidStringWithObject:dicData[@"user_name"]];
    _user_photo = [NSString getValidStringWithObject:dicData[@"user_photo"]];

    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat: @"yyyy-MM-dd HH:mm:ss"];
    _createTime = [Tools getDateString:[dateFormatter dateFromString:[NSString getValidStringWithObject:dicData[@"createTime"]]] famter:@"yyyy年MM月dd日"];
    return self;
}
@end
