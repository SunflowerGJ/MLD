//
//  QLClassHomeTableCell.m
//  QLMLD
//
//  Created by syy on 2017/7/6.
//  Copyright © 2017年 Shreker. All rights reserved.
//

#import "QLClassHomeTableCell.h"
#import "PictureShowView.h"
@interface QLClassHomeTableCell(){
    
    __weak IBOutlet UIImageView *_imageHead;
    
    __weak IBOutlet UILabel *_lblName;
    __weak IBOutlet UILabel *_lblContent;
    __weak IBOutlet UILabel *_lblTime;
    __weak IBOutlet UIView *_viewImageShow;
    __weak IBOutlet UILabel *_lblImageNum;
    NSMutableArray *_muArrayImages;
    __weak IBOutlet NSLayoutConstraint *_layoutHeight;
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
    _lblName.text = model.userName;
    _lblTime.text = model.createTime;
    _lblContent.text = model.gradeGroupContent;
    //创建 NSMutableAttributedString
    NSMutableAttributedString* plus = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"共%@张",model.praiseNum]];
    [plus addAttribute:NSFontAttributeName value:[UIColor redColor] range:NSMakeRange(1,plus.length-2)];
    
    _muArrayImages = [NSMutableArray new];
    if (model.photo1.length>0) {
        [_muArrayImages addObject:model.photo1];
    }
    if(model.photo2.length>0){
        [_muArrayImages addObject:model.photo2];
    }
    if (model.photo3.length>0) {
        [_muArrayImages addObject:model.photo3];
    }
    if(model.photo4.length>0){
        [_muArrayImages addObject:model.photo4];
    }
    if (model.photo5.length>0) {
        [_muArrayImages addObject:model.photo5];
    }
    if(model.photo6.length>0){
        [_muArrayImages addObject:model.photo6];
    }
    if(model.photo7.length>0){
        [_muArrayImages addObject:model.photo6];
    }
    if(model.photo8.length>0){
        [_muArrayImages addObject:model.photo6];
    }
    if(model.photo9.length>0){
        [_muArrayImages addObject:model.photo6];
    }
    if (_muArrayImages.count>0) {
         [self uploadImages:_muArrayImages];
    }else{
        _layoutHeight.constant = 0;
    }
}

- (void)uploadImages:(NSMutableArray *)images{
    
    NSInteger count = images.count;
    
    CGFloat fMargin = 10;
    CGFloat fWidthBtn = 35;
    CGFloat fHeightBtn = fWidthBtn;
    for (NSInteger i=0; i<count; i++) {
        CGFloat fXPointStart = i%4*(fWidthBtn+fMargin);
        CGFloat fYPointStart = 10+i/4*(fHeightBtn+fMargin);
        UIButton *btnImage = [UIButton buttonWithType:UIButtonTypeCustom];
        [btnImage setFrame:CGRectMake(fXPointStart, fYPointStart, fWidthBtn, fHeightBtn)];
        [btnImage addTarget:self action:@selector(btnScanImagesAction:) forControlEvents:UIControlEventTouchUpInside];
      
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",QLBaseUrlString_Image,images[i]]];
        [btnImage sd_setImageWithURL:url forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"icon_selectPicture_normal"]];

        btnImage.tag = 100+i;
        [_viewImageShow addSubview:btnImage];
    }
    CGFloat fYPointStart = 10+count/4*(fHeightBtn+fMargin);
    _layoutHeight.constant = fYPointStart;
}
- (void)btnScanImagesAction:(id)sender{
    UIButton *button = (UIButton *)sender;
    PictureShowView *view = [PictureShowView showImageView];
    [view setLookOfImage:button.imageView.image];
    
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

//赞
- (IBAction)btnPraise:(id)sender {
}

@end
