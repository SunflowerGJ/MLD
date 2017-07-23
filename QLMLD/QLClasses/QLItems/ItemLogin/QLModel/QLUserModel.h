//
//  QLUserModel.h
//  HeartNet
//
//  Created by Shrek on 15/12/9.
//  Copyright © 2015年 Shreker. All rights reserved.
//

#import <Foundation/Foundation.h>

//typedef NS_ENUM(NSUInteger, QLGender) {
//    QLGenderFemale : 0,
//    QLGenderMale : 1,
//    QLGenderNone : 2
//};
//
//typedef NS_ENUM(NSUInteger, QLUserAuthrizedType) {
//    /** 未认证 */
//    QLUserAuthrizedTypeNotYet : 0,
//    
//    /** 审核中 */
//    QLUserAuthrizedTypeProcessing : 1,
//    
//    /** 未通过 */
//    QLUserAuthrizedTypeFrontDoor : 2,
//    
//    /** 已通过 */
//    QLUserAuthrizedTypeInDoor : 3
//};

@interface QLUserModel : NSObject

//@property (nonatomic, copy) NSString *strAccount;
//@property (nonatomic, copy) NSString *strCreatedate;
//@property (nonatomic, copy) NSString *strEmail;
//@property (nonatomic, copy) NSString *strHeadphoto;
//@property (nonatomic, copy) NSString *strId;
//@property (nonatomic, copy) NSString *strIsdel;
//@property (nonatomic, copy) NSString *strIslock;
//@property (nonatomic, copy) NSString *strLoginidcard;
//@property (nonatomic, copy) NSString *strLoginName;
//@property (nonatomic, copy) NSString *strMobilephone;
//@property (nonatomic, copy) NSString *strName;
//@property (nonatomic, copy) NSString *strOperatorremark;
//@property (nonatomic, copy) NSString *strToken;
//@property (nonatomic, copy) NSString *strUpdatepassworddate;
//@property (nonatomic, copy) NSString *strUsertype;

@property (nonatomic, assign) NSInteger school_id;
@property (nonatomic, copy) NSString *active;
@property (nonatomic, copy) NSString *school_name;
@property (nonatomic, copy) NSString *user_password;
@property (nonatomic, copy) NSString *school_logo;
@property (nonatomic, assign) NSInteger user_id;
@property (nonatomic, assign) NSInteger grade_id;
@property (nonatomic, copy) NSString *user_tel;
@property (nonatomic, assign) NSInteger audit_status;
@property (nonatomic, copy) NSString *user_name;
@property (nonatomic, copy) NSString *user_photo;
@property (nonatomic, copy) NSString *grade_name;
@property (nonatomic, assign) NSInteger point_number;
@property (nonatomic, assign) NSInteger upadte_user;
@property (nonatomic, copy) NSString *update_time;
@property (nonatomic, assign) NSInteger user_type;

@end

