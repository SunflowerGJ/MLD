//
//  QLStoreSmallTypeCell.m
//  QLMLD
//
//  Created by syy on 2017/7/25.
//  Copyright © 2017年 Shreker. All rights reserved.
//

#import "QLStoreSmallTypeCell.h"
@interface QLStoreSmallTypeCell(){
    
    __weak IBOutlet UIView *_viewBG;
    __weak IBOutlet UILabel *_lblName;
}
@end


@implementation QLStoreSmallTypeCell
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        // 初始化时加载collectionCell.xib文件
        NSArray *arrayOfViews = [[NSBundle mainBundle] loadNibNamed:@"QLStoreSmallTypeCell" owner:self options:nil];
        
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
- (UICollectionViewLayoutAttributes *) preferredLayoutAttributesFittingAttributes:(UICollectionViewLayoutAttributes *)layoutAttributes
{
    [super preferredLayoutAttributesFittingAttributes:layoutAttributes];
    
    UICollectionViewLayoutAttributes *attributes = [layoutAttributes copy];
    
    //    attributes.size = CGSizeMake(80, 150);
    
    return attributes;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    CGFloat width = ((QLScreenWidth - 30-20))/3;
    [self setCornerRadius:width/2];
    _viewBG.backgroundColor = QLColorRandom;
}
- (void)setCellDataWithSmallTypeModel:(QLStoreSmallTypeModel *)model{
    
}
@end
