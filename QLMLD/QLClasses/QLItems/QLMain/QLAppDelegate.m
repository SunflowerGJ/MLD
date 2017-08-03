//
//  QLAppDelegate.m
//  QLProjectDemo
//
//  Created by Shrek on 15/12/4.
//  Copyright © 2015年 Shreker. All rights reserved.
//

#import "QLAppDelegate.h"
#import "QLNavigationController.h"
#import "QLMainViewController.h"
#import "QLLoginViewController.h"
#import "QLGuideViewController.h"
#import <UserNotifications/UserNotifications.h>
#import "GeTuiSdk.h"

@interface QLAppDelegate ()<GeTuiSdkDelegate,UNUserNotificationCenterDelegate>

@end

@implementation QLAppDelegate
//个推实现聊天功能
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [[IQKeyboardManager sharedManager] setEnable:YES];
    [self changeRootViewControllerToLogin];
    [self registerUserNotification];
    [WXApi registerApp:WXpay_APP_ID withDescription:@"MLD"];

    return YES;
    // Change Root View Controller
    NSString *strVersionKey = (NSString *)kCFBundleVersionKey;
    NSString *strVersionPrevious = [[NSUserDefaults standardUserDefaults] stringForKey:strVersionKey];
    NSString *strVersionCurrent = [NSBundle mainBundle].infoDictionary[strVersionKey];
    if ([strVersionCurrent isEqualToString:strVersionPrevious]) {
        [self changeRootViewControllerToLogin];
    } else {
        [[NSUserDefaults standardUserDefaults] setObject:strVersionCurrent forKey:strVersionKey];
        [[NSUserDefaults standardUserDefaults] synchronize];
        QLGuideViewController *vcNewFeature = [[QLGuideViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
        self.window.rootViewController = vcNewFeature;
    }
}

- (void)changeRootViewControllerToMain {
    QLMainViewController *vcMain = [QLMainViewController new];
    self.window.rootViewController = [[QLNavigationController alloc] initWithRootViewController:vcMain];
}
- (void)changeRootViewControllerToLogin {
    NSString *strUserID = [NSString stringWithFormat:@"%ld",[QLUserTool sharedUserTool].userModel.user_id];
    if (strUserID&&![strUserID isEqualToString:@"0"]) {
        QLMainViewController *vcMain = [QLMainViewController new];
        self.window.rootViewController = [[QLNavigationController alloc] initWithRootViewController:vcMain];
    }else{
        QLLoginViewController *loginViewController = [QLLoginViewController new];
        self.window.rootViewController = [[QLNavigationController alloc] initWithRootViewController:loginViewController];
    }
}


#pragma mark - 推送
/** 注册个推 */
- (void)registerUserNotification {
    // 通过 appId、 appKey 、appSecret 启动SDK，注：该方法需要在主线程中调用
    [GeTuiSdk startSdkWithAppId:kGtAppId appKey:kGtAppKey appSecret:kGtAppSecret delegate:self];
    
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 10.0) {
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0 // Xcode 8编译会调用
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        center.delegate = self;
        [center requestAuthorizationWithOptions:(UNAuthorizationOptionBadge | UNAuthorizationOptionSound | UNAuthorizationOptionAlert | UNAuthorizationOptionCarPlay) completionHandler:^(BOOL granted, NSError *_Nullable error) {
            if (!error) {
                NSLog(@"request authorization succeeded!");
            }
        }];
        
        [[UIApplication sharedApplication] registerForRemoteNotifications];
#else // Xcode 7编译会调用
        UIUserNotificationType types = (UIUserNotificationTypeAlert | UIUserNotificationTypeSound | UIUserNotificationTypeBadge);
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:types categories:nil];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
#endif
    } else if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
        UIUserNotificationType types = (UIUserNotificationTypeAlert | UIUserNotificationTypeSound | UIUserNotificationTypeBadge);
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:types categories:nil];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
    } else {
        UIRemoteNotificationType apn_type = (UIRemoteNotificationType)(UIRemoteNotificationTypeAlert |
                                                                       UIRemoteNotificationTypeSound |
                                                                       UIRemoteNotificationTypeBadge);
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:apn_type];
    }}

/** 已登记用户通知 */
- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings {
    // 注册远程通知（推送）
    [application registerForRemoteNotifications];
}

#pragma mark - 远程通知(推送)回调
/** 远程通知注册成功委托 */
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    NSString *token = [[deviceToken description] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
    token = [token stringByReplacingOccurrencesOfString:@" " withString:@""];
    QLLog(@"\n>>>[DeviceToken Success]:%@\n\n", deviceToken);
    // [3]:向个推服务器注册deviceToken
    [GeTuiSdk registerDeviceToken:token];
}

/** 远程通知注册失败委托 */
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    QLLog(@"\n>>>[DeviceToken Error]:%@\n\n", error.description);
}

#pragma mark - APP运行中接收到通知(推送)处理

/** APP已经接收到“远程”通知(推送) - (App运行在后台/App运行在前台) */
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    application.applicationIconBadgeNumber = 0; // 标签
    
    QLLog(@"\n>>>[Receive RemoteNotification]:%@\n\n", userInfo);
}
#pragma mark - iOS 10中收到推送消息

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0
//  iOS 10: App在前台获取到通知
- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler {
    
    NSLog(@"willPresentNotification：%@", notification.request.content.userInfo);
    
    // 根据APP需要，判断是否要提示用户Badge、Sound、Alert
    completionHandler(UNNotificationPresentationOptionBadge | UNNotificationPresentationOptionSound | UNNotificationPresentationOptionAlert);
}

