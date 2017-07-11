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
#import "QLLoginViewController.h"
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
+ (void)loginWithUser:(NSString *)strUser pwd:(NSString *)strPwd whenSuccess:(void (^)())success whenFailure:(void (^)())failure  {
    
    
    NSString *strBaseUrl = [NSString stringWithFormat:@"%@%@", QLBaseUrlString, userLogin_interface];
    
//    NSData *dataPwd = [[NSString stringWithFormat:@"%@%@",EncryptPrefix,strPwd] dataUsingEncoding:NSUTF8StringEncoding];
    NSData *dataPwd = [[NSString stringWithFormat:@"%@",strPwd] dataUsingEncoding:NSUTF8StringEncoding];

    NSDictionary *dicParams = @{@"username": strUser,@"password":[dataPwd md5String],@"token":[[UIDevice currentDevice].identifierForVendor UUIDString]};
    [QLHttpTool postWithBaseUrl:strBaseUrl Parameters:dicParams whenSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        QLLog(@"返回值：%@",responseObject);
        [[QLUserTool sharedUserTool] saveUserModel:[QLUserModel mj_objectWithKeyValues:responseObject[@"data"]]];
        //  绑定个推
        [GeTuiSdk bindAlias:[QLUserTool sharedUserTool].userModel.strAccount andSequenceNum:KGtSeriNum];
//        NSString *stationID = [QLUserTool sharedUserTool].userModel.tfUtechnician.fkstationId;
//        NSString *str = [NSString stringWithFormat:@"station%@",stationID];
//        [GeTuiSdk setTags:@[str]];
//        [QLUserDefaults setObject:loginTechnician forKey:userLoginState];
//        [QLUserDefaults setObject:pwd forKey:currentLoginPwd];
//        // 切换账号时清掉数据库中除系统消息外的所有消息
//        NSString *currentUserID = [QLUserDefaults objectForKey:CurrentUserId];
//        if (currentUserID != [QLUserTool sharedUserTool].userModel.strId) {
//            [MessageTool clearPushMessageAll:NO];
//        }
//        
//        // 更新 CurrentUserId
//        [[NSUserDefaults standardUserDefaults] setObject:[NSString getValidStringWithObject:[QLUserTool sharedUserTool].userModel.strId] forKey:CurrentUserId];
//        [[NSUserDefaults standardUserDefaults] synchronize];
        
        //发送通知
//        [QLNotificationCenter postNotificationName:Notification_setUserType object:self userInfo:nil];
        if (success) {
            success();
        }
    } whenFailure:^() {
        
    }];
}

//- (void)logout {
//    [[QLUserTool sharedUserTool] clearCurrentUserModel];
//    QLAppDelegate *delegate = [UIApplication sharedApplication].delegate;
//    [delegate changeRootViewControllerToLogin];
//}

- (void)logout {
    if([QLUserTool sharedUserTool].userModel.strId){
        //解绑个推
        [GeTuiSdk bindAlias:[QLUserTool sharedUserTool].userModel.strAccount andSequenceNum:KGtSeriNum];

        [[QLUserTool sharedUserTool] clearCurrentUserModel];
    }
    QLLog(@"viewControllers==== %@",[QLHttpTool getCurrentVC].navigationController.viewControllers);
    QLLoginViewController *loginVC = [[QLLoginViewController alloc]init];
    [[QLHttpTool getCurrentVC].navigationController pushViewController:loginVC animated:YES];
    for (UIViewController *vc in [QLHttpTool getCurrentVC].navigationController.viewControllers) {
        if (![vc isKindOfClass:[QLLoginViewController class]]) {
            [vc removeFromParentViewController];
        }
    }
}

#pragma mark - 登录
+ (void)loginOfAccount:(NSString *)account password:(NSString *)pwd WhenSuccess:(void (^)())success WhenFailure:(void (^)())failure{
    NSString *strBaseUrl = [NSString stringWithFormat:@"%@%@", QLBaseUrlString, userLogin_interface];
    
    NSData *dataPwd = [[NSString stringWithFormat:@"%@%@",EncryptPrefix,pwd] dataUsingEncoding:NSUTF8StringEncoding];
    
    NSDictionary *dicParams = @{@"username": account,@"password":[dataPwd md5String],@"cookie":[[UIDevice currentDevice].identifierForVendor UUIDString]};
    [QLHttpTool postWithBaseUrl:strBaseUrl Parameters:dicParams whenSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        QLLog(@"返回值：%@",responseObject);
        [[QLUserTool sharedUserTool] saveUserModel:[QLUserModel mj_objectWithKeyValues:responseObject[@"data"]]];
        //  绑定个推
        [GeTuiSdk bindAlias:[QLUserTool sharedUserTool].userModel.strAccount andSequenceNum:KGtSeriNum];
        
//        NSString *stationID = [QLUserTool sharedUserTool].userModel.tfUtechnician.fkstationId;
//        NSString *str = [NSString stringWithFormat:@"station%@",stationID];
//        [GeTuiSdk setTags:@[str]];
//        [QLUserDefaults setObject:loginTechnician forKey:userLoginState];
//        [QLUserDefaults setObject:pwd forKey:currentLoginPwd];
//        // 切换账号时清掉数据库中除系统消息外的所有消息
//        NSString *currentUserID = [QLUserDefaults objectForKey:CurrentUserId];
//        if (currentUserID != [QLUserTool sharedUserTool].userModel.strId) {
//            [MessageTool clearPushMessageAll:NO];
//        }
//        
//        // 更新 CurrentUserId
//        [[NSUserDefaults standardUserDefaults] setObject:[NSString getValidStringWithObject:[QLUserTool sharedUserTool].userModel.strId] forKey:CurrentUserId];
//        [[NSUserDefaults standardUserDefaults] synchronize];
//        
//        //发送通知
//        [QLNotificationCenter postNotificationName:Notification_setUserType object:self userInfo:nil];
        if (success) {
            success();
        }
    } whenFailure:^() {
        
    }];
}

#pragma mark - 上传图片
+ (void)requestForUploadImageWithImageType:(NSString *)imageType specifiedId:(NSString *)specifiedId images:(NSArray *)images WhenSuccess:(void (^)())success WhenFailure:(void (^)(UIImage *imageFailed, NSString *imageType))failure { //
    if (images.count <= 0) return;
    /** 图片处理 */
    NSMutableArray *arrMImageDatas = [NSMutableArray arrayWithCapacity:images.count];
    NSMutableArray *arrMExtensions = [NSMutableArray arrayWithCapacity:images.count];
    NSMutableArray *arrMMimeTypes = [NSMutableArray arrayWithCapacity:images.count];
    if (images.count > 0) {
        for (UIImage *image in images) {
            NSData *dataImage = UIImageJPEGRepresentation(image, 1);
            [arrMImageDatas addObject:dataImage];
            [arrMExtensions addObject:@".jpeg"];
            [arrMMimeTypes addObject:@"image/jpeg"];
        }
    }
    //    NSString *resId = [NSString stringWithFormat:@"%@%@", imageType, specifiedId];
    
    NSString *imageURL = [NSString stringWithFormat:@"%@",QLBaseUrlString_Image];
    [QLHttpTool postWithBaseUrl:imageURL Parameters:nil FormDatas:[arrMMimeTypes copy] FileExtensions:[arrMExtensions copy] MimeTypes:[arrMImageDatas copy] NeedCookie:NO whenSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        QLLog(@"上传图==%@,%@", responseObject,responseObject[@"err_msg"]);
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
        }
    } whenFailure:^{
        
    }];
}

@end
