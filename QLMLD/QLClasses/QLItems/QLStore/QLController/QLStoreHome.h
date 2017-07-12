//
//  QLStoreHome.h
//  QLMLD
//
//  Created by 英英 on 2017/7/2.
//  Copyright © 2017年 Shreker. All rights reserved.
//

#import "QLViewController.h"
#import "SDCycleScrollView.h"

@interface QLStoreHome : QLViewController<SDCycleScrollViewDelegate>
@property (strong ,nonatomic) NSMutableArray *dataSource;
@property (weak, nonatomic) IBOutlet SDCycleScrollView *myHeaderImg;
@end
