//
//  QLChannelSelectListVC.h
//  QLMLD
//
//  Created by syy on 2017/8/4.
//  Copyright © 2017年 Shreker. All rights reserved.
//

#import "QLViewController.h"
#import "QLChannelListDataModel.h"

@interface QLChannelSelectListVC : QLViewController
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic,copy) void (^blockSelectedModel)(QLChannelListDataModel *model);

@end
