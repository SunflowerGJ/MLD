//
//  QLAdmissionHomeTableCell.m
//  QLMLD
//
//  Created by 英英 on 2017/7/23.
//  Copyright © 2017年 Shreker. All rights reserved.
//

#import "QLAdmissionHomeTableCell.h"
@interface QLAdmissionHomeTableCell(){
    
    __weak IBOutlet UILabel *_lblShow;
}
@end

@implementation QLAdmissionHomeTableCell
+ (instancetype)cellWithAdmissionHomeTableView:(UITableView *)tableView{
    static NSString *GroupedTableIdentifier = @"QLAdmissionHomeTableCell";
    QLAdmissionHomeTableCell *cell = [tableView dequeueReusableCellWithIdentifier:
                                 GroupedTableIdentifier];
    if (cell == nil) {
        UINib *nib = [UINib nibWithNibName:NSStringFromClass([QLAdmissionHomeTableCell class]) bundle:nil];
        [tableView registerNib:nib forCellReuseIdentifier:GroupedTableIdentifier];
        cell = [tableView dequeueReusableCellWithIdentifier:
                GroupedTableIdentifier];
    }
    return cell;
}
- (void)setCellDataWithTitle:(NSString *)str{
    _lblShow.text = str;
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
