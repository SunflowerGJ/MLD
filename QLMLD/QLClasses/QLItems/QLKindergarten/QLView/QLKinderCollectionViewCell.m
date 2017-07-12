//
//  QLKinderCollectionViewCell.m
//  QLMLD
//
//  Created by 英英 on 2017/7/12.
//  Copyright © 2017年 Shreker. All rights reserved.
//

#import "QLKinderCollectionViewCell.h"

@implementation QLKinderCollectionViewCell
- (void)setCellIndexValue:(NSInteger)value{
    
}
- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self){
        // 初始化时加载collectionCell.xib文件
        NSArray *arrayOfViews = [[NSBundle mainBundle] loadNibNamed:@"QLKinderCollectionViewCell" owner:self options:nil];
        
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
}


- (UICollectionViewLayoutAttributes *) preferredLayoutAttributesFittingAttributes:(UICollectionViewLayoutAttributes *)layoutAttributes
{
    [super preferredLayoutAttributesFittingAttributes:layoutAttributes];
    
    UICollectionViewLayoutAttributes *attributes = [layoutAttributes copy];
    
    //    attributes.size = CGSizeMake(80, 150);
    
    return attributes;
}


@end
