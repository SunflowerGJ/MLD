//
//  QLHttpTool.m
//  WorkAssistant
//
//  Created by macmini on 15/5/26.
//  Copyright (c) 2015年 com.homelife.manager.mobile. All rights reserved.
//

#import "QLHttpTool.h"
#import "QLHttpTool.h"
#define phoneno_default @"11111111111"

@implementation QLHttpTool
+ (void)certificateParameters:(NSDictionary *)dicParams whenSuccess:(QLHttpToolSuccessBlock)success whenFailure:(QLHttpToolFailureBlock)failure {
    NSString *urlString = @"https://pay.csc56.com/qlpay/tran_recharge_precreate";
    NSString *cerPath = [[NSBundle mainBundle] pathForResource:@"csc56" ofType:@"cer"];
    NSData * certData =[NSData dataWithContentsOfFile:cerPath];
    NSSet * certSet = [[NSSet alloc] initWithObjects:certData, nil];
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeCertificate];
    // 是否允许,NO-- 不允许无效的证书
    [securityPolicy setAllowInvalidCertificates:YES];
    
    //是否信任服务器无效或过期的SSL证书。默认为“不”。
    
    securityPolicy.allowInvalidCertificates = YES;//是否允许使用自签名证书
    
    //是否验证域名证书的CN字段。默认为“是”。
    
    securityPolicy.validatesDomainName = NO;
    NSArray *sortDesc = @[[[NSSortDescriptor alloc] initWithKey:nil ascending:YES]];
    NSArray *sortSetArray = [certSet sortedArrayUsingDescriptors:sortDesc];
    // 设置证书
    [securityPolicy setPinnedCertificates:sortSetArray];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.securityPolicy = securityPolicy;
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    // request
    AFHTTPRequestOperationManager* mgr = [AFHTTPRequestOperationManager manager];
    mgr.securityPolicy = securityPolicy;
    
    [manager GET:urlString parameters:dicParams success:^(NSURLSessionDataTask *task, id responseObject) {
        if (success) {
            success(task, responseObject);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        QLLog(@"task:%@, error:%@",task,error);
    }];
}
/** 注册 */
+ (void)registerWithBaseUrl:(NSString *)strBaseUrl Parameters:(NSDictionary *)dicParams whenSuccess:(QLHttpToolSuccessBlock)success whenFailure:(QLHttpToolFailureBlock)failure {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject: @"text/html"];
    //    [manager.requestSerializer setValue:@"text/html; application/json; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [manager.securityPolicy setAllowInvalidCertificates:YES];
    
    [self loadCredencialForManager:manager]; //strUserId?copyDicParams:dicParams
    [manager POST:strBaseUrl parameters:dicParams success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (responseObject&&[responseObject[@"success"] boolValue]) {
            success(operation, responseObject);
        }else{
            [QLHUDTool showAlertMessage:[responseObject objectForKey:@"msg"]];
            failure();
        }
       
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [QLHUDTool showErrorWithStatus:@"请求失败,请稍后再试"];
        failure();
    }];
}
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
    //    [manager.requestSerializer setValue:@"text/html; application/json; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [manager.securityPolicy setAllowInvalidCertificates:YES];
    
    //单点登录
    QLUserModel *userModel = [QLUserTool sharedUserTool].userModel;
    
    NSMutableDictionary *copyDicParams;
    if (userModel.user_id) {
        //如果用户登录的情况下,传入userid和cookie参数
        if(dicParams){
            copyDicParams = [[NSMutableDictionary alloc] initWithDictionary:dicParams] ;
        }else{
            copyDicParams =[[NSMutableDictionary alloc] init] ;
        }
        [copyDicParams setObject:[NSString stringWithFormat:@"%@",[NSString stringWithFormat:@"%ld",userModel.user_id]] forKey:@"user_id"];
        [copyDicParams setObject:TOKEN forKey:@"token"];
    }else{
        if(dicParams){
            copyDicParams = [[NSMutableDictionary alloc] initWithDictionary:dicParams] ;
        }else{
            copyDicParams =[[NSMutableDictionary alloc] init] ;
        }
        [copyDicParams setObject:TOKEN forKey:@"token"];
    }
    
    [self loadCredencialForManager:manager]; //strUserId?copyDicParams:dicParams
    [manager POST:strBaseUrl parameters:copyDicParams success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (responseObject&&[responseObject[@"success"] boolValue]) {
            success(operation, responseObject);
        }else{
             [QLHUDTool showErrorWithStatus:[responseObject objectForKey:@"msg"]];
             failure();
        }
        return ;
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [QLHUDTool showErrorWithStatus:@"请求失败,请稍后再试"];
        failure();
    }];
}
+ (void)postWithTestBaseUrl:(NSString *)strBaseUrl Parameters:(NSDictionary *)dicParams whenSuccess:(QLHttpToolSuccessBlock)success whenFailure:(QLHttpToolFailureBlock)failure {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject: @"text/html"];
    [manager.securityPolicy setAllowInvalidCertificates:YES];
    
    //单点登录
    QLUserModel *userModel = [QLUserTool sharedUserTool].userModel;
    NSString *strUserId = [NSString stringWithFormat:@"%ld",userModel.user_id];
    NSMutableDictionary *copyDicParams;
    if (strUserId) {
        //如果用户登录的情况下,传入userid和cookie参数
        if(dicParams){
            copyDicParams = [[NSMutableDictionary alloc] initWithDictionary:dicParams] ;
        }else{
            copyDicParams =[[NSMutableDictionary alloc] init] ;
        }
        [copyDicParams setObject:strUserId forKey:@"userId"];
        [copyDicParams setObject:[[UIDevice currentDevice].identifierForVendor UUIDString] forKey:@"cookie"];
    }
    [self loadCredencialForManager:manager];
    [manager POST:strBaseUrl parameters:strUserId?copyDicParams:dicParams success:^(AFHTTPRequestOperation *operation, id responseObject) {
        QLLog(@"errorCode==%@",[responseObject objectForKey:@"err_code"]);
        success(operation, responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [QLHUDTool showErrorWithStatus:@"请求失败,请稍后再试"];
        failure();
    }];
}

