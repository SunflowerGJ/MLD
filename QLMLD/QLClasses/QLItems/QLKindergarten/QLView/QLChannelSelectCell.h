//
//  QLChannelSelectCell.h
//  QLMLD
//
//  Created by syy on 2017/8/4.
//  Copyright © 2017年 Shreker. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QLChannelListDataModel.h"
@interface QLChannelSelectCell : UITableViewCell
+ (instancetype)cellWithChannelSelectTableView:(UITableView *)tableView;
- (void)setCellDataWithModel:(QLChannelListDataModel *)model;
@property (nonatomic,copy) void (^blockCellSelected)();

@end
