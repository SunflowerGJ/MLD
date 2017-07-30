//
//  QLAdmissionDetailCell.h
//  QLMLD
//
//  Created by 英英 on 2017/7/30.
//  Copyright © 2017年 Shreker. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QLAdmissionDetailCell : UITableViewCell
+ (instancetype)cellWithAdmissionDetailTableView:(UITableView *)tableView;
- (void)setCellDataWithTitle:(NSString *)str;
@property (nonatomic,copy) void (^blockEdit)();

@end