//多图
+ (void)postWithBaseUrl:(NSString *)strBaseUrl Parameters:(NSDictionary *)dicParams FormDatas:(NSArray *)arrDatas FileExtensions:(NSArray *)arrExtensions MimeTypes:(NSArray *)arrMimeTypes NeedCookie:(BOOL)isNeedCookie whenSuccess:(QLHttpToolSuccessBlock)success whenFailure:(QLHttpToolFailureBlock)failure {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager.securityPolicy setAllowInvalidCertificates:YES];
    
    if (isNeedCookie) {
        id cookie = [[NSUserDefaults standardUserDefaults] objectForKey:QLCookieKey];
        
        [manager.requestSerializer setValue:cookie forHTTPHeaderField:@"Cookie"];
    }
    
    [self loadCredencialForManager:manager];
    
    QLUserModel *userModel = [QLUserTool sharedUserTool].userModel;
    NSMutableDictionary *copyDicParams;
    if (userModel.user_id) {
        //如果用户登录的情况下,传入userid和cookie参数
        if(dicParams){
            copyDicParams = [[NSMutableDictionary alloc] initWithDictionary:dicParams] ;
        }else{
            copyDicParams =[[NSMutableDictionary alloc] init] ;
        }
        [copyDicParams setObject:[NSString stringWithFormat:@"%ld",userModel.user_id] forKey:@"user_id"];
        [copyDicParams setObject:TOKEN forKey:@"token"];
    }else{
        if(dicParams){
            copyDicParams = [[NSMutableDictionary alloc] initWithDictionary:dicParams] ;
        }else{
            copyDicParams =[[NSMutableDictionary alloc] init] ;
        }
        [copyDicParams setObject:TOKEN forKey:@"token"];
    }
    
    [manager POST:strBaseUrl parameters:copyDicParams constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
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
            failure();
        }
    }];
    
}

