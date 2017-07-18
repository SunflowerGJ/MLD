
//
//  ShoppingCartTableCell.m
//  technician
//
//  Created by syy on 2016/12/14.
//  Copyright © 2016年 cn.forp.app. All rights reserved.
//

#import "ShoppingCartTableCell.h"
#define maxNum 90
@interface ShoppingCartTableCell(){
    __weak IBOutlet UIView *_viewBGCountNum;
    __weak IBOutlet UITextField *_textFieldCountNum;
    __weak IBOutlet UIView *_viewBgEdit;
    __weak IBOutlet UILabel *_labelPrice;
    __weak IBOutlet UILabel *_labelTitle;

    __weak IBOutlet UIImageView *_imgLogo;
    __weak IBOutlet UIButton *_btnMark;
    NSInteger countNum;
    ShoppingCartModel *_cartModel;
    NSIndexPath *_indexPath;
}
@end

@implementation ShoppingCartTableCell
+ (instancetype)cellWithShoppingCartTableView:(UITableView *)tableView{
    static NSString *GroupedTableIdentifier = @"ShoppingCartTableCell";
    ShoppingCartTableCell *cell = [tableView dequeueReusableCellWithIdentifier:
                              GroupedTableIdentifier];
    if (cell == nil) {
        UINib *nib = [UINib nibWithNibName:NSStringFromClass([ShoppingCartTableCell class]) bundle:nil];
        [tableView registerNib:nib forCellReuseIdentifier:GroupedTableIdentifier];
        cell = [tableView dequeueReusableCellWithIdentifier:
                GroupedTableIdentifier];
    }
    return cell;
}
- (void)setCellDataWithModel:(ShoppingCartModel *)model indexPath:(NSIndexPath *)path{
    _cartModel = model;
    _indexPath = path;
    [[IQKeyboardManager sharedManager] setEnable:NO];
    [[IQKeyboardManager sharedManager] setEnableAutoToolbar:NO];
    UIToolbar *toolBar =[[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, QLScreenWidth, 40)];
    UIButton *doneButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [doneButton setTitle:@"完成" forState:UIControlStateNormal];
    [doneButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    doneButton.titleLabel.font = [UIFont boldSystemFontOfSize:16];
    [doneButton setFrame:CGRectMake(QLScreenWidth-60, 0, 60, 40)];
    [doneButton addTarget:self action:@selector(doneAction) forControlEvents:UIControlEventTouchUpInside];
    [toolBar addSubview:doneButton];
    [_textFieldCountNum setInputAccessoryView:toolBar];
    
    _textFieldCountNum.text = model.cartCount;
    _labelPrice.text = [NSString stringWithFormat:@"￥%@",model.cartPrice];
    _labelTitle.text = model.cartName;
    
}
- (void)doneAction{
    QLLog(@"点击完成");
    [_textFieldCountNum resignFirstResponder];
    NSInteger input = [_textFieldCountNum.text integerValue];
    if (input>maxNum) {
        [QLHUDTool showAlertMessage:@"超出最大限额"];
        countNum = maxNum;
    }else{
        countNum = input;
    }
//    [_materialModel setValue:[NSString stringWithFormat:@"%zd",countNum] forKey:NSStringFromSelector(@selector(countNum))];
    _textFieldCountNum.text = [NSString stringWithFormat:@"%zd",countNum];
    if (self.blockShoppingEditCountNum) {
        self.blockShoppingEditCountNum(countNum);
    }
    [[IQKeyboardManager sharedManager] setEnable:YES];
    [[IQKeyboardManager sharedManager] setEnableAutoToolbar:YES];
}
- (void)setGoodsCount:(NSInteger)goodsCount{
    countNum = goodsCount;
    _textFieldCountNum.text = [NSString stringWithFormat:@"%zd",countNum];
}
//减
- (IBAction)btnSubtraction:(id)sender {
    if ([_cartModel.cartCount integerValue]<=0) {
        return ;
    }else{
        NSInteger count = [_textFieldCountNum.text integerValue];
        count--;
        [_cartModel setValue:[NSString stringWithFormat:@"%zd",count] forKey:NSStringFromSelector(@selector(cartCount))];
        NSLog(@"value changed==: %@", _cartModel.cartCount);
        _textFieldCountNum.text = [NSString stringWithFormat:@"%zd",count];
        
        if(self.blockShoppingSubtraction){
            self.blockShoppingSubtraction();
        }
    }
}
//加
- (IBAction)btnPlus:(id)sender {
    if ([_cartModel.cartCount integerValue]>maxNum) {
        return ;
    }else{
        NSInteger count = [_textFieldCountNum.text integerValue];
        count++;
        [_cartModel setValue:[NSString stringWithFormat:@"%zd",count] forKey:NSStringFromSelector(@selector(cartCount))];
        _textFieldCountNum.text = [NSString stringWithFormat:@"%zd",count];
        if(self.blockShoppingPlus){
            self.blockShoppingPlus();
        }
    }
}
- (void)textFieldDidEndEditing:(UITextField *)textField{
    NSInteger input = [textField.text integerValue];
    if (input>maxNum) {
        [QLHUDTool showAlertMessage:@"超出最大限额"];
        countNum = maxNum;
    }else{
        countNum = input;
    }
    _textFieldCountNum.text = [NSString stringWithFormat:@"%zd",countNum];
    [[IQKeyboardManager sharedManager] setEnable:YES];
    [[IQKeyboardManager sharedManager] setEnableAutoToolbar:YES];
    
    
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [_viewBgEdit setCornerRadius:QLButtonRadius border:1 borderColor:QLDividerColor];
    [_viewBGCountNum setBorder:1 borderColor:QLDividerColor];
    [_imgLogo setBorder:1 borderColor:QLYellowColor];

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setCellSelected:(BOOL)isSelected{
    _btnMark.selected = isSelected;
}

- (IBAction)btnMark:(id)sender {
    if (self.blockClickMarkButton) {
        self.blockClickMarkButton(_cartModel,_indexPath);
    }
}

@end
