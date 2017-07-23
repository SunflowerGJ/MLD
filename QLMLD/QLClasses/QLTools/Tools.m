//
//  Tools.m
//  DLSlideViewDemo
//
//  Created by kiven on 15/5/5.
//  Copyright (c) 2015年 dongle. All rights reserved.
//

#import "Tools.h"

@implementation Tools

static Tools *tools;

+ (Tools *)sharedInstance
{
    if (!tools){
        tools = [[Tools alloc] init];
    }
    return tools;
}

//判断字符串是否为空
+ (BOOL) isBlankString:(NSString *)string {
    if (string == nil || string == NULL) {
        return YES;
    }
    if ([string isKindOfClass:[NSNull class]]) {
        return YES;
    }
    if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0) {
        return YES;
    }
    return NO;
}

//日期转字符串
+(NSString *) getDateString:(NSDate *)date famter:(NSString *)famter{
    //实例化一个NSDateFormatter对象
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //设定时间格式,这里可以设置成自己需要的格式
    [dateFormatter setDateFormat:famter];
    //用[NSDate date]可以获取系统当前时间
    return [dateFormatter stringFromDate:date];
}

//写入缓存
+(void) setCache:(NSString *)fileName data:(id )array{
    //获取缓存目录
    NSArray *cacPath = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *cachePath = [cacPath objectAtIndex:0];
    
    ///写入缓存
    if (!cachePath) {
        QLLog(@"目录未找到");
    }else {
        cachePath=[NSString stringWithFormat:@"%@/liChiCache",cachePath];
        NSFileManager *fileManager = [NSFileManager defaultManager];
        BOOL existed = [fileManager fileExistsAtPath:cachePath];
        if(!existed){
            [fileManager createDirectoryAtPath:cachePath withIntermediateDirectories:YES attributes:nil error:nil];
        }
        NSString *filePaht = [cachePath stringByAppendingPathComponent:fileName];
        [NSKeyedArchiver archiveRootObject:array toFile:filePaht];
    }
}

//读取缓存
+(id ) getCache:(NSString *)fileName{
    //获取缓存目录
    NSArray *cacPath = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *cachePath = [cacPath objectAtIndex:0];
    cachePath=[NSString stringWithFormat:@"%@/liChiCache",cachePath];
    NSString *readPath = [cachePath stringByAppendingPathComponent:fileName];
    return [NSKeyedUnarchiver unarchiveObjectWithFile:readPath];
}

//判断是否是emoji表情
+(BOOL)isContainsEmoji:(NSString *)string {
    __block BOOL isEomji = NO;
    [string enumerateSubstringsInRange:NSMakeRange(0, [string length]) options:NSStringEnumerationByComposedCharacterSequences usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
        const unichar hs = [substring characterAtIndex:0];
        // surrogate pair
        if (0xd800 <= hs && hs <= 0xdbff) {
            if (substring.length > 1) {
                const unichar ls = [substring characterAtIndex:1];
                const int uc = ((hs - 0xd800) * 0x400) + (ls - 0xdc00) + 0x10000;
                if (0x1d000 <= uc && uc <= 0x1f77f) {
                    isEomji = YES;
                }
            }
        } else {
            // non surrogate
            if (0x2100 <= hs && hs <= 0x27ff && hs != 0x263b) {
                isEomji = YES;
            } else if (0x2B05 <= hs && hs <= 0x2b07) {
                isEomji = YES;
            } else if (0x2934 <= hs && hs <= 0x2935) {
                isEomji = YES;
            } else if (0x3297 <= hs && hs <= 0x3299) {
                isEomji = YES;
            } else if (hs == 0xa9 || hs == 0xae || hs == 0x303d || hs == 0x3030 || hs == 0x2b55 || hs == 0x2b1c || hs == 0x2b1b || hs == 0x2b50|| hs == 0x231a ) {
                isEomji = YES;
            }
            if (!isEomji && substring.length > 1) {
                const unichar ls = [substring characterAtIndex:1];
                if (ls == 0x20e3) {
                    isEomji = YES;
                }
            }
        }
    }];
    return isEomji;
}

//字符串转josn
+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString {
    if (jsonString == nil) {
        return nil;
    }
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err) {
        QLLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}

//去除小数后面多余的0
+(NSString *)changeFloat:(NSString *)stringFloat
{
    const char *floatChars = [stringFloat UTF8String];
    NSUInteger length = [stringFloat length];
    NSUInteger zeroLength = 0;
    int i = length-1;
    for(; i>=0; i--)
    {
        if(floatChars[i] == '0'/*0x30*/) {
            zeroLength++;
        } else {
            if(floatChars[i] == '.')
                i--;
            break;
        }
    }
    NSString *returnString;
    if(i == -1) {
        returnString = @"0";
    } else {
        returnString = [stringFloat substringToIndex:i+1];
    }
    return returnString;
}

// 把网址=截取成字典
+ (NSMutableDictionary *)webStringToDictionary:(NSString *)string{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    NSString *str = [[string componentsSeparatedByString:@"?"] lastObject];
    NSArray *webArray = [str componentsSeparatedByString:@"&"];
    for (int i = 0; i < [webArray count]; i++) {
        NSArray *array = [webArray[i] componentsSeparatedByString:@"="];
        NSString *key = [array firstObject];
        NSString *item = [array lastObject];
        [dic setValue:item forKey:key];
    }
    return dic;
}

//格式话小数 四舍五入类型
+ (NSString *) decimalwithFormat:(NSString *)format  floatV:(float)floatV
{
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setPositiveFormat:format];
    return  [numberFormatter stringFromNumber:[NSNumber numberWithFloat:floatV]];
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
        QLLog(@"上传图==%@", responseObject);
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
        }
    } whenFailure:^{
        
    }];
}
@end

