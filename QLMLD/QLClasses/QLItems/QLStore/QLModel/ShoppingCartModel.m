//
//  ShoppingCartModel.m
//  technician
//
//  Created by syy on 2016/12/14.
//  Copyright © 2016年 cn.forp.app. All rights reserved.
//

#import "ShoppingCartModel.h"
static NSString * const QLCodingKeyStrID = @"QLCodingKeyStrID";
static NSString * const QLKeyCount = @"QLKeyCount";
@implementation ShoppingCartModel
-(instancetype)initShoppingCartDataWithDictionary:(NSDictionary *)dicData{
    if (self = [super init]) {
        _strID = [NSString getValidStringWithObject:dicData[@"strID"]];
        _cartName = [NSString getValidStringWithObject:dicData[@"cartName"]];
        _cartPrice = [NSString getValidStringWithObject:dicData[@"cartPrice"]];
        _cartCount = [NSString getValidStringWithObject:dicData[@"cartCount"]];
    }
    return self ;
}


#pragma mark NSCoding
- (void)encodeWithCoder:(NSCoder *)coder {
    [coder encodeObject:_strID forKey:QLCodingKeyStrID];
    [coder encodeObject:_cartCount forKey:QLKeyCount];
}

- (instancetype)initWithCoder:(NSCoder *)decoder {
    if (self = [super init]) {
        _strID = [decoder decodeObjectForKey:QLCodingKeyStrID];
        _cartCount = [decoder decodeObjectForKey:QLKeyCount];
    }
    return self;
}

@end
