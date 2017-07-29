//
//  QLOrderTableCell.m
//  QLMLD
//
//  Created by 英英 on 2017/7/23.
//  Copyright © 2017年 Shreker. All rights reserved.
//

#import "QLOrderTableCell.h"
@interface QLOrderTableCell(){
    
    __weak IBOutlet UIImageView *_imgLogo;
    __weak IBOutlet UILabel *_lblTitle;
    
    __weak IBOutlet UILabel *_lblPrice;
    
    __weak IBOutlet UILabel *_lblNum;
    
}
@end

@implementation QLOrderTableCell
+ (instancetype)cellWithOrderListTableView:(UITableView *)tableView{
    static NSString *GroupedTableIdentifier = @"QLOrderTableCell";
    QLOrderTableCell *cell = [tableView dequeueReusableCellWithIdentifier:
                                 GroupedTableIdentifier];
    if (cell == nil) {
        UINib *nib = [UINib nibWithNibName:NSStringFromClass([QLOrderTableCell class]) bundle:nil];
        [tableView registerNib:nib forCellReuseIdentifier:GroupedTableIdentifier];
        cell = [tableView dequeueReusableCellWithIdentifier:
                GroupedTableIdentifier];
    }
    return cell;
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
