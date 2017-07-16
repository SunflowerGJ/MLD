//
//  QLStoreHome.m
//  QLMLD
//
//  Created by 英英 on 2017/7/2.
//  Copyright © 2017年 Shreker. All rights reserved.
//

#import "QLStoreHome.h"
#import "StoreGoodsCollectionCell.h"
#import "MJRefresh.h"
#import "UIScrollView+KS.h"
#import "QLGoodsModel.h"

static NSString *headerViewIdentifier = @"hederview";

@interface QLStoreHome ()<UICollectionViewDelegateFlowLayout,UICollectionViewDelegate,UICollectionViewDataSource,KSRefreshViewDelegate>{
    
    __weak IBOutlet UIButton *_btnOne;
    __weak IBOutlet UIButton *_btnTwo;
    __weak IBOutlet UIButton *_btnThree;
    __weak IBOutlet UIButton *_btnFour;
    __weak IBOutlet UIButton *_btnFive;
    __weak IBOutlet UIButton *_btnSix;
    
    NSInteger _pageSize;
    NSInteger _pageNum;
    NSString *_strTableSelected;
    
    IBOutlet UIView *_viewHeader;
    __weak IBOutlet UILabel *_lblHotGoods;
    __weak IBOutlet UICollectionView *_collectionGoods;
}
@property (nonatomic, strong) NSArray *imageNames;

@end

@implementation QLStoreHome

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self loadDefaultSetting];
}
- (void)loadDefaultSetting {
    self.view.backgroundColor = [UIColor whiteColor];
    self.rightBtn.hidden = NO;
    self.leftBtn.hidden = YES;
    self.rightBtn.frame= CGRectMake(QLScreenWidth-60, 28, 60, 30);
    [self.rightBtn setImage:[UIImage imageNamed:@"cart_icon"] forState:UIControlStateNormal];
    
    _imageNames =[Tools getCache:STOREBANNER_IMAGE];
    
    NSMutableArray *imagesURLStrings = [[NSMutableArray alloc] init];
    for (NSDictionary *cid in _imageNames) {
        [imagesURLStrings addObject:[NSString stringWithFormat:@"%@%@",QLBaseUrlString_Image, [cid objectForKey:@"url"]]];
    }
    self.myHeaderImg.autoScrollTimeInterval = 3.0;
    self.myHeaderImg.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
    self.myHeaderImg.currentPageDotColor = [UIColor whiteColor]; // 自定义分页控件小圆标颜色
    self.myHeaderImg.pageDotColor = QLFontShallowColor; // 自定义分页控件小圆标颜色
    self.myHeaderImg.placeholderImage = [UIImage imageNamed:@"banner1"];
    self.myHeaderImg.imageURLStringsGroup = imagesURLStrings;
    
    
    //查询轮播图
    NSString *strURl = [NSString stringWithFormat:@"%@%@",QLBaseUrlString,storeBanner_interface];
    [QLHttpTool postWithBaseUrl:strURl Parameters:nil whenSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        _imageNames = [responseObject objectForKey:@"pagedata"];
        NSMutableArray *imagesURLStrings = [[NSMutableArray alloc] init];
        for (NSDictionary *cid in _imageNames) {
            [imagesURLStrings addObject:[NSString stringWithFormat:@"%@%@",QLBaseUrlString_Image, [cid objectForKey:@"url"]]];
        }
        self.myHeaderImg.imageURLStringsGroup = imagesURLStrings;
        [Tools setCache:STOREBANNER_IMAGE data:_imageNames];
        
    } whenFailure:^() {
        
    }];
    
    [self loadCollectionView];
}
- (void)loadCollectionView{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.headerReferenceSize = CGSizeMake(QLScreenWidth, 414.0f);  //设置headerView大小
    [_collectionGoods registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headerViewIdentifier];  //  一定要设置
    [_collectionGoods setCollectionViewLayout:layout];
    
    [_collectionGoods registerClass:[StoreGoodsCollectionCell class] forCellWithReuseIdentifier:@"StoreGoodsCollectionCell"];
    
    // 设置具体属性
    // 1.设置 最小行间距
    layout.minimumLineSpacing = 2;
    // 2.设置 最小列间距
    layout. minimumInteritemSpacing  = 2;
    // 3.设置item块的大小 (可以用于自适应)
    CGFloat width = ((QLScreenWidth - 16))/2;
    CGFloat height = width;
    
    layout.estimatedItemSize = CGSizeMake(width, height);
    _collectionGoods.collectionViewLayout = layout;
}
- (void)addCollectionViewRefresh{
    [_collectionGoods addHeaderWithTarget:self action:@selector(collectionViewHeadLoad)];
    _collectionGoods.footerKS = [[KSDefaultFootRefreshView alloc]  initWithDelegate:self];
}
- (void)collectionViewHeadLoad{
    _pageNum = 1;
    NSString *strBaseUrl = [NSString stringWithFormat:@"%@",QLBaseUrlString];
    NSDictionary *dicPara = @{@"currentPage":[NSString stringWithFormat:@"%ld",(long)_pageNum],@"pageMaxResult":[NSString stringWithFormat:@"%ld",(long)_pageSize],@"searchStr":[NSString getValidStringWithObject:_strTableSelected]};//筛选项_strTableSelected
    
    [QLHttpTool postWithBaseUrl:strBaseUrl Parameters:dicPara whenSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSArray *array = [QLGoodsModel mj_keyValuesArrayWithObjectArray:responseObject[@"data"]];
        
        self.dataSource = [[NSMutableArray alloc] initWithArray:array];
        [_collectionGoods reloadData];
        [_collectionGoods headerEndRefreshing];
        
        if([[responseObject objectForKey:@"data"] count]<_pageSize){
            [_collectionGoods.footerKS setIsLastPage:YES];
        }else{
            
            [_collectionGoods.footerKS setIsLastPage:NO];
        }
        
        //处理刷新控件
        [_collectionGoods.footerKS setState:RefreshViewStateDefault];
        if(self.dataSource&&self.dataSource.count>0){
            [self promptHidden];
        }else{
            [self promptNoContent];
        }
    } whenFailure:^() {
        [_collectionGoods headerEndRefreshing];
        [_collectionGoods reloadData];
        if(!(self.dataSource&&self.dataSource.count>0)){
            [self promptNoNetwork];
        }
    }];
}
#pragma mark - collection delegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
//    return self.dataSource.count;
    return 15;
}
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
//呈现数据
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    StoreGoodsCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"StoreGoodsCollectionCell" forIndexPath:indexPath];
    QLGoodsModel *model = self.dataSource[indexPath.row];
    
