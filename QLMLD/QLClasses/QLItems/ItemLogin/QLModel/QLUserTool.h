//
//  QLUserTool.h
//  HeartNet
//
//  Created by Shrek on 15/12/9.
//  Copyright © 2015年 Shreker. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QLSingleton.h"
#import "QLUserModel.h"

@interface QLUserTool : NSObject

QLSingletonInterface(UserTool)

/** 当前登录的用户模型 */
@property (nonatomic, strong, readonly) QLUserModel *userModel;
- (void)saveUserModel:(QLUserModel *)userModel;
- (void)clearCurrentUserModel;
- (void)logout;
@end
