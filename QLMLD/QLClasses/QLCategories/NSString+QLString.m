//
//  NSString+QLString.m
//  WorkAssistant
//
//  Created by Shrek on 15/5/29.
//  Copyright (c) 2015年 com.homelife.manager.mobile. All rights reserved.
//

#import "NSString+QLString.h"

@implementation NSString (QLString)

+ (instancetype)getValidStringWithObject:(id)obj {
    /**
     *  nil->(null)
     *  NSNull-><null>
     */
    if ([obj isKindOfClass:[NSString class]]) {
        NSString *strValue = obj;
        if (strValue && ![strValue isEqualToString:@"<null>"]
            && ![strValue isEqualToString:@"(null)"]
            && ![strValue isEqualToString:@""]
            && ![strValue isEqualToString:@"null"]) {
            return strValue;
        } else {
            return @"";
        }
    } else if ([obj isKindOfClass:[NSNumber class]]) {
        return [NSString stringWithFormat:@"%@", obj];
    } else {
        return @"";
    }
}

- (BOOL)isEmptyString {
    if ([[NSString getValidStringWithObject:self] isEqualToString:@""]) {
        return YES;
    }
    return NO;
}

+ (BOOL)isEmptyString:(id)obj {
    NSString *string = [NSString getValidStringWithObject:obj];
    return [string isEmptyString];
}

- (BOOL)isMeaningfulString {
    return ![self isEmptyString];
}

+ (NSString *)jsonStringWithNSDictionary:(NSDictionary *)dict{
    NSData *dataJson = [NSString jsonDataWithNSDictionary:dict];
    NSString *strJson = [[NSString alloc] initWithData:dataJson encoding:NSUTF8StringEncoding];
    return strJson;
}
+ (NSData *)jsonDataWithNSDictionary:(NSDictionary *)dict{
    NSError *error = nil;
    NSData *dataJson = [NSJSONSerialization dataWithJSONObject:dict options:0 error:&error];
    if(error) {
        NSAssert(0>1, @"解析JSONObject出错");
        return nil;
    } else {
        //QLLog(@"Serialization body: %@",dict);
        return dataJson;
    }
}

+ (BOOL)isPhoneNumber:(NSString *)string {
    if ([string length] == 0) {
        return NO;
    }
    //^((13[0-9])|(15[^4,\\D])|(18[0,5-9]))\\d{8}$
    //^(0|86|17951)?(13[0-9]|15[012356789]|17[678]|18[0-9]|14[57])[0-9]{8}
    NSString *regex = @"(13[0-9]|15[012356789]|17[678]|18[0-9]|14[57])[0-9]{8}";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    BOOL isMatch = [pred evaluateWithObject:string];
    if (!isMatch) {
        return NO;
    }
    return YES;
}
//是否是固定电话
//+(BOOL)isTelephoneNum:(NSString *)string{
//    return YES;
//}
+ (BOOL)validateMobile:(NSString *)mobileNum
{
    
    /**
     
     * 手机号码
     
     * 移动：134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     
     * 联通：130,131,132,152,155,156,185,186
     
     * 电信：133,1349,153,180,189
     
     */
    
    NSString * MOBILE = @"^1(3[0-9]|5[0-35-9]|8[025-9])\\d{8}$";
    
    /**
     
     10         * 中国移动：China Mobile
     
     11         * 134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     
     12         */
    
    NSString * CM = @"^1(34[0-8]|(3[5-9]|5[017-9]|8[278])\\d)\\d{7}$";
    
    /**
     
     15         * 中国联通：China Unicom
     
     16         * 130,131,132,152,155,156,185,186
     
     17         */
    
    NSString * CU = @"^1(3[0-2]|5[256]|8[56])\\d{8}$";
    
    /**
     
     20         * 中国电信：China Telecom
     
     21         * 133,1349,153,180,189
     
     22         */
    
    NSString * CT = @"^1((33|53|8[09])[0-9]|349)\\d{7}$";
    
    /**
     
     25         * 大陆地区固话及小灵通
     
     26         * 区号：010,020,021,022,023,024,025,027,028,029
     
     27         * 号码：七位或八位
     
     28         */
    
     NSString * PHS = @"^0(10|2[0-5789]|\\d{3})\\d{7,8}$";
    
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    NSPredicate * regextestPHS = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",PHS];
    
    if(([regextestmobile evaluateWithObject:mobileNum] == YES)
       || ([regextestcm evaluateWithObject:mobileNum] == YES)
       || ([regextestct evaluateWithObject:mobileNum] == YES)
       || ([regextestcu evaluateWithObject:mobileNum] == YES)
       || ([regextestPHS evaluateWithObject:mobileNum]) == YES)
        
    {
        
        return YES;
        
    }else{
        
        return NO;
        
    }
    
}

