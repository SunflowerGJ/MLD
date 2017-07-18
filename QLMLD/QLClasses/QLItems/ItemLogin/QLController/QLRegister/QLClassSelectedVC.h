//
//  QLClassSelectedVC.h
//  QLMLD
//
//  Created by syy on 2017/7/18.
//  Copyright © 2017年 Shreker. All rights reserved.
//  班级选择

#import "QLViewController.h"
#import "QLClassDataModel.h"
@interface QLClassSelectedVC : QLViewController
@property (nonatomic, strong) NSString *schoolId;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, copy) void (^blockSelectedClass)(QLClassDataModel *model);
@end