//    NSString *itemImg = model.itemImg;
//    NSString *strImgUrl = [NSString stringWithFormat:@"%@%@%@",QLBaseUrlString_Image,userImgDomain,itemImg];
//    UIImage *defaultImage = [UIImage imageNamed:@"picdefault"];
//    [cell.goodsImage sd_setImageWithURL:[NSURL URLWithString:strImgUrl] placeholderImage:defaultImage];
//    
//    cell.goodsName.text = model.itemName;
    
    return cell;
    
    
    
}
#pragma mark -collection layout

//UICollectionView被选中时调用的方法
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    QLGoodsModel *model = self.dataSource[indexPath.row];
//    ShoppingAutoPartsCollectionVC *subVC = [[ShoppingAutoPartsCollectionVC alloc]init];
//    NSMutableDictionary *dic = [NSMutableDictionary new];
//    [dic setValue:[NSString getValidStringWithObject:_strCarSeriesId] forKey:@"seriesID"];
//    [dic setValue:[NSString getValidStringWithObject:_strCarSeriesName] forKey:@"seriesName"];
//    [dic setValue:[NSString getValidStringWithObject:_strTableSelected] forKey:@"tableSelected"];
//    [dic setValue:[NSString getValidStringWithObject:model.itemName] forKey:@"autoAll"];
//    
//    subVC.dicPassValue = dic;
//    [[QLHttpTool getCurrentVC].navigationController pushViewController:subVC animated:YES];
}
//  返回头视图
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    
    UICollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headerViewIdentifier forIndexPath:indexPath];
    [headerView addSubview:_viewHeader];
    return headerView;
}



- (void)clickRight {
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
