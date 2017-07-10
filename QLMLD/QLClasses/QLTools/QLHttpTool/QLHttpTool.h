//
//  QLHttpTool.h
//  WorkAssistant
//
//  Created by macmini on 15/5/26.
//  Copyright (c) 2015年 com.homelife.manager.mobile. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"

static NSString * const QLCookieKey = @"QLCookieKey";
static NSString * const QLKeyUserLoginToken = @"QLKeyUserLoginToken";

typedef void(^QLHttpToolSuccessBlock)(AFHTTPRequestOperation *operation, id responseObject);
typedef void(^QLHttpToolFailureBlock)();

@interface QLHttpTool : NSObject<UIAlertViewDelegate>
+ (void)certificateParameters:(NSDictionary *)dicParams whenSuccess:(QLHttpToolSuccessBlock)success whenFailure:(QLHttpToolFailureBlock)failure;
/**
 *  向服务器发送普通的POST请求
 *
 *  @param strBaseUrl 接口地址
 *  @param dicParams  参数字典
 *  @param success    成功回调的Block
 *  @param failure    失败回调的Block
 */
+ (void)postWithBaseUrl:(NSString *)strBaseUrl Parameters:(NSDictionary *)dicParams whenSuccess:(QLHttpToolSuccessBlock)success whenFailure:(QLHttpToolFailureBlock)failure;
+ (void)postWithTestBaseUrl:(NSString *)strBaseUrl Parameters:(NSDictionary *)dicParams whenSuccess:(QLHttpToolSuccessBlock)success whenFailure:(QLHttpToolFailureBlock)failure;
+ (void)postWithBaseUrl:(NSString *)strBaseUrl Parameters:(NSDictionary *)dicParams FormDatas:(NSArray *)arrDatas FileExtensions:(NSArray *)arrExtensions MimeTypes:(NSArray *)arrMimeTypes NeedCookie:(BOOL)isNeedCookie whenSuccess:(QLHttpToolSuccessBlock)success whenFailure:(QLHttpToolFailureBlock)failure;

/** 单图 */
+ (void)postPerWithBaseUrl:(NSString *)strBaseUrl Parameters:(NSDictionary *)dicParams FormData:(NSData *)imgData FileExtension:(NSString *)imgExtension MimeType:(NSString *)imgType whenSuccess:(QLHttpToolSuccessBlock)success whenFailure:(QLHttpToolFailureBlock)failure;
/**
 *  向服务器发送GET请求
 *
 *  @param strBaseUrl 接口地址
 *  @param dicParams  参数字典
 *  @param success    成功回调的Block
 *  @param failure    失败回调的Block
 */
+ (void)getWithBaseUrl:(NSString *)strBaseUrl Parameters:(NSDictionary *)dicParams whenSuccess:(QLHttpToolSuccessBlock)success whenFailure:(QLHttpToolFailureBlock)failure;


/**
 *  获得当前ViewController
 *
 */
+ (UIViewController *)getCurrentVC;


@end
