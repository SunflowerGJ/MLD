//
//  MyCollectionView.m
//  4512
//
//  Created by vicnic on 16/12/19.
//  Copyright © 2016年 mac. All rights reserved.
//

#import "MyCollectionView.h"
#import "CustomLayout.h"
#import "UIImageView+WebCache.h"
#import "FlowCollectionCell.h"
@implementation MyCollectionView
static NSString * const reuseIdentifier = @"FlowCollectionCell";
- (instancetype)initWithFrame:(CGRect)frame pictureNameArray:(NSMutableArray*)array widthScal:(CGFloat)w_scale heightScale:(CGFloat)h_scale
{
    self = [super initWithFrame:frame];
    if (self) {
        _picNameArr = [[NSMutableArray alloc]init];
        _picNameArr = array;
        
        CustomLayout * layout = [[CustomLayout alloc]init];
        layout.itemSize = CGSizeMake(320-40, 400);
        layout.widthScale = w_scale;
        layout.heightScale = h_scale;
        
        _myCollectionView = [[UICollectionView alloc]initWithFrame:frame collectionViewLayout:layout];
        _myCollectionView.dataSource = self;
        _myCollectionView.backgroundColor = [UIColor yellowColor];
        _myCollectionView.showsHorizontalScrollIndicator = NO;
        _myCollectionView.showsVerticalScrollIndicator = NO;
        [_myCollectionView setCollectionViewLayout:layout];

        [_myCollectionView registerClass:[FlowCollectionCell class] forCellWithReuseIdentifier:reuseIdentifier];
        [self addSubview:self.myCollectionView];

        
        
        
       
        
        
        
//        [self addTimerLoop];
    }
    return self;
}
#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _picNameArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    FlowCollectionCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    if ([self verifyURL:_picNameArr[indexPath.row]]) {
        [cell.imageShow sd_setImageWithURL:[NSURL URLWithString:_picNameArr[indexPath.row%_picNameArr.count]]];
    }else{
        cell.imageShow.image = [UIImage imageNamed:[NSString stringWithFormat:@"%ld.jpg",indexPath.row%_picNameArr.count]];
    }
    return cell;
}

-(BOOL) verifyURL:(NSString *)url{//太灵活了只能设置为强制要有http头或者https否则会把0.jpg识别为url
    NSString *pattern = @"^(((http[s]{0,1}|ftp|Http[s]{0,1})://)[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%^&*+?:_/=<>]*)?)|(www.[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%^&*+?:_/=<>]*)?)";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    BOOL isMatch = [pred evaluateWithObject:url];
    return isMatch;
}
#pragma  mark 定时器
- (void) addTimerLoop{
    if (_timer == nil) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(changeOffset) userInfo:nil repeats:YES];
    }
}

- (void)changeOffset{
    //当前正在展示的位置
//    NSIndexPath *currentIndexPath = [[_myCollectionView indexPathsForVisibleItems]lastObject];
    
    CGPoint pInView = [self.myCollectionView.superview convertPoint:self.myCollectionView.center toView:self.myCollectionView];
    NSIndexPath * currentIndexPath = [self.myCollectionView indexPathForItemAtPoint:pInView];
    
    NSIndexPath *resetIndexPath = [NSIndexPath indexPathForItem:currentIndexPath.item inSection:1/2];
    [_myCollectionView scrollToItemAtIndexPath:resetIndexPath atScrollPosition:UICollectionViewScrollPositionLeft animated:NO];
    
    //计算出下一个位置
    NSInteger nextItem = resetIndexPath.item + 1;
    if (nextItem == _picNameArr.count) {
        nextItem = 0;
    }
    
    NSIndexPath *nextIndexPath = [NSIndexPath indexPathForItem:nextItem inSection:0];
    if (nextItem ==0) {
        [_myCollectionView scrollToItemAtIndexPath:nextIndexPath atScrollPosition:UICollectionViewScrollPositionLeft animated:NO];
    }
    //滚动到下一个位置
    [_myCollectionView scrollToItemAtIndexPath:nextIndexPath atScrollPosition:UICollectionViewScrollPositionLeft animated:YES];
}

@end
