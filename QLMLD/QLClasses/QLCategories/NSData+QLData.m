//
//  NSData+QLData.m
//  HeartNet
//
//  Created by Shrek on 16/2/26.
//  Copyright © 2016年 Shreker. All rights reserved.
//

#import "NSData+QLData.h"
#include <CommonCrypto/CommonCrypto.h>
#include <zlib.h>

@implementation NSData (QLData)

- (NSString *)md5String {
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(self.bytes, (CC_LONG)self.length, result);
    return [NSString stringWithFormat:
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];
}

@end
