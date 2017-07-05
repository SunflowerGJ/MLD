//
//  QLMineHomeTableCell.m
//  QLMLD
//
//  Created by 英英 on 2017/7/5.
//  Copyright © 2017年 Shreker. All rights reserved.
//

#import "QLMineHomeTableCell.h"
@interface QLMineHomeTableCell(){

    __weak IBOutlet UILabel *_lblTitle;
}
@end

@implementation QLMineHomeTableCell
+ (instancetype)cellWithMineHomeTableView:(UITableView *)tableView{
    static NSString *GroupedTableIdentifier = @"QLMineHomeTableCell";
    QLMineHomeTableCell *cell = [tableView dequeueReusableCellWithIdentifier:
                                     GroupedTableIdentifier];
    if (cell == nil) {
        UINib *nib = [UINib nibWithNibName:NSStringFromClass([QLMineHomeTableCell class]) bundle:nil];
        [tableView registerNib:nib forCellReuseIdentifier:GroupedTableIdentifier];
        cell = [tableView dequeueReusableCellWithIdentifier:
                GroupedTableIdentifier];
    }
    return cell;
}
- (void)setCellDataWithTitle:(NSString *)name{
    _lblTitle.text = name;
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