//  iOS 10: 点击通知进入App时触发
- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler {
    
    NSLog(@"didReceiveNotification：%@", response.notification.request.content.userInfo);
    
    // [ GTSdk ]：将收到的APNs信息传给个推统计
    [GeTuiSdk handleRemoteNotification:response.notification.request.content.userInfo];
    
    completionHandler();
}
#endif

/** APP已经接收到“远程”通知(推送) - 透传推送消息  ios10 以下版本*/
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult result))completionHandler {
    application.applicationIconBadgeNumber = 0;
    [GeTuiSdk handleRemoteNotification:userInfo];
    completionHandler(UIBackgroundFetchResultNewData);
    
    // 处理APN
    QLLog(@"\n>>>[Receive RemoteNotification - Background Fetch]:%@\n\n", userInfo);
    NSDictionary *msgDic = [Tools dictionaryWithJsonString:[userInfo objectForKey:@"payload"]];
    QLLog(@"msg == %@",msgDic);
    
    completionHandler(UIBackgroundFetchResultNewData);
}

#pragma mark - GeTuiSdkDelegate

/** SDK启动成功返回cid */
- (void)GeTuiSdkDidRegisterClient:(NSString *)clientId {
    // [4-EXT-1]: 个推SDK已注册，返回clientId
    QLLog(@"\n>>>[GeTuiSdk RegisterClient]:%@\n\n", clientId);
}

/** SDK遇到错误回调 */
- (void)GeTuiSdkDidOccurError:(NSError *)error {
    // [EXT]:个推错误报告，集成步骤发生的任何错误都在这里通知，如果集成后，无法正常收到消息，查看这里的通知。
    QLLog(@"\n>>>[GexinSdk error]:%@\n\n", [error localizedDescription]);
}


/** SDK收到透传消息回调 */
- (void)GeTuiSdkDidReceivePayloadData:(NSData *)payloadData andTaskId:(NSString *)taskId andMsgId:(NSString *)msgId andOffLine:(BOOL)offLine fromGtAppId:(NSString *)appId {
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    // [4]: 收到个推消息
    NSString *payloadMsg = nil;
    if (payloadData) {
        payloadMsg = [[NSString alloc] initWithBytes:payloadData.bytes length:payloadData.length encoding:NSUTF8StringEncoding];
        NSDictionary *msgDic = [Tools dictionaryWithJsonString:payloadMsg];

        NSString *msg = [NSString stringWithFormat:@"taskId=%@,messageId:%@,payloadMsg:%@%@", taskId, msgId, payloadMsg, offLine ? @"<离线消息>" : @""];
        QLLog(@"\n>>>[GexinSdk ReceivePayload]:%@\n\n", msg);
        
        //本地提示
        if(!offLine){
            
                if([[msgDic objectForKey:@"type"] integerValue]==2||[[msgDic objectForKey:@"type"] integerValue]==3||[[msgDic objectForKey:@"type"] integerValue]==4||[[msgDic objectForKey:@"type"] integerValue]==5||[[msgDic objectForKey:@"type"] integerValue]==8||[[msgDic objectForKey:@"type"] integerValue]==10||[[msgDic objectForKey:@"type"] integerValue]==11){
                    return;
                }
           
            UIView *alertView = [[UIView alloc] initWithFrame:CGRectMake(0, -64, QLScreenWidth, 44)];
            UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(45, 20, QLScreenWidth-40, 44)];
            titleLabel.textColor = [UIColor whiteColor];
            titleLabel.text = [msgDic objectForKey:@"title"];
            titleLabel.font = [UIFont boldSystemFontOfSize:15];
            UIImageView *titleImg = [[UIImageView alloc] initWithFrame:CGRectMake(15, 31, 22, 22)];
            titleImg.image = [UIImage imageNamed:@"lightbulb"];
            [alertView addSubview:titleImg];
            [alertView addSubview:titleLabel];
            alertView.backgroundColor = QLYellowColor;
            [self.window addSubview:alertView];
            
            [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionAllowUserInteraction animations:^{
                alertView.frame = CGRectMake(0, 0, QLScreenWidth, 64);
            } completion:^(BOOL finished) {
                [UIView animateWithDuration:0.5 delay:2 options:UIViewAnimationOptionAllowUserInteraction animations:^{
                    alertView.frame = CGRectMake(0, -64, QLScreenWidth, 64);
                } completion:^(BOOL finished) {
                    [alertView removeFromSuperview];
                }];
            }];
        }
    }
}
/** SDK收到sendMessage消息回调 */
- (void)GeTuiSdkDidSendMessage:(NSString *)messageId result:(int)result {
    // [4-EXT]:发送上行消息结果反馈
    NSString *msg = [NSString stringWithFormat:@"sendmessage=%@,result=%d", messageId, result];
    QLLog(@"\n>>>[GexinSdk DidSendMessage]:%@\n\n", msg);
}

/** SDK运行状态通知 */
- (void)GeTuiSDkDidNotifySdkState:(SdkStatus)aStatus {
    // [EXT]:通知SDK运行状态
    QLLog(@"\n>>>[GexinSdk SdkState]:%u\n\n", aStatus);
}

/** SDK设置推送模式回调 */
- (void)GeTuiSdkDidSetPushMode:(BOOL)isModeOff error:(NSError *)error {
    if (error) {
        QLLog(@"\n>>>[GexinSdk SetModeOff Error]:%@\n\n", [error localizedDescription]);
        return;
    }
    QLLog(@"\n>>>[GexinSdk SetModeOff]:%@\n\n", isModeOff ? @"开启" : @"关闭");
}


@end
