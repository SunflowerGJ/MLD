//
//  QLStoreCLassTableCell.m
//  QLMLD
//
//  Created by 英英 on 2017/7/24.
//  Copyright © 2017年 Shreker. All rights reserved.
//

#import "QLStoreCLassTableCell.h"

@implementation QLStoreCLassTableCell
+ (instancetype)cellWithStoreClassTableView:(UITableView *)tableView{
    static NSString *GroupedTableIdentifier = @"QLStoreCLassTableCell";
    QLStoreCLassTableCell *cell = [tableView dequeueReusableCellWithIdentifier:
                                   GroupedTableIdentifier];
    if (cell == nil) {
        UINib *nib = [UINib nibWithNibName:NSStringFromClass([QLStoreCLassTableCell class]) bundle:nil];
        [tableView registerNib:nib forCellReuseIdentifier:GroupedTableIdentifier];
        cell = [tableView dequeueReusableCellWithIdentifier:
                GroupedTableIdentifier];
    }
    return cell;
}
- (void)setCellDataWithStoreClassModel:(QLStoreClassModel *)model{
    
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
