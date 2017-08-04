//
//  QLChannelSelectCell.m
//  QLMLD
//
//  Created by syy on 2017/8/4.
//  Copyright © 2017年 Shreker. All rights reserved.
//

#import "QLChannelSelectCell.h"
@interface QLChannelSelectCell(){
    
    __weak IBOutlet UIImageView *_img;
    __weak IBOutlet UILabel *_lblName;
}
@end

@implementation QLChannelSelectCell
+ (instancetype)cellWithChannelSelectTableView:(UITableView *)tableView{
    static NSString *GroupedTableIdentifier = @"QLChannelSelectCell";
    QLChannelSelectCell *cell = [tableView dequeueReusableCellWithIdentifier:
                                  GroupedTableIdentifier];
    if (cell == nil) {
        UINib *nib = [UINib nibWithNibName:NSStringFromClass([QLChannelSelectCell class]) bundle:nil];
        [tableView registerNib:nib forCellReuseIdentifier:GroupedTableIdentifier];
        cell = [tableView dequeueReusableCellWithIdentifier:
                GroupedTableIdentifier];
    }
    return cell;
}
- (void)setCellDataWithModel:(QLChannelListDataModel *)model{
    _lblName.text = model.channel_name;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)tapGesture:(id)sender {
    if (self.blockCellSelected) {
        self.blockCellSelected();
    }
    
}

@end
