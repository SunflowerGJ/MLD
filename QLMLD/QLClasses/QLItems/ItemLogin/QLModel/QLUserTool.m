//
//  QLUserTool.m
//  HeartNet
//
//  Created by Shrek on 15/12/9.
//  Copyright © 2015年 Shreker. All rights reserved.
//

#import "QLUserTool.h"
#import "QLAppDelegate.h"
#import "NSData+QLData.h"

#define HNUserModelPath [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0] stringByAppendingPathComponent:@"userModel"]

@implementation QLUserTool

QLSingletonImplementation(UserTool)

- (id)init {
    if(self = [super init]) {
        _userModel = [NSKeyedUnarchiver unarchiveObjectWithFile:HNUserModelPath];
    }
    return self;
}

- (void)saveUserModel:(QLUserModel *)userModel {
    _userModel = userModel;
    [NSKeyedArchiver archiveRootObject:_userModel toFile:HNUserModelPath];
}
- (void)clearCurrentUserModel {
    NSString *userDataPath = HNUserModelPath;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isUserDataExist = [fileManager fileExistsAtPath:userDataPath];
    if (isUserDataExist) {
        NSError *error;
        [fileManager removeItemAtPath:userDataPath error:&error];
        if (error) {
            QLLog(@"%s-userData Delete Failed:%@", __FUNCTION__, error);
        } else {
            _userModel = nil;
        }
    }
}
- (void)loginWithUser:(NSString *)strUser pwd:(NSString *)strPwd whenSuccess:(void (^)())success whenFailure:(void (^)())failure  {
    
}

- (void)logout {
    [[QLUserTool sharedUserTool] clearCurrentUserModel];
    QLAppDelegate *delegate = [UIApplication sharedApplication].delegate;
    [delegate changeRootViewControllerToLogin];
}

@end
