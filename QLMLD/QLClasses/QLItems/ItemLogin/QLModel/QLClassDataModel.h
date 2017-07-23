//
//  QLClassDataModel.h
//  QLMLD
//
//  Created by syy on 2017/7/18.
//  Copyright © 2017年 Shreker. All rights reserved.
//  class info

#import <Foundation/Foundation.h>

@interface QLClassDataModel : NSObject

@property (nonatomic, assign) NSInteger ROWNUM;
@property (nonatomic, assign) NSInteger active;
@property (nonatomic, copy) NSString *update_time;
@property (nonatomic, assign) NSInteger grade_id;
@property (nonatomic, assign) NSInteger grade_code;
@property (nonatomic, assign) NSInteger upadte_user;
@property (nonatomic, copy) NSString *grade_name;
@property (nonatomic, assign) NSInteger school_id;
@end

