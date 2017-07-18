//
//  QLKindergartenHome.m
//  QLMLD
//
//  Created by 英英 on 2017/7/2.
//  Copyright © 2017年 Shreker. All rights reserved.
//

#import "QLKindergartenHome.h"
#import "QLKinderCollectionViewCell.h"
static NSString *kinderHeadIdentity = @"KinderHeader";

@interface QLKindergartenHome ()<UICollectionViewDelegateFlowLayout,UICollectionViewDelegate,UICollectionViewDataSource>{
    
    __weak IBOutlet UICollectionView *_collentionMain;
    
    __weak IBOutlet UIView *_viewHeader;
    
    NSMutableArray *_muArrayData;
    IBOutlet UIView *_testView;
}

@end

@implementation QLKindergartenHome

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadDefaultSetting];
}
- (void)loadDefaultSetting {
    self.leftBtn.hidden = YES;
//    NSMutableAttributedString* allClass = [[NSMutableAttributedString alloc] initWithString:@"所有班级\n(园长)  \n通讯录(家长、教师)"];
//
    NSArray *allClassNames = @[@"所有班级",@"(园长)",@" ",@"通讯录",@"(家长、教师)"];
    //预设字体大小
    NSArray *fonts = @[[UIFont systemFontOfSize:16],[UIFont systemFontOfSize:14],[UIFont systemFontOfSize:14],[UIFont systemFontOfSize:16],[UIFont systemFontOfSize:14]];
    //创建 NSString
    NSString *stringAllClass = @"";
    for (NSString *name in allClassNames) {
        stringAllClass = [stringAllClass stringByAppendingString:name];
        if ([name isEqualToString:allClassNames.lastObject]) {break;}
        stringAllClass = [stringAllClass stringByAppendingString:@"\n"];
    }
    //创建 NSMutableAttributedString
    NSMutableAttributedString* allClass = [[NSMutableAttributedString alloc] initWithString:stringAllClass];
    NSArray *arr = [stringAllClass componentsSeparatedByString:@"\n"];
    for (NSInteger i = 0; i<arr.count; i++) {
        NSRange range = [stringAllClass rangeOfString:arr[i]];
        [allClass addAttribute:NSFontAttributeName value:fonts[i] range:range];
    }

    NSArray *classPhotos = @[@"班级相册",@"家长班级做标签",@" ",@"长传",@"社区类似",@"教师给班级发",@"给家长做标签"];
    //预设字体大小
    NSArray *fontsPhotos = @[[UIFont systemFontOfSize:16],[UIFont systemFontOfSize:12],[UIFont systemFontOfSize:12],[UIFont systemFontOfSize:12],[UIFont systemFontOfSize:12],[UIFont systemFontOfSize:12],[UIFont systemFontOfSize:12]];
    //创建 NSString
    NSString *stringClassPhotos = @"";
    for (NSString *name in classPhotos) {
        stringClassPhotos = [stringClassPhotos stringByAppendingString:name];
        if ([name isEqualToString:classPhotos.lastObject]) {break;}
        stringClassPhotos = [stringClassPhotos stringByAppendingString:@"\n"];
    }
    //创建 NSMutableAttributedString
    NSMutableAttributedString* classPhotosString = [[NSMutableAttributedString alloc] initWithString:stringClassPhotos];
    NSArray *arrPhotos = [stringClassPhotos componentsSeparatedByString:@"\n"];
    for (NSInteger i = 0; i<arrPhotos.count; i++) {
        NSRange range = [stringClassPhotos rangeOfString:arrPhotos[i]];
        [classPhotosString addAttribute:NSFontAttributeName value:fontsPhotos[i] range:range];
    }

    
    //创建 NSMutableAttributedString
    NSMutableAttributedString* plus = [[NSMutableAttributedString alloc] initWithString:@"+"];
   
    [plus addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:60] range:NSMakeRange(0,plus.length)];



    
    _muArrayData = [NSMutableArray arrayWithArray:@[[[NSMutableAttributedString alloc] initWithString:@"公告"],[[NSMutableAttributedString alloc] initWithString:@"食谱"],[[NSMutableAttributedString alloc] initWithString:@"作业"],[[NSMutableAttributedString alloc] initWithString:@"新闻"],[[NSMutableAttributedString alloc] initWithAttributedString:allClass],[[NSMutableAttributedString alloc] initWithString:@"考勤"],[[NSMutableAttributedString alloc] initWithString:@"服务频道2"],[[NSMutableAttributedString alloc] initWithAttributedString:classPhotosString],[[NSMutableAttributedString alloc] initWithAttributedString:plus]]];
    
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
//    layout.headerReferenceSize = CGSizeMake(QLScreenWidth, 140.0f);  //设置headerView大小
    [_collentionMain registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kinderHeadIdentity];  //  一定要设置
    [_collentionMain setCollectionViewLayout:layout];
    
    [_collentionMain registerClass:[QLKinderCollectionViewCell class] forCellWithReuseIdentifier:@"QLKinderCollectionViewCell"];
    
    // 设置具体属性
    // 1.设置 最小行间距
    layout.minimumLineSpacing = 2;
    // 2.设置 最小列间距
    layout. minimumInteritemSpacing  = 2;
    // 3.设置item块的大小 (可以用于自适应)
    CGFloat width = ((QLScreenWidth - 32))/3;
    CGFloat height = width;
    
    layout.estimatedItemSize = CGSizeMake(width, height);
    _collentionMain.collectionViewLayout = layout;
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - collection delegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _muArrayData.count;
}
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

//呈现数据
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * CellIdentifier = @"QLKinderCollectionViewCell";
    QLKinderCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    
    [cell setCellIndexValue:indexPath.row withData:_muArrayData[indexPath.row]];
    return cell;
    
    
}
#pragma mark -collection layout

//UICollectionView被选中时调用的方法
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    
    
}
////  返回头视图
//- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
//    
//    UICollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kinderHeadIdentity forIndexPath:indexPath];
//    [headerView addSubview:_testView];
//    return headerView;
//}

@end
