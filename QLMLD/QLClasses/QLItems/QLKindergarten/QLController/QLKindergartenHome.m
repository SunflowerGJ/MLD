//
//  QLKindergartenHome.m
//  QLMLD
//
//  Created by 英英 on 2017/7/2.
//  Copyright © 2017年 Shreker. All rights reserved.
//

#import "QLKindergartenHome.h"
#import "QLKinderCollectionViewCell.h"
#import "MJRefresh.h"
#import "UIScrollView+KS.h"
#import "QLChannelListVC.h"
static NSString *kinderHeadIdentity = @"KinderHeader";

@interface QLKindergartenHome ()<UICollectionViewDelegateFlowLayout,UICollectionViewDelegate,UICollectionViewDataSource,KSRefreshViewDelegate>{
    
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
- (void)clickRight {
    [self dataChannelRequest];
}
- (void)loadDefaultSetting {
    self.leftBtn.hidden = YES;
    
    self.rightBtn.hidden = NO;
    self.rightBtn.frame = CGRectMake(QLScreenWidth-40, 28, 30, 30);
    [self.rightBtn setTitle:@"刷新" forState:UIControlStateNormal];
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
    [self addCollectionRefresh];
}

- (void)addCollectionRefresh{
    [_collentionMain addHeaderWithTarget:self action:@selector(collectionViewHeadLoad)];
    _collentionMain.footerKS = [[KSDefaultFootRefreshView alloc]  initWithDelegate:self];
}
- (void)collectionViewHeadLoad{
    [self dataChannelRequest];

}
//上拉加载更多
- (void)refreshViewDidLoading:(id)view
{
//    _pageNum++;
//    NSString *strUrl = [NSString stringWithFormat:@"%@",QLBaseUrlString];
//    NSDictionary *dicParam = @{@"currentPage":[NSString stringWithFormat:@"%ld",(long)_pageNum],@"pageMaxResult":[NSString stringWithFormat:@"%ld",(long)_pageSize]};
//    [QLHttpTool postWithBaseUrl:strUrl Parameters:dicParam whenSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
//        if(self.dataSource){
//            NSMutableArray *array = [NSMutableArray new];
//            for (NSDictionary *dicData in [responseObject objectForKey:@"data"]) {
//                CareProductsModel *careModel = [CareProductsModel mj_objectWithKeyValues:dicData];
//                [array addObject:careModel];
//            }
//            [self.dataSource addObjectsFromArray:array];
//        }else{
//            NSMutableArray *array = [NSMutableArray new];
//            for (NSDictionary *dicData in [responseObject objectForKey:@"data"]) {
//                CareProductsModel *careModel = [CareProductsModel mj_objectWithKeyValues:dicData];
//                [array addObject:careModel];
//            }
//            self.dataSource = [[NSMutableArray alloc] initWithArray:array];
//        }
//        [_collectionBlockShow reloadData];
//        if([[responseObject objectForKey:@"data"] count]<_pageSize){
//            [_collectionBlockShow.footerKS setIsLastPage:YES];
//        }else{
//            [_collectionBlockShow.footerKS setIsLastPage:NO];
//        }
//        //处理刷新控件
//        [_collectionBlockShow.footerKS setState:RefreshViewStateDefault];
//    } whenFailure:^() {
//        [_collectionBlockShow headerEndRefreshing];
//    }];
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
    if (indexPath.row == _muArrayData.count-1) {
        [self addItem];
    }else{
        QLChannelListVC *listVC = [[QLChannelListVC alloc]init];
        [[QLHttpTool getCurrentVC].navigationController pushViewController:listVC animated:YES];
    }
    
}
////  返回头视图
//- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
//    
//    UICollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kinderHeadIdentity forIndexPath:indexPath];
//    [headerView addSubview:_testView];
//    return headerView;
//}
#pragma mark - 
- (void)addItem {
    QLLog(@"add ");
//    _muArrayData addObject:<#(nonnull id)#>
}
- (void)dataChannelRequest{
    NSString *strBaseUrl = [NSString stringWithFormat:@"%@%@",QLBaseUrlString,channelList_interface];
//    NSDictionary *dicParam = @{};
    [QLHttpTool postWithBaseUrl:strBaseUrl Parameters:nil whenSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        QLLog(@"频道： %@",responseObject);
    } whenFailure:^{
        
    }];
}
@end
