//
//  QLAdmissionHomeDataModel.h
//  QLMLD
//
//  Created by syy on 2017/7/25.
//  Copyright © 2017年 Shreker. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QLAdmissionHomeDataModel : NSObject
@property (nonatomic, assign) NSInteger sign_id;
@property (nonatomic, assign) NSInteger ROWNUM_;
@property (nonatomic, assign) NSInteger active;
@property (nonatomic, copy) NSString *create_time;
@property (nonatomic, assign) NSInteger user_id;

@end

