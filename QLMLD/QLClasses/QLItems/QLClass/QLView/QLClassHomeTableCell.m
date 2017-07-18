//
//  QLClassHomeTableCell.m
//  QLMLD
//
//  Created by syy on 2017/7/6.
//  Copyright © 2017年 Shreker. All rights reserved.
//

#import "QLClassHomeTableCell.h"
@interface QLClassHomeTableCell(){
    
    __weak IBOutlet UIImageView *_imageHead;
    
    __weak IBOutlet UILabel *_lblName;
    __weak IBOutlet UILabel *_lblContent;
    __weak IBOutlet UILabel *_lblTime;
    __weak IBOutlet UIView *_viewImageShow;
    __weak IBOutlet UILabel *_lblImageNum;
}
@end

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
- (void)setCellDataWithDataModel:(QLClassHomeDataModel *)model{
    _lblName.text = model.user_name;
    _lblTime.text = model.createTime;
    //创建 NSMutableAttributedString
    NSMutableAttributedString* plus = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"共%@张",model.praise_num]];
    [plus addAttribute:NSFontAttributeName value:[UIColor redColor] range:NSMakeRange(1,plus.length-2)];
    


}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    
    // Configure the view for the selected state
}
//删除
- (IBAction)btnDelete:(id)sender {
}
//评论
- (IBAction)btnComm:(id)sender {
}
//赞
- (IBAction)btnPraise:(id)sender {
}

@end
