//
//  ShoppingCartModel.h
//  technician
//
//  Created by syy on 2016/12/14.
//  Copyright © 2016年 cn.forp.app. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ShoppingCartModel : NSObject
@property (nonatomic ,strong) NSString *strID;
@property (nonatomic ,strong) NSString *cartName;
@property (nonatomic ,strong) NSString *cartPrice;
@property (nonatomic ,strong) NSString *cartCount;

-(instancetype)initShoppingCartDataWithDictionary:(NSDictionary *)dicData;

@end
