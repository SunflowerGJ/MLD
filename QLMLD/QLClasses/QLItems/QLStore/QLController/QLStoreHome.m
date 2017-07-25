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
#import "ShoppingCartVC.h"
#import "QLGoodDetailVC.h"
#import "QLStoreSmallTypeCell.h"
#import "QLStoreClassifyVC.h"
static NSString *headerViewIdentifier = @"hederview";

@interface QLStoreHome ()<UICollectionViewDelegateFlowLayout,UICollectionViewDelegate,UICollectionViewDataSource,KSRefreshViewDelegate,UISearchBarDelegate>{
    
   
    __weak IBOutlet UISearchBar *_searchBar;
    __weak IBOutlet UICollectionView *_collectionSmallType;
    __weak IBOutlet UIView *_viewSmallType;
    NSInteger _pageSize;
    NSInteger _pageNum;
    NSString *_strTableSelected;
    NSMutableArray *_muArraySmallType;
    
    __weak IBOutlet NSLayoutConstraint *_layoutSmallTypeBg;
    IBOutlet UIView *_viewHeader;
    __weak IBOutlet UILabel *_lblHotGoods;
    __weak IBOutlet UICollectionView *_collectionGoods;
    NSString *_strSearch;
}
@property (nonatomic, strong) NSArray *imageNames;

@end

@implementation QLStoreHome

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self loadDefaultSetting];
    [self smallTypeDataRequest];
    [self smallTypeLayout];
    [self loadCollectionView];
}
- (void)smallTypeLayout {
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    [_collectionSmallType setCollectionViewLayout:layout];
    [_collectionSmallType registerClass:[QLStoreSmallTypeCell class] forCellWithReuseIdentifier:@"QLStoreSmallTypeCell"];
    
    // 设置具体属性
    // 1.设置 最小行间距
    layout.minimumLineSpacing = 10;
    // 2.设置 最小列间距
    layout. minimumInteritemSpacing  = 10;
    // 3.设置item块的大小 (可以用于自适应)
    CGFloat width = ((QLScreenWidth - 30-20))/3;
    CGFloat height = width;
    
    layout.estimatedItemSize = CGSizeMake(width, height);
    _collectionSmallType.collectionViewLayout = layout;
    _layoutSmallTypeBg.constant = width*2+10*3;
}

- (void)loadDefaultSetting {
    _pageSize = 10;
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
        _imageNames = [responseObject objectForKey:@"data"];
        NSMutableArray *imagesURLStrings = [[NSMutableArray alloc] init];
        for (NSDictionary *cid in _imageNames) {
            [imagesURLStrings addObject:[NSString stringWithFormat:@"%@%@",QLBaseUrlString_Image, [cid objectForKey:@"carousel_url"]]];
        }
        self.myHeaderImg.imageURLStringsGroup = imagesURLStrings;
        [Tools setCache:STOREBANNER_IMAGE data:_imageNames];
        
    } whenFailure:^() {
        
    }];

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
    [self addCollectionViewRefresh];
     [_collectionGoods headerBeginRefreshing];
}
- (void)addCollectionViewRefresh{
    [_collectionGoods addHeaderWithTarget:self action:@selector(collectionViewHeadLoad)];
    _collectionGoods.footerKS = [[KSDefaultFootRefreshView alloc]  initWithDelegate:self];
}
- (void)collectionViewHeadLoad{
    _pageNum = 1;
    NSString *strBaseUrl = [NSString stringWithFormat:@"%@%@",QLBaseUrlString,hotList_interface];
//    _strSearch =
    NSDictionary *dicParam = @{@"product_name":[NSString getValidStringWithObject:_strSearch], @"start":[NSString stringWithFormat:@"%ld",(long)_pageNum],@"limit":[NSString stringWithFormat:@"%ld",(long)_pageSize]};
    
    [QLHttpTool postWithBaseUrl:strBaseUrl Parameters:dicParam whenSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
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
//上拉加载更多
- (void)refreshViewDidLoading:(id)view
{
    if ([view isEqual:_collectionGoods.footerKS]) {
        _pageNum++;
        NSString *strBaseUrl = [NSString stringWithFormat:@"%@%@",QLBaseUrlString,hotList_interface];
        //    _strSearch =
        NSDictionary *dicParam = @{@"product_name":[NSString getValidStringWithObject:_strSearch], @"start":[NSString stringWithFormat:@"%ld",(long)_pageNum],@"limit":[NSString stringWithFormat:@"%ld",(long)_pageSize]};
        
        [QLHttpTool postWithBaseUrl:strBaseUrl Parameters:dicParam whenSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
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
        }];
    }
}
//小类请求
- (void)smallTypeDataRequest {
    NSString *strBaseUrl = [NSString stringWithFormat:@"%@%@",QLBaseUrlString,storeSmallCalss_interface];
    [QLHttpTool postWithBaseUrl:strBaseUrl Parameters:nil whenSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSArray *array = [QLGoodsModel mj_keyValuesArrayWithObjectArray:responseObject[@"data"]];
        _muArraySmallType = [[NSMutableArray alloc] initWithArray:array];
        
        
    } whenFailure:^() {
    }];
}
#pragma mark - collection delegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
//    return self.dataSource.count;
    if ([collectionView isEqual:_collectionGoods]) {
        return 15;
    }else
    return 5;
}
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
//呈现数据
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    if ([collectionView isEqual:_collectionGoods]) {
        StoreGoodsCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"StoreGoodsCollectionCell" forIndexPath:indexPath];
        //    QLGoodsModel *model = self.dataSource[indexPath.row];
        
        //    NSString *itemImg = model.itemImg;
        //    NSString *strImgUrl = [NSString stringWithFormat:@"%@%@%@",QLBaseUrlString_Image,userImgDomain,itemImg];
        //    UIImage *defaultImage = [UIImage imageNamed:@"picdefault"];
        //    [cell.goodsImage sd_setImageWithURL:[NSURL URLWithString:strImgUrl] placeholderImage:defaultImage];
        //
        //    cell.goodsName.text = model.itemName;
        
        return cell;
    }else{
        QLStoreSmallTypeCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"QLStoreSmallTypeCell" forIndexPath:indexPath];
        //    QLGoodsModel *model = self.dataSource[indexPath.row];
        
        //    NSString *itemImg = model.itemImg;
        //    NSString *strImgUrl = [NSString stringWithFormat:@"%@%@%@",QLBaseUrlString_Image,userImgDomain,itemImg];
        //    UIImage *defaultImage = [UIImage imageNamed:@"picdefault"];
        //    [cell.goodsImage sd_setImageWithURL:[NSURL URLWithString:strImgUrl] placeholderImage:defaultImage];
        //
        //    cell.goodsName.text = model.itemName;
        
        return cell;
    }
}
#pragma mark -collection layout

