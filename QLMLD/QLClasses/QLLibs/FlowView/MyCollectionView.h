//
//  MyCollectionView.h
//  4512
//
//  Created by vicnic on 16/12/19.
//  Copyright © 2016年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyCollectionView : UIView<UICollectionViewDataSource>
{
    NSMutableArray * _picNameArr;
}
- (instancetype)initWithFrame:(CGRect)frame pictureNameArray:(NSMutableArray*)array widthScal:(CGFloat)w_scale heightScale:(CGFloat)h_scale;
@property(nonatomic,retain)UICollectionView * myCollectionView;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, assign) CGFloat scrollInterval;
@end
