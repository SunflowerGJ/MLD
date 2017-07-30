//
//  QLAddressManageCell.h
//  QLMLD
//
//  Created by 英英 on 2017/7/18.
//  Copyright © 2017年 Shreker. All rights reserved.
//  地址管理 table Cell

#import <UIKit/UIKit.h>

@interface QLAddressManageCell : UITableViewCell
+ (instancetype)cellWithAddressTableView:(UITableView *)tableView;
- (void)setCellDataWithAddressModel:(id)model;
@property (nonatomic,copy) void (^blockDelete)();
@property (nonatomic,copy) void (^blockEdit)();

@end
