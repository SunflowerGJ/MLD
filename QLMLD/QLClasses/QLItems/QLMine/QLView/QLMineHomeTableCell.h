//
//  QLMineHomeTableCell.h
//  QLMLD
//
//  Created by 英英 on 2017/7/5.
//  Copyright © 2017年 Shreker. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QLMineHomeTableCell : UITableViewCell
+ (instancetype)cellWithMineHomeTableView:(UITableView *)tableView;
- (void)setCellDataWithTitle:(NSString *)name;
@end
