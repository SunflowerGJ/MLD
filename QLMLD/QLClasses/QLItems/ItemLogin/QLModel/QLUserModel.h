//
//  QLUserModel.h
//  HeartNet
//
//  Created by Shrek on 15/12/9.
//  Copyright © 2015年 Shreker. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, QLGender) {
    QLGenderFemale = 0,
    QLGenderMale = 1,
    QLGenderNone = 2
};

typedef NS_ENUM(NSUInteger, QLUserAuthrizedType) {
    /** 未认证 */
    QLUserAuthrizedTypeNotYet = 0,
    
    /** 审核中 */
    QLUserAuthrizedTypeProcessing = 1,
    
    /** 未通过 */
    QLUserAuthrizedTypeFrontDoor = 2,
    
    /** 已通过 */
    QLUserAuthrizedTypeInDoor = 3
};

@interface QLUserModel : NSObject

@property (nonatomic, copy) NSString *strAccount;
@property (nonatomic, copy) NSString *strCreatedate;
@property (nonatomic, copy) NSString *strEmail;
@property (nonatomic, copy) NSString *strHeadphoto;
@property (nonatomic, copy) NSString *strId;
@property (nonatomic, copy) NSString *strIsdel;
@property (nonatomic, copy) NSString *strIslock;
@property (nonatomic, copy) NSString *strLoginidcard;
@property (nonatomic, copy) NSString *strLoginName;
@property (nonatomic, copy) NSString *strMobilephone;
@property (nonatomic, copy) NSString *strName;
@property (nonatomic, copy) NSString *strOperatorremark;
@property (nonatomic, copy) NSString *strToken;
@property (nonatomic, copy) NSString *strUpdatepassworddate;
@property (nonatomic, copy) NSString *strUsertype;

@property (nonatomic, assign) QLGender gender;
@property (nonatomic, assign) QLUserAuthrizedType userAuthrizedType; // 实名状态
@property (nonatomic, copy, readonly) NSString *userAuthrizedTypeDes; // 实名状态
@property (nonatomic, copy, readonly) NSString *userAuthrizedImageMine; // 实名状态-个人中心
@property (nonatomic, copy, readonly) NSString *userAuthrizedImageInfo; // 实名状态-简历/个人信息
@property (nonatomic, strong, readonly) UIColor *userAuthrizedColor;


@property (nonatomic, assign) BOOL loginStatus;

+ (instancetype)userModelWithDictionary:(NSDictionary *)dicData;
- (void)updateUserInfoWithDictionary:(NSDictionary *)dicData;

@end
