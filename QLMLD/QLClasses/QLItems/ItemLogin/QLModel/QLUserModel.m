//
//  QLUserModel.m
//  HeartNet
//
//  Created by Shrek on 15/12/9.
//  Copyright © 2015年 Shreker. All rights reserved.
//

#import "QLUserModel.h"

static NSString * const QLCodingKeyAccount = @"QLKeyAccount";
static NSString * const QLCodingKeyUserId = @"QLKeyUserId";
static NSString * const QLCodingKeyLoginName = @"QLCodingKeyLoginName";
static NSString * const QLCodingKeyOperatorremark = @"QLCodingKeyOperatorremark";
static NSString * const QLCodingKeyToken = @"QLKeyUserToken";
static NSString * const QLCodingKeyLoginStatus = @"QLCodingKeyLoginStatus";
static NSString * const QLCodingKeyIsRealName = @"QLCodingKeyIsRealName";
static NSString * const QLCodingKeyUserAuthrizedType = @"QLCodingKeyUserAuthrizedType";
static NSString * const QLCodingKeyGender = @"QLCodingKeyGender";
static NSString * const QLCodingKeyRealName = @"QLCodingKeyRealName";
static NSString * const QLCodingKeyPhone = @"QLCodingKeyPhone";

@interface QLUserModel () <NSCoding>

@end

@implementation QLUserModel

+ (instancetype)userModelWithDictionary:(NSDictionary *)dicData {
    if (dicData == nil || [dicData isKindOfClass:[NSNull class]]) return nil;
    
    QLUserModel *user = [self new];
    user.strAccount = [NSString getValidStringWithObject:dicData[@"account"]];
    user.strId = [NSString getValidStringWithObject:dicData[@"id"]];
    user.strLoginName = [NSString getValidStringWithObject:dicData[@"loginname"]];
    user.strOperatorremark = [NSString getValidStringWithObject:dicData[@"operatorremark"]];
    user.strToken = [NSString getValidStringWithObject:dicData[@"token"]];
    user.strMobilephone = [NSString getValidStringWithObject:dicData[@"phone"]];
    if ([user.strMobilephone isEmptyString]) {
        user.strMobilephone = [NSString getValidStringWithObject:dicData[@"mobilephone"]];
    }
    QLLog(@"isrealname==%@",dicData[@"isrealname"]);
    user.userAuthrizedType = [[NSString getValidStringWithObject:dicData[@"isrealname"]] intValue];
    
    NSString *strGender = [NSString getValidStringWithObject:dicData[@"sex"]];
    if ([strGender isEqualToString:@""]) {
        strGender = @"2";
    }
    user.gender = [strGender integerValue];
    
    user.strCreatedate = [NSString getValidStringWithObject:dicData[@"createdate"]];
    user.strEmail = [NSString getValidStringWithObject:dicData[@"email"]];
    user.strHeadphoto = [NSString getValidStringWithObject:dicData[@"headphoto"]];
    user.strIsdel = [NSString getValidStringWithObject:dicData[@"isdel"]];
    user.strIslock = [NSString getValidStringWithObject:dicData[@"islock"]];
    user.strLoginidcard = [NSString getValidStringWithObject:dicData[@"loginidcard"]];
    user.strName = [NSString getValidStringWithObject:dicData[@"name"]];
    user.strUpdatepassworddate = [NSString getValidStringWithObject:dicData[@"updatepassworddate"]];
    user.strUsertype = [NSString getValidStringWithObject:dicData[@"usertype"]];
    
    return user;
}

- (void)setUserAuthrizedType:(QLUserAuthrizedType)userAuthrizedType {
    _userAuthrizedType = userAuthrizedType;
    QLLog(@"认证状态：%zd",_userAuthrizedType);
    switch (userAuthrizedType) {
        case QLUserAuthrizedTypeNotYet:
            _userAuthrizedImageMine = @"icon_mine_auth_no";
            _userAuthrizedImageInfo = @"icon_mine_auth_info_no";
            _userAuthrizedTypeDes = @"未认证";
            _userAuthrizedColor = QLColorWithRGB(153, 153, 153);
            break;
        case QLUserAuthrizedTypeProcessing:
            _userAuthrizedImageMine = @"icon_mine_auth_yes";
            _userAuthrizedImageInfo = @"icon_mine_auth_info_no";
            _userAuthrizedTypeDes = @"审核中";
            _userAuthrizedColor = QLColorWithRGB(153, 153, 153);
            break;
        case QLUserAuthrizedTypeFrontDoor:
            _userAuthrizedImageMine = @"icon_mine_auth_no";
            _userAuthrizedImageInfo = @"icon_mine_auth_info_no";
            _userAuthrizedTypeDes = @"未通过";
            _userAuthrizedColor = QLColorWithRGB(153, 153, 153);
            break;
        case QLUserAuthrizedTypeInDoor:
            _userAuthrizedImageMine = @"icon_mine_auth_yes";
            _userAuthrizedImageInfo = @"icon_mine_auth_info_yes";
            _userAuthrizedTypeDes = @"已认证";
            _userAuthrizedColor = QLColorWithRGB(255, 59, 33);
            break;
    }
}

#pragma mark - Protocals
#pragma mark NSCoding
- (void)encodeWithCoder:(NSCoder *)coder {
    [coder encodeObject:self.strAccount forKey:QLCodingKeyAccount];
    [coder encodeObject:self.strId forKey:QLCodingKeyUserId];
    [coder encodeObject:self.strLoginName forKey:QLCodingKeyLoginName];
    [coder encodeObject:self.strOperatorremark forKey:QLCodingKeyOperatorremark];
    [coder encodeObject:self.strToken forKey:QLCodingKeyToken];
    [coder encodeBool:self.loginStatus forKey:QLCodingKeyLoginStatus];
    [coder encodeInteger:self.userAuthrizedType forKey:QLCodingKeyUserAuthrizedType];
    [coder encodeBool:self.gender forKey:QLCodingKeyGender];
    [coder encodeObject:self.strName forKey:QLCodingKeyRealName];
    [coder encodeObject:self.strMobilephone forKey:QLCodingKeyPhone];
    
}

- (instancetype)initWithCoder:(NSCoder *)decoder {
    if (self = [super init]) {
        self.strAccount = [decoder decodeObjectForKey:QLCodingKeyAccount];
        self.strId = [decoder decodeObjectForKey:QLCodingKeyUserId];
        self.strLoginName = [decoder decodeObjectForKey:QLCodingKeyLoginName];
        self.strOperatorremark = [decoder decodeObjectForKey:QLCodingKeyOperatorremark];
        self.strToken = [decoder decodeObjectForKey:QLCodingKeyToken];
        self.loginStatus = [decoder decodeBoolForKey:QLCodingKeyLoginStatus];
        self.userAuthrizedType = [decoder decodeIntegerForKey:QLCodingKeyUserAuthrizedType];
        self.gender = [decoder decodeBoolForKey:QLCodingKeyGender];
        self.strName = [decoder decodeObjectForKey:QLCodingKeyRealName];
        self.strMobilephone =[decoder decodeObjectForKey:QLCodingKeyPhone];
    }
    return self;
}

@end
