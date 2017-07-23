//
//  QLKinderSelectedVC.h
//  QLMLD
//
//  Created by syy on 2017/7/18.
//  Copyright © 2017年 Shreker. All rights reserved.
//  幼儿园选择

#import "QLViewController.h"
#import "QLKinderDataModel.h"
#import "QLClassDataModel.h"
@interface QLKinderSelectedVC : QLViewController
@property (nonatomic, assign) BOOL fromClassCircle;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, copy) void (^blockSelectedSchool)(QLKinderDataModel *model,QLClassDataModel *classModel);
@property (nonatomic, copy) void (^blockSchool)(QLKinderDataModel *model);

@end
