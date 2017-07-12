//
//  QLKindergartenHome.m
//  QLMLD
//
//  Created by 英英 on 2017/7/2.
//  Copyright © 2017年 Shreker. All rights reserved.
//

#import "QLKindergartenHome.h"
#import "QLKinderCollectionViewCell.h"
@interface QLKindergartenHome ()<UICollectionViewDelegateFlowLayout,UICollectionViewDelegate,UICollectionViewDataSource>{

    __weak IBOutlet UICollectionView *_collentionMain;
    
    __weak IBOutlet UIView *_viewMain;
}

@end

@implementation QLKindergartenHome

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadDefaultSetting];
}
- (void)loadDefaultSetting {
    self.leftBtn.hidden = YES;
    
    //每个Item宽高
    CGFloat W = 80;
    CGFloat H = 100;
    //每行列数
    NSInteger rank = 4;
    //每列间距
    CGFloat rankMargin = (self.view.frame.size.width - rank * W) / (rank - 1);
    //每行间距
    CGFloat rowMargin = 20;
    //Item索引 ->根据需求改变索引
    NSUInteger index = 9;
    
    for (int i = 0 ; i< index; i++) {
        //Item X轴
        CGFloat X = (i % rank) * (W + rankMargin);
        //Item Y轴
        NSUInteger Y = (i / rank) * (H +rowMargin);
        //Item top
        CGFloat top = 50;
        UIView *speedView = [[UIView alloc] init];
        speedView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"taozi"]];
        speedView.frame = CGRectMake(X, Y+top, W, H);
        speedView.backgroundColor = [UIColor randomColor];
        [_viewMain addSubview:speedView];
    }
    
    [_collentionMain registerClass:[QLKinderCollectionViewCell class] forCellWithReuseIdentifier:@"QLKinderCollectionViewCell"];
    
    UICollectionViewFlowLayout  *layout = [[UICollectionViewFlowLayout alloc] init];
    // 设置具体属性
    // 1.设置 最小行间距
    layout.minimumLineSpacing = 10;
    // 2.设置 最小列间距
    layout. minimumInteritemSpacing  = 10;
    // 3.设置item块的大小 (可以用于自适应)
    //    layout.estimatedItemSize = CGSizeMake((QLScreenWidth-32)/2, 170);
    layout.itemSize = CGSizeMake((QLScreenWidth-8)/3-10, (QLScreenWidth-8)/3-10);
    
    _collentionMain.collectionViewLayout = layout;
    
    [_collentionMain reloadData];

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - collection delegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 6;
}
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

//呈现数据
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * CellIdentifier = @"QLKinderCollectionViewCell";
    QLKinderCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    
    [cell setCellIndexValue:indexPath.row];
    return cell;
    
    
}
#pragma mark -collection layout

//UICollectionView被选中时调用的方法
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
   
    
}
@end