+ (BOOL)isBankCard:(NSString *)cardNo{
    
    if (cardNo.length < 16) {
        return NO;
    }

    NSInteger oddsum = 0;     //奇数求和
    NSInteger evensum = 0;    //偶数求和
    NSInteger allsum = 0;
    NSInteger cardNoLength = (NSInteger)[cardNo length];
    // 取了最后一位数
    NSInteger lastNum = [[cardNo substringFromIndex:cardNoLength-1] intValue];
    //测试的是除了最后一位数外的其他数字
    cardNo = [cardNo substringToIndex:cardNoLength - 1];
    for (NSInteger i = cardNoLength -1 ; i>=1;i--) {
        NSString *tmpString = [cardNo substringWithRange:NSMakeRange(i-1, 1)];
        NSInteger tmpVal = [tmpString integerValue];
        if (cardNoLength % 2 ==1 ) {//卡号位数为奇数
            if((i % 2) == 0){//偶数位置
                
                tmpVal *= 2;
                if(tmpVal>=10)
                    tmpVal -= 9;
                evensum += tmpVal;
            }else{//奇数位置
                oddsum += tmpVal;
            }
        }else{
            if((i % 2) == 1){
                tmpVal *= 2;
                if(tmpVal>=10)
                    tmpVal -= 9;
                evensum += tmpVal;
            }else{
                oddsum += tmpVal;
            }
        }
    }
    
    allsum = oddsum + evensum;
    allsum += lastNum;
    if((allsum % 10) == 0)
        return YES;
    else
        return NO;
}
//+(BOOL)isValidCardNumber:(NSString *)cardNumber {
//    NSString *digitsOnly = [Tool getDigitsOnly:cardNumber];
//    int sum = 0;0h//    int digit = 0;
//    int addend = 0;
//    BOOL timesTwo = false;
//    for (int i = digitsOnly.length - 1; i >= 0; i--) {
//        digit = [digitsOnly characterAtIndex:i] - '0';
//        if (timesTwo) {
//            addend = digit * 2;
//            if (addend > 9) { addend -= 9; }
//        }else {
//            addend = digit;
//        }
//        sum += addend; timesTwo = !timesTwo;
//    }
//    int modulus = sum % 10;
//    return modulus == 0;
//}


+(NSString *)bankOfCard:(NSString *)cardNum{
    
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"BankAndBin" ofType:@"plist"];
    NSDictionary *dicBank = [[NSDictionary alloc] initWithContentsOfFile:plistPath];
    
    NSString *strPreTen = [self getPrefixStringToIndex:10 fromString:cardNum];//[cardNum substringToIndex:10];//前10位
    NSString *strPreNine = [self getPrefixStringToIndex:9 fromString:cardNum];//[cardNum substringToIndex:9];//前9位
    NSString *strPreEight = [self getPrefixStringToIndex:8 fromString:cardNum];//[cardNum substringToIndex:8];//8
    NSString *strPreSeven =[self getPrefixStringToIndex:7 fromString:cardNum];//[cardNum substringToIndex:7];//7
    NSString *strPreSix = [self getPrefixStringToIndex:6 fromString:cardNum];//[cardNum substringToIndex:6];//前6位
    NSString *strPreFive = [self getPrefixStringToIndex:5 fromString:cardNum];//[cardNum substringToIndex:5];//5
    NSString *strPreFour = [self getPrefixStringToIndex:4 fromString:cardNum];//[cardNum substringToIndex:4];//4
    NSString *strPreThree = [self getPrefixStringToIndex:3 fromString:cardNum];//[cardNum substringToIndex:3];//前三位
    
    NSString *strBankInfo = @"";
    if (dicBank[strPreThree]) {
        strBankInfo = dicBank[strPreThree];
    }else if (dicBank[strPreFour]){
        strBankInfo = dicBank[strPreFour];
    }else if (dicBank[strPreFive]){
        strBankInfo = dicBank[strPreFive];
    }else if (dicBank[strPreSix]){
        strBankInfo = dicBank[strPreSix];
    }else if (dicBank[strPreSeven]){
        strBankInfo = dicBank[strPreSeven];
    }else if (dicBank[strPreEight]){
        strBankInfo = dicBank[strPreEight];
    }else if (dicBank[strPreNine]){
        strBankInfo = dicBank[strPreNine];
    }else if (dicBank[strPreTen]){
        strBankInfo = dicBank[strPreTen];
    }else{
        strBankInfo = @"未找到匹配的发卡银行";
        return strBankInfo;
    }
    
    NSRange range =[strBankInfo rangeOfString:@" "];
    NSString *bankName = [strBankInfo substringToIndex:range.location];
    return bankName;
}
+(NSString *)getPrefixStringToIndex:(NSInteger)index fromString:(NSString *)strAll{
    if (strAll.length>=index) {
        return  [strAll substringToIndex:index];
    }else{
        return @" ";
    }
}
@end
