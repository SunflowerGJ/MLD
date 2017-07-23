//
//  QLOrderListVC.h
//  QLMLD
//
//  Created by 英英 on 2017/7/23.
//  Copyright © 2017年 Shreker. All rights reserved.
//  订单列表

#import "QLViewController.h"
typedef NS_ENUM(NSUInteger, OrderListType) {
    OrderListTypeAll = 0,
    OrderListTypeWaitSend = 1,
    OrderListTypeWaitReceive = 2
};

@interface QLOrderListVC : QLViewController
@property (nonatomic, assign) OrderListType orderType;
@property (nonatomic, strong) NSMutableArray *dataSource;
@end