/** 单图 */
+ (void)postPerWithBaseUrl:(NSString *)strBaseUrl Parameters:(NSDictionary *)dicParams FormData:(NSData *)imgData FileExtension:(NSString *)imgExtension MimeType:(NSString *)imgType whenSuccess:(QLHttpToolSuccessBlock)success whenFailure:(QLHttpToolFailureBlock)failure {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager.securityPolicy setAllowInvalidCertificates:YES];
    
    //单点登录
    QLUserModel *userModel = [QLUserTool sharedUserTool].userModel;
    NSMutableDictionary *copyDicParams;
    if (userModel.user_id) {
        //如果用户登录的情况下,传入userid和cookie参数
        if(dicParams){
            copyDicParams = [[NSMutableDictionary alloc] initWithDictionary:dicParams] ;
        }else{
            copyDicParams =[[NSMutableDictionary alloc] init] ;
        }
        [copyDicParams setObject:[NSString stringWithFormat:@"%ld",(long)userModel.user_id] forKey:@"user_id"];
        [copyDicParams setObject:TOKEN forKey:@"token"];
    }else{
        if(dicParams){
            copyDicParams = [[NSMutableDictionary alloc] initWithDictionary:dicParams] ;
        }else{
            copyDicParams =[[NSMutableDictionary alloc] init] ;
        }
//        [copyDicParams setObject:@"filePart" forKey:@"filePart"];
    }
    
    [manager POST:strBaseUrl parameters:copyDicParams constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        NSDate *date = [NSDate date];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"yyyy_MM_dd_HH_mm_ss";
        NSString *strPrefix = [formatter stringFromDate:date];
        NSString *strImageName = [NSString stringWithFormat:@"%@_%@", strPrefix,imgExtension];
        [formData appendPartWithFileData:imgData name:@"imgFile" fileName:strImageName mimeType:imgType];
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if([responseObject objectForKey:@"success"]&&[[responseObject objectForKey:@"success"] boolValue]){
            //请求成功
            success(operation, responseObject);
        }
        /*else if([responseObject objectForKey:@"success"]&&([[responseObject objectForKey:@"success"] integerValue]==-3||[[responseObject objectForKey:@"err_code"] integerValue]==-4)){
            [QLHUDTool dissmis];
            if([QLUserTool sharedUserTool].userModel.strId){
                //清除登录信息
                [GeTuiSdk unbindAlias:[QLUserTool sharedUserTool].userModel.strAccount andSequenceNum:KGtSeriNum];
                [[QLUserTool sharedUserTool] clearCurrentUserModel];
                //                [[NSUserDefaults standardUserDefaults] setObject:LOGINISOWNER forKey:USERLOGINSTATE];
                //被踢下线,这里清除用户登录信息
                if([[responseObject objectForKey:@"err_code"] integerValue]==-3){
                    UIAlertView *alertView= [[UIAlertView alloc] initWithTitle:@"提示" message:@"当前账号在其他地方登录，被迫下线..." delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                    [alertView show];
                }
                if([[responseObject objectForKey:@"err_code"] integerValue]==-4){
                    UIAlertView *alertView= [[UIAlertView alloc] initWithTitle:@"提示" message:@"当前账号已失效，请重新登录..." delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                    [alertView show];
                }
            }
            failure();
        }*/
        else{
            if([responseObject objectForKey:@"msg"]){
                //请求错误(服务器错误)
                [QLHUDTool showErrorWithStatus:[responseObject objectForKey:@"msg"]];
                QLLog(@"错误信息== %@",[responseObject objectForKey:@"msg"]);
            }
            failure();
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) { // 请求失败
        [QLHUDTool showErrorWithStatus:@"请求失败,请稍后再试"];
        failure();
    }];}


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
    [manager.securityPolicy setAllowInvalidCertificates:YES];
    
    //单点登录
    QLUserModel *userModel = [QLUserTool sharedUserTool].userModel;
    NSString *strUserId = [NSString stringWithFormat:@"%ld",userModel.user_id];
    NSMutableDictionary *copyDicParams;
    if (strUserId) {
        //如果用户登录的情况下,传入userid和cookie参数
        if(dicParams){
            copyDicParams = [[NSMutableDictionary alloc] initWithDictionary:dicParams] ;
        }else{
            copyDicParams =[[NSMutableDictionary alloc] init] ;
        }
        [copyDicParams setObject:strUserId forKey:@"user_id"];
        [copyDicParams setObject:TOKEN forKey:@"token"];
    }
    [self loadCredencialForManager:manager];
    [manager GET:strBaseUrl parameters:strUserId?copyDicParams:dicParams success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if([responseObject objectForKey:@"success"]&&[[responseObject objectForKey:@"success"] boolValue]){
            //请求成功
            success(operation, responseObject);
        }else{
            [QLHUDTool showAlertMessage:responseObject[@"msg"]];
            failure();
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [QLHUDTool showErrorWithStatus:@"请求失败,请稍后再试"];
        failure();
    }];
}

//用户踢下线
+ (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) {
        //这里处理用户踢下线以后返回登录页面
        [[QLUserTool sharedUserTool] logout];
    }
}

+ (void)loadCredencialForManager:(AFHTTPRequestOperationManager *)manager {
    QLUserModel *user = [QLUserTool sharedUserTool].userModel;
    if (user) {
//        NSURLCredential *urlCrxedential = [[NSURLCredential alloc] initWithUser:user.strAccount password:user. persistence:NSURLCredentialPersistenceForSession];
//        [manager setCredential:urlCredential];
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
