//
//  QLClassHomeTableCell.m
//  QLMLD
//
//  Created by syy on 2017/7/6.
//  Copyright © 2017年 Shreker. All rights reserved.
//

#import "QLClassHomeTableCell.h"

@implementation QLClassHomeTableCell
+ (instancetype)cellWithClassHomeTableView:(UITableView *)tableView{
    static NSString *GroupedTableIdentifier = @"QLClassHomeTableCell";
    QLClassHomeTableCell *cell = [tableView dequeueReusableCellWithIdentifier:
                                 GroupedTableIdentifier];
    if (cell == nil) {
        UINib *nib = [UINib nibWithNibName:NSStringFromClass([QLClassHomeTableCell class]) bundle:nil];
        [tableView registerNib:nib forCellReuseIdentifier:GroupedTableIdentifier];
        cell = [tableView dequeueReusableCellWithIdentifier:
                GroupedTableIdentifier];
    }
    return cell;
}
- (void)setCellDataWithDataModel:(QLClassHomeDataModel *)name{
    
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
