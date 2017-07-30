//
//  CustomLayout.m
//  4512
//
//  Created by mac on 16/6/14.
//  Copyright © 2016年 mac. All rights reserved.
//

#import "CustomLayout.h"

@implementation CustomLayout
-(void)prepareLayout
{
    [super prepareLayout];
    if (self.visibleCount < 1) {
        self.visibleCount = 3;//原版为5
    }
    //整个屏幕的高度
    _viewHeight = CGRectGetWidth(self.collectionView.frame);
    _itemHeight = self.itemSize.width;//单元格高度，250
//   设置初始图片位于中间，左右为0是设置为中间,改变x或y方向不需要改这行
    self.collectionView.contentInset = UIEdgeInsetsMake(0, (_viewHeight-_itemHeight) /2, 0, (_viewHeight - _itemHeight) / 2);
}
//该方法返回 true 告知 collectionView 在滑动时布局失效，然后它会调用prepareLayout()，进而使用更新后的位置重新计算 cell 的布局
-(BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds{
    return YES;
}
//让scrollView“刚好停到某个位置”的方法
- (CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset withScrollingVelocity:(CGPoint)velocity {
    CGFloat index = roundf(((self.scrollDirection == UICollectionViewScrollDirectionVertical ? proposedContentOffset.y : proposedContentOffset.x) + _viewHeight / 2 - _itemHeight / 2) / _itemHeight);
    if (self.scrollDirection == UICollectionViewScrollDirectionVertical) {
        proposedContentOffset.y = _itemHeight * index + _itemHeight / 2 - _viewHeight / 2;
    } else {
        proposedContentOffset.x = _itemHeight * index + _itemHeight / 2 - _viewHeight / 2;
    }
    return proposedContentOffset;
}
//计算容量
-(CGSize)collectionViewContentSize
{
    NSInteger cellCount = [self.collectionView numberOfItemsInSection:0];
    //根据有多少cell单元格算出contentSize的大小
    return CGSizeMake(cellCount*_itemHeight,  CGRectGetHeight(self.collectionView.frame));
}

- ( NSArray*)layoutAttributesForElementsInRect:(CGRect)rect
{
    //cellCount = 20;
    NSInteger cellCount = [self.collectionView numberOfItemsInSection:0];
    //计算当前indexpath的cell的坐标
    CGFloat centerX= self.collectionView.contentOffset.x + _viewHeight/2;
    //当cell坐标小于cell高度，为0，高过某值就会1，2，3……递增
    NSInteger index = centerX/ _itemHeight;
    NSInteger count = (self.visibleCount - 1)/2;//=2
    //下方代码块计算屏幕可见cell的数目，并放入数组(index - count)为-1到19（18为最后一个，但是拖动到一定程度会计算出19），(index + count)为1到21，从-1到19取最大，1到21取最小是为了保证当前屏幕新出现的cell是之前消失的cell，表面实现重用机制,实际没有重用，推得array最大不过3
    NSInteger minIndex = MAX(0, (index - count));
    NSInteger maxIndex = MIN((cellCount - 1), (index + count));
    NSMutableArray *array = [NSMutableArray array];
    for (NSInteger i = minIndex; i <= maxIndex; i++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];
        UICollectionViewLayoutAttributes *attributes = [self layoutAttributesForItemAtIndexPath:indexPath];
        [array addObject:attributes];
    }
    return array;
}

-(UICollectionViewLayoutAttributes*)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    attributes.size = self.itemSize;//少了这句屏幕就没有cell
    //cell划出的坐标
    CGFloat cX = self.collectionView.contentOffset.x + _viewHeight / 2;
//每个cell的y或者x值
    CGFloat attributesX = _itemHeight * indexPath.row + _itemHeight / 2;
    //使得当前cell在最上方，在直线等cell不重叠的动画中不需要
    attributes.zIndex = -ABS(attributesX - cX);
    
    CGFloat delta = cX - attributesX;
    CGFloat ratio =  - delta / (_itemHeight *2.0);
    //当前cell为250正常值，其他cell缩小，公式不明,scale是控制非中央cell的缩放率
    CGFloat scale = 1 - ABS(delta) / (_itemHeight * 6.0) * cos(ratio * M_PI_4);
//    效果1 直线
    attributes.transform = CGAffineTransformMakeScale(_widthScale*scale, _heightScale*scale);
    CGFloat centerX = attributesX;
//    效果2
//    attributes.transform = CGAffineTransformRotate(attributes.transform, - ratio * M_PI_4);
//    centerX += sin(ratio * M_PI_2) * _itemHeight / 2;
    
//    效果3，不理想
//    centerX = cX + sin(ratio * M_PI_2) * _itemHeight * 0.65;
    
//    效果4
//    CATransform3D transform = CATransform3DIdentity;
//    transform.m34 = -1.0/400.0f;
//    transform = CATransform3DRotate(transform, ratio * M_PI_4, 1, 0, 0);
//    attributes.transform3D = transform;
    
    attributes.center = CGPointMake(centerX, CGRectGetHeight(self.collectionView.frame) / 2);
    return attributes;
}

@end
