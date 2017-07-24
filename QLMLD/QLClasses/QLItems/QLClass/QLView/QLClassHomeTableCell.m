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
    NSMutableArray *_muArrayImages;
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
//    if (_muArrayImages.count) {
//        if (![forumModel.strFourmReplayId isEmptyString]) {
//            _lcTopMarginForViewImages.constant = 8;
//            // 工作场地图片
//            NSMutableArray *arrMWorkPlaceImageModels = [NSMutableArray arrayWithCapacity:arrMImagesUrls.count];
//            for (NSString *imageUrl in arrMImagesUrls) {
//                QLImageModel *imageModel = [QLImageModel new];
//                QLIdNameModel *imageInfo = [QLIdNameModel new];
//                imageInfo.strName = imageUrl;
//                imageModel.imageInfo = imageInfo;
//                [arrMWorkPlaceImageModels addObject:imageModel];
//            }
//            NSMutableArray *arrMWorkPlaceImages = [NSMutableArray arrayWithArray:[arrMWorkPlaceImageModels copy]];
//            self.arrImages = (NSArray<QLPostPicsDataSource> *)arrMWorkPlaceImages;
//        }else{
//            _lblFloorTopMarginForViewImages.constant = 0;
//            _lcTopMarginForViewImages.constant = 0;
//        }
//    } else {
//        _lcTopMarginForViewImages.constant = 0;
//    }
    

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
