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
@property (nonatomic, assign) NSInteger channelId;
@property (nonatomic, assign) NSInteger isCharge;
@property (nonatomic, assign) NSInteger isShow;
@property (nonatomic, copy) NSString *channelName;
@property (nonatomic, assign) NSInteger threeMonthPrice;
@property (nonatomic, assign) NSInteger oneMonthPrice;
@property (nonatomic, assign) NSInteger yearly;
@property (nonatomic, assign) NSInteger ROWNUM_;
@property (nonatomic, assign) NSInteger harfYearPrice;
@end

