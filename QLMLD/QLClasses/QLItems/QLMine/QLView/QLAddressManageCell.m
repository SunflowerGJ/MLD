//
//  QLAddressManageCell.m
//  QLMLD
//
//  Created by 英英 on 2017/7/18.
//  Copyright © 2017年 Shreker. All rights reserved.
//

#import "QLAddressManageCell.h"
@interface QLAddressManageCell(){
    
    __weak IBOutlet UILabel *_lblUserName;
    
    __weak IBOutlet UILabel *_lblTele;
    __weak IBOutlet UILabel *_lblAddressDetail;
}
@end

@implementation QLAddressManageCell
+ (instancetype)cellWithAddressTableView:(UITableView *)tableView{
    static NSString *GroupedTableIdentifier = @"QLAddressManageCell";
    QLAddressManageCell *cell = [tableView dequeueReusableCellWithIdentifier:
                                 GroupedTableIdentifier];
    if (cell == nil) {
        UINib *nib = [UINib nibWithNibName:NSStringFromClass([QLAddressManageCell class]) bundle:nil];
        [tableView registerNib:nib forCellReuseIdentifier:GroupedTableIdentifier];
        cell = [tableView dequeueReusableCellWithIdentifier:
                GroupedTableIdentifier];
    }
    return cell;
}
- (void)setCellDataWithAddressModel:(id)model{
    
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)btnDefaultAddress:(id)sender {
}
- (IBAction)btnDelete:(id)sender {
    self.blockDelete();
}
- (IBAction)btnEdit:(id)sender {
    self.blockEdit();
}

@end
