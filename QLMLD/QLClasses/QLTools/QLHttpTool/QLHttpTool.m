//
//  QLHttpTool.m
//  WorkAssistant
//
//  Created by macmini on 15/5/26.
//  Copyright (c) 2015年 com.homelife.manager.mobile. All rights reserved.
//

#import "QLHttpTool.h"

@implementation QLHttpTool

/**
 *  向服务器发送普通的POST请求
 *
 *  @param strBaseUrl 接口地址
 *  @param dicParams  参数字典
 *  @param success    成功回调的Block
 *  @param failure    失败回调的Block
 */
+ (void)postWithBaseUrl:(NSString *)strBaseUrl Parameters:(NSDictionary *)dicParams whenSuccess:(QLHttpToolSuccessBlock)success whenFailure:(QLHttpToolFailureBlock)failure {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject: @"text/html"];
    id cookie = [[NSUserDefaults standardUserDefaults] objectForKey:QLCookieKey];
    if (cookie) {
        [manager.requestSerializer setValue:cookie forHTTPHeaderField:@"Cookie"];
    }
    
    QLUserModel *userModel = [QLUserTool sharedUserTool].userModel;
    NSString *strUserId = userModel.strId;
    if (strUserId) {
        NSString *basicAuthStr = [QLUserDefaults objectForKey:QLKeyUserLoginToken];
        NSString *basicAuthValue = [NSString stringWithFormat:@"%@:%@",strUserId,basicAuthStr];
        NSData * basicAuthData = [basicAuthValue dataUsingEncoding:NSUTF8StringEncoding];
        NSString *basicAuth64 = [basicAuthData base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
        NSMutableString *strMul = [NSMutableString stringWithString:basicAuth64];
        [strMul replaceOccurrencesOfString:@" " withString:@"" options:NSCaseInsensitiveSearch range:NSMakeRange(0, strMul.length)];
        [strMul replaceOccurrencesOfString:@"\r" withString:@"" options:NSCaseInsensitiveSearch range:NSMakeRange(0, strMul.length)];
        [strMul replaceOccurrencesOfString:@"\n" withString:@"" options:NSCaseInsensitiveSearch range:NSMakeRange(0, strMul.length)];
        NSString *basic = [NSString stringWithFormat:@"Basic %@",strMul];
        
        [manager.requestSerializer setValue:basic forHTTPHeaderField:@"Authorization"];
    } else {
        NSDictionary *dicTemp = dicParams[@"QLHNLoginAttachedKey"];
        if ([dicTemp isKindOfClass:[NSDictionary class]]) {
            for (NSString *key in dicTemp) {
                [manager.requestSerializer setValue:dicTemp[key] forHTTPHeaderField:key];
                
            }
        }
    }
    
    [self loadCredencialForManager:manager];
    
    [manager POST:strBaseUrl parameters:dicParams success:^(AFHTTPRequestOperation *operation, id responseObject) {
        /** Save Cookie */
        NSDictionary *fields= [operation.response allHeaderFields];
        NSArray *cookies=[NSHTTPCookie cookiesWithResponseHeaderFields:fields forURL:[NSURL URLWithString:strBaseUrl]];
        if (cookies.count) {
            NSDictionary* requestFields=[NSHTTPCookie requestHeaderFieldsWithCookies:cookies];
            [[NSUserDefaults standardUserDefaults] setObject:[requestFields objectForKey:@"Cookie"] forKey:QLCookieKey];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
        
        if (success) {
            success(operation, responseObject);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSInteger statusCode = operation.response.statusCode;
        if (statusCode == 401) {
            
            UIViewController *vc = [self getCurrentVC];
            [vc presentLoginViewController];
            [QLHUDTool showErrorWithStatus:@"账号过期,请重新登录"];
            
            return ;
        }
        if (failure) {
            failure(operation, error);
        }
    }];
}

+ (void)postWithBaseUrl:(NSString *)strBaseUrl Parameters:(NSDictionary *)dicParams FormDatas:(NSArray *)arrDatas FileExtensions:(NSArray *)arrExtensions MimeTypes:(NSArray *)arrMimeTypes NeedCookie:(BOOL)isNeedCookie whenSuccess:(QLHttpToolSuccessBlock)success whenFailure:(QLHttpToolFailureBlock)failure {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    if (isNeedCookie) {
        id cookie = [[NSUserDefaults standardUserDefaults] objectForKey:QLCookieKey];
        
        [manager.requestSerializer setValue:cookie forHTTPHeaderField:@"Cookie"];
    }
    
    [self loadCredencialForManager:manager];
    
    QLUserModel *userModel = [QLUserTool sharedUserTool].userModel;
    NSString *strUserId = userModel.strId;
    if (strUserId) {
        NSString *basicAuthStr = [QLUserDefaults objectForKey:QLKeyUserLoginToken];
        NSString *basicAuthValue = [NSString stringWithFormat:@"%@:%@",strUserId,basicAuthStr];
        NSData * basicAuthData = [basicAuthValue dataUsingEncoding:NSUTF8StringEncoding];
        NSString *basicAuth64 = [basicAuthData base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
        NSMutableString *strMul = [NSMutableString stringWithString:basicAuth64];
        [strMul replaceOccurrencesOfString:@" " withString:@"" options:NSCaseInsensitiveSearch range:NSMakeRange(0, strMul.length)];
        [strMul replaceOccurrencesOfString:@"\r" withString:@"" options:NSCaseInsensitiveSearch range:NSMakeRange(0, strMul.length)];
        [strMul replaceOccurrencesOfString:@"\n" withString:@"" options:NSCaseInsensitiveSearch range:NSMakeRange(0, strMul.length)];
        NSString *basic = [NSString stringWithFormat:@"Basic %@",strMul];
        
        [manager.requestSerializer setValue:basic forHTTPHeaderField:@"Authorization"];
    }
    
    [manager POST:strBaseUrl parameters:dicParams constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        if (arrDatas && arrDatas.count > 0) {
            [arrDatas enumerateObjectsUsingBlock:^(NSData *data, NSUInteger idx, BOOL *stop) {
                NSDate *date = [NSDate date];
                NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                formatter.dateFormat = @"yyyy_MM_dd_HH_mm_ss";
                NSString *strPrefix = [formatter stringFromDate:date];
                NSString *strImageName = [NSString stringWithFormat:@"%@_%zi%@", strPrefix, idx, arrExtensions[idx]];
                [formData appendPartWithFileData:data name:@"file" fileName:strImageName mimeType:arrMimeTypes[idx]];
            }];
        }
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        /** Save Cookie */
        NSDictionary *fields= [operation.response allHeaderFields];
        NSArray *cookies=[NSHTTPCookie cookiesWithResponseHeaderFields:fields forURL:[NSURL URLWithString:strBaseUrl]];
        if (cookies.count) {
            NSDictionary* requestFields=[NSHTTPCookie requestHeaderFieldsWithCookies:cookies];
            [[NSUserDefaults standardUserDefaults] setObject:[requestFields objectForKey:@"Cookie"] forKey:QLCookieKey];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
        if (success) {
            success(operation, responseObject);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) { // 请求失败
        NSInteger statusCode = operation.response.statusCode;
        if (statusCode == 401) {
            
            UIViewController *vc = [self getCurrentVC];
            [vc presentLoginViewController];
            [QLHUDTool showErrorWithStatus:@"账号过期,请重新登录"];
            
            return ;
        }
        if (failure) {
            failure(operation, error);
        }
    }];
    
}

/**
 *  向服务器发送GET请求
 *
 *  @param strBaseUrl 接口地址
 *  @param dicParams  参数字典
 *  @param success    成功回调的Block
 *  @param failure    失败回调的Block
 */
+ (void)getWithBaseUrl:(NSString *)strBaseUrl Parameters:(NSDictionary *)dicParams whenSuccess:(QLHttpToolSuccessBlock)success whenFailure:(QLHttpToolFailureBlock)failure {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject: @"text/html"];
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:QLCookieKey]) {
        [manager.requestSerializer setValue:[[NSUserDefaults standardUserDefaults] objectForKey:QLCookieKey] forHTTPHeaderField:@"Cookie"];
    }
    
    [self loadCredencialForManager:manager];
    
    QLUserModel *userModel = [QLUserTool sharedUserTool].userModel;
    NSString *strUserId = userModel.strId;
    if (strUserId) {
        NSString *basicAuthStr = [QLUserDefaults objectForKey:QLKeyUserLoginToken];
        NSString *basicAuthValue = [NSString stringWithFormat:@"%@:%@",strUserId,basicAuthStr];
        NSData * basicAuthData = [basicAuthValue dataUsingEncoding:NSUTF8StringEncoding];
        NSString *basicAuth64 = [basicAuthData base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
        NSMutableString *strMul = [NSMutableString stringWithString:basicAuth64];
        [strMul replaceOccurrencesOfString:@" " withString:@"" options:NSCaseInsensitiveSearch range:NSMakeRange(0, strMul.length)];
        [strMul replaceOccurrencesOfString:@"\r" withString:@"" options:NSCaseInsensitiveSearch range:NSMakeRange(0, strMul.length)];
        [strMul replaceOccurrencesOfString:@"\n" withString:@"" options:NSCaseInsensitiveSearch range:NSMakeRange(0, strMul.length)];
        NSString *basic = [NSString stringWithFormat:@"Basic %@",strMul];
        
        [manager.requestSerializer setValue:basic forHTTPHeaderField:@"Authorization"];
    }
    
    [manager GET:strBaseUrl parameters:dicParams success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (success) {
            success(operation, responseObject);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSInteger statusCode = operation.response.statusCode;
        if (statusCode == 401) {
            
            UIViewController *vc = [self getCurrentVC];
            [vc presentLoginViewController];
            [QLHUDTool showErrorWithStatus:@"账号过期,请重新登录"];
            
            return ;
        }
        if (failure) {
            failure(operation, error);
        }
    }];
}

+ (void)loadCredencialForManager:(AFHTTPRequestOperationManager *)manager {
    QLUserModel *user = [QLUserTool sharedUserTool].userModel;
    if (user) {
        NSURLCredential *urlCredential = [[NSURLCredential alloc] initWithUser:user.strId password:user.strToken persistence:NSURLCredentialPersistenceForSession];
        [manager setCredential:urlCredential];
    }
}
#pragma mark - viewcontroller
//获取当前屏幕显示的viewcontroller
+ (UIViewController *)getCurrentVC
{
    UIViewController *result = nil;
    
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    if (window.windowLevel != UIWindowLevelNormal)
    {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tmpWin in windows)
        {
            if (tmpWin.windowLevel == UIWindowLevelNormal)
            {
                window = tmpWin;
                break;
            }
        }
    }
    
    UIView *frontView = [[window subviews] objectAtIndex:0];
    id nextResponder = [frontView nextResponder];
    
    if ([nextResponder isKindOfClass:[UIViewController class]])
        result = nextResponder;
    else
        result = window.rootViewController;
    
    UIViewController * vcCurrent = [self viewControllerOnly:result];
    return vcCurrent;
}
+ (UIViewController *)viewControllerOnly:(UIViewController *)vcOriginali{
    if ([vcOriginali isKindOfClass:[UINavigationController class]]) {
        UIViewController * vcLast;
        UINavigationController * nav = (UINavigationController *)vcOriginali;
        NSArray * arrVCs = nav.viewControllers;
        vcLast = [arrVCs lastObject];
        return [self viewControllerOnly:vcLast];
    }else if ([vcOriginali isKindOfClass:[UITabBarController class]]){
        UIViewController * vcLast;
        UITabBarController * vctab = (UITabBarController *)vcOriginali;
        vcLast = vctab.selectedViewController;
        return [self viewControllerOnly:vcLast];
    }else{
        return vcOriginali;
    }
}

@end
