//
//  QLStoreCLassTableCell.h
//  QLMLD
//
//  Created by 英英 on 2017/7/24.
//  Copyright © 2017年 Shreker. All rights reserved.
//  商城分类 tableCell

#import <UIKit/UIKit.h>
#import "QLStoreClassModel.h"
@interface QLStoreCLassTableCell : UITableViewCell
+ (instancetype)cellWithStoreClassTableView:(UITableView *)tableView;
- (void)setCellDataWithStoreClassModel:(QLStoreClassModel *)model;
@end
