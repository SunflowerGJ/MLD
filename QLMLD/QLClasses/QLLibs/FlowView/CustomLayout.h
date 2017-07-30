//
//  CustomLayout.h
//  4512
//
//  Created by mac on 16/6/14.
//  Copyright © 2016年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomLayout : UICollectionViewLayout
{
    CGFloat _viewHeight;
    CGFloat _itemHeight;
}
@property(nonatomic,assign)CGFloat widthScale;
@property(nonatomic,assign)CGFloat heightScale;

@property (nonatomic) CGSize itemSize;
@property (nonatomic) NSInteger visibleCount;
@property (nonatomic) UICollectionViewScrollDirection scrollDirection;
@end