//UICollectionView被选中时调用的方法
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if ([collectionView isEqual:_collectionGoods]) {
        [collectionView deselectItemAtIndexPath:indexPath animated:YES];
        
        QLGoodDetailVC *detailVC = [[QLGoodDetailVC alloc]init];
        [[QLHttpTool getCurrentVC].navigationController pushViewController:detailVC animated:YES];
        
//        QLGoodsModel *model = self.dataSource[indexPath.row];
//        [self dataDetailRequestWithGoodID:model.strID];
    }else{
        QLStoreClassifyVC *classifyVC = [[QLStoreClassifyVC alloc]init];
//        QLStoreSmallTypeModel *model = _muArraySmallType[indexPath.row];
//        classifyVC.strSmallTypeID = model.strID;
        [[QLHttpTool getCurrentVC].navigationController pushViewController:classifyVC animated:YES];
    }
    
    
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




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - searchBarDelegate
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    QLLog(@"content : %@",searchText);
}
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    _strSearch = searchBar.text;
    [_collectionGoods headerBeginRefreshing];
}

#pragma mark - dataDetailRequest
- (void)dataDetailRequestWithGoodID:(NSString *)goodsID{
    QLGoodDetailVC *detailVC = [[QLGoodDetailVC alloc]init];
    [[QLHttpTool getCurrentVC].navigationController pushViewController:detailVC animated:YES];

    NSString *strBaseUrl = [NSString stringWithFormat:@"%@%@",QLBaseUrlString,goodsDetail_interface];
    NSDictionary *dicParam = @{};
    [QLHttpTool postWithBaseUrl:strBaseUrl Parameters:dicParam whenSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        QLLog(@"detail: %@",responseObject);
    } whenFailure:^{
        
    }];
}
#pragma mark - btn
- (void)clickRight {
    ShoppingCartVC *cartVC = [[ShoppingCartVC alloc]init];
    [[QLHttpTool getCurrentVC].navigationController pushViewController:cartVC animated:YES];
}

- (void)test {
    CGFloat width = (QLScreenWidth-20-20)/3;
    for (NSInteger i=0; i<5; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [_viewSmallType addSubview:button];
        
        if (i<3) {
            button.frame = CGRectMake(i*width, 10, width, width);
            _layoutSmallTypeBg.constant = width+10*2;
        }else{
            button.frame = CGRectMake(i*width, 10+width+10, width, width);
            _layoutSmallTypeBg.constant = width*2+10*3;
        }
        [button setTitle:[NSString stringWithFormat:@"%ld",i] forState:UIControlStateNormal];
        button.backgroundColor = QLColorRandom;
        [button setCornerRadius:width/2];
        
    }

}
@end
