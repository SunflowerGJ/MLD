//
//  QLChannelListDataModel.h
//  QLMLD
//
//  Created by syy on 2017/7/27.
//  Copyright © 2017年 Shreker. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QLChannelListDataModel : NSObject
@property (nonatomic, assign) NSInteger active;
@property (nonatomic, assign) NSInteger channelType;
@property (nonatomic, assign) NSInteger channel_id;
@property (nonatomic, assign) NSInteger is_charge;
@property (nonatomic, assign) NSInteger is_show;
@property (nonatomic, copy) NSString *channel_name;
@property (nonatomic, assign) NSInteger threeMonthPrice;
@property (nonatomic, assign) NSInteger three_month_price;
@property (nonatomic, assign) NSInteger yearly;
@property (nonatomic, assign) NSInteger ROWNUM_;
@property (nonatomic, assign) NSInteger harf_year_price;
@end

