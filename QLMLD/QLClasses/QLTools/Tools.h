//
//  Tools.h
//  DLSlideViewDemo
//
//  Created by kiven on 15/5/5.
//  Copyright (c) 2015年 dongle. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "sys/utsname.h"

/*缓存的Key*/
//历史搜索地址
#define ADRESSHISTORY_MODELS(city) [NSString stringWithFormat:@"searchAdressHistory%@",city]
//消息中心角标
#define MESSAGE_BADGE [NSString stringWithFormat:@"messageBadge"]
//货主订单管理角标
#define SHIPPER_BADGE [NSString stringWithFormat:@"shipperBadge"]
//司机订单管理角标
#define DRIVER_BADGE [NSString stringWithFormat:@"driverBadge"]
//轮播图
#define STOREBANNER_IMAGE [NSString stringWithFormat:@"storeHomeBanner"]

@interface Tools : NSObject

//单例
+ (Tools *)sharedInstance;

//判断字符串是否为空
+(BOOL) isBlankString:(NSString *)string;

//日期转字符串
+(NSString *) getDateString:(NSDate *)date famter:(NSString *)famter;

//写入缓存
+(void) setCache:(NSString *)fileName data:(id )array;

//读取缓存
+(id ) getCache:(NSString *)fileName;

//判断是否是emoji表情
+(BOOL)isContainsEmoji:(NSString *)string;

//字符串转josn
+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString;

//去除小数后面多余的0
+(NSString *)changeFloat:(NSString *)stringFloat;

// 把网址=截取成字典
+ (NSMutableDictionary *)webStringToDictionary:(NSString *)string;

//格式话小数 四舍五入类型
+ (NSString *) decimalwithFormat:(NSString *)format  floatV:(float)floatV;

//同城货主根据订单状态跳转到不同的页面
+ (void) inCityOrderJump:(NSString *)incityorderid;

//城际货主根据订单状态跳转到不同的页面
+ (void) outCityOrderJump:(NSString *)outcityorderid;

//司机端跳转订单详情页
+ (void) driverOrderJump:(NSString *)orderid;

//司机端跳转Vip订单详情页
+ (void) driverOrderJumpVip:(NSString *)orderid;
@end






