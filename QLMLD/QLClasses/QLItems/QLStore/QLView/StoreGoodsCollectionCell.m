//
//  StoreGoodsCollectionCell.m
//  technician
//
//  Created by syy on 2016/12/13.
//  Copyright © 2016年 cn.forp.app. All rights reserved.
//

#import "StoreGoodsCollectionCell.h"
@interface StoreGoodsCollectionCell(){
    
//    __weak IBOutlet UILabel *_lblName;
//    __weak IBOutlet UILabel *_lblPrice;
//    __weak IBOutlet UILabel *_lblAssessCount;
//    __weak IBOutlet UILabel *_lblGoodAssessPercent;
//    __weak IBOutlet UIImageView *_imgLogo;
}
@end
@implementation StoreGoodsCollectionCell
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        // 初始化时加载collectionCell.xib文件
        NSArray *arrayOfViews = [[NSBundle mainBundle] loadNibNamed:@"StoreGoodsCollectionCell" owner:self options:nil];
        
        // 如果路径不存在，return nil
        if (arrayOfViews.count < 1)
        {
            return nil;
        }
        // 如果xib中view不属于UICollectionViewCell类，return nil
        if (![[arrayOfViews objectAtIndex:0] isKindOfClass:[UICollectionViewCell class]])
        {
            return nil;
        }
        // 加载nib
        self = [arrayOfViews objectAtIndex:0];
    }
    return self;
}
- (void)awakeFromNib {
    [super awakeFromNib];
//    [_imgLogo setCornerRadius:QLButtonRadius border:1 borderColor:QLBlueColor];
}


- (UICollectionViewLayoutAttributes *) preferredLayoutAttributesFittingAttributes:(UICollectionViewLayoutAttributes *)layoutAttributes
{
    [super preferredLayoutAttributesFittingAttributes:layoutAttributes];
    
    UICollectionViewLayoutAttributes *attributes = [layoutAttributes copy];
    
//    attributes.size = CGSizeMake(80, 150);
    
    return attributes;
}

- (void)setCellDataWithGoodsModel:(QLGoodsModel *)model{
//    _lblPrice.text = [NSString stringWithFormat:@"%.2f",[[NSString stringWithFormat:@"%ld",(long)model.price] floatValue]];
//    _lblName.text = model.goodsName;
}
@end
