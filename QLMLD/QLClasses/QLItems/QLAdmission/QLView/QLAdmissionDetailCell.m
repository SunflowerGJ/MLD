//
//  QLAdmissionDetailCell.m
//  QLMLD
//
//  Created by 英英 on 2017/7/30.
//  Copyright © 2017年 Shreker. All rights reserved.
//

#import "QLAdmissionDetailCell.h"
@interface QLAdmissionDetailCell(){
    
    __weak IBOutlet UIImageView *_imgView;
    __weak IBOutlet UILabel *_lblContent;
    __weak IBOutlet UILabel *_lblTime;
}
@end

@implementation QLAdmissionDetailCell
+ (instancetype)cellWithAdmissionDetailTableView:(UITableView *)tableView{
    static NSString *GroupedTableIdentifier = @"QLAdmissionDetailCell";
    QLAdmissionDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:
                                      GroupedTableIdentifier];
    if (cell == nil) {
        UINib *nib = [UINib nibWithNibName:NSStringFromClass([QLAdmissionDetailCell class]) bundle:nil];
        [tableView registerNib:nib forCellReuseIdentifier:GroupedTableIdentifier];
        cell = [tableView dequeueReusableCellWithIdentifier:
                GroupedTableIdentifier];
    }
    return cell;
}
- (void)setCellDataWithTitle:(NSString *)str{
    
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)btnEdit:(id)sender {
    self.blockEdit();
}

@end
