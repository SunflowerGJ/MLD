//
//  QLChannelDetailListVC.h
//  QLMLD
//
//  Created by syy on 2017/8/4.
//  Copyright © 2017年 Shreker. All rights reserved.
//

#import "QLViewController.h"
#import "QLChannelListDataModel.h"

@interface QLChannelDetailListVC : QLViewController
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) NSString *channelID;
@end
