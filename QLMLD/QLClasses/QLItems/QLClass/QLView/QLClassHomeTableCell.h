//
//  QLClassHomeTableCell.h
//  QLMLD
//
//  Created by syy on 2017/7/6.
//  Copyright © 2017年 Shreker. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QLClassHomeDataModel.h"
@interface QLClassHomeTableCell : UITableViewCell
+ (instancetype)cellWithClassHomeTableView:(UITableView *)tableView;
- (void)setCellDataWithDataModel:(QLClassHomeDataModel *)model;
@property (nonatomic,copy) void (^blockDelete)();
@property (nonatomic,copy) void (^blockPraise)();

@end
