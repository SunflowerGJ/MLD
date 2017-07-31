//
//  ShoppingCartVC.m
//  technician
//
//  Created by syy on 2016/12/13.
//  Copyright © 2016年 cn.forp.app. All rights reserved.
//

#import "ShoppingCartVC.h"
#import "StoreCartTableCell.h"
#import "MJRefresh.h"
#import "UIScrollView+KS.h"
#import "ShoppingCartModel.h"
@interface ShoppingCartVC ()<UITableViewDelegate,UITableViewDataSource,KSRefreshViewDelegate>{
    
    __weak IBOutlet UITableView *_tableMain;
    __weak IBOutlet UIView *_viewFooterNormal;
    __weak IBOutlet UIView *_viewFooterEdit;
    
    __weak IBOutlet UIImageView *_imgEditAll;
    __weak IBOutlet UIImageView *_imgNormalAll;
    __weak IBOutlet UIButton *_btnSettlement;//结算
    __weak IBOutlet UILabel *_lblPriceAll;
    BOOL _selectedNormalAllStatus;
    BOOL _selectedEditAllStatus;
    
    NSMutableDictionary *_dicSelectedNormal;
    NSMutableDictionary *_dicSelectedEdit;
    
    NSInteger _pageSize;
    NSInteger _pageNum;
    NSMutableDictionary *_dicSelected;
}

@end

@implementation ShoppingCartVC
- (void)testData{
    self.dataSource = [[NSMutableArray alloc] initWithArray:@[[[ShoppingCartModel alloc] initShoppingCartDataWithDictionary:@{@"strID":@"11",@"cartName":@"中国汽车医院，中国最权威的货运维修平台中国汽车医院，中国最权威的货运维修平台!",@"cartPrice":@"236",@"cartCount":@"1"}],[[ShoppingCartModel alloc] initShoppingCartDataWithDictionary:@{@"strID":@"12",@"cartName":@"发动机颤抖自有",@"cartPrice":@"33",@"cartCount":@"2"}],[[ShoppingCartModel alloc] initShoppingCartDataWithDictionary:@{@"strID":@"13",@"cartName":@"既有指示灯亮自有",@"cartPrice":@"145",@"cartCount":@"1"}],[[ShoppingCartModel alloc] initShoppingCartDataWithDictionary:@{@"strID":@"14",@"cartName":@"中国汽车医院，中国最权威的货运维修平台中国汽车医院!",@"cartPrice":@"456",@"cartCount":@"1"}]]];
    [_tableMain reloadData];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self testData];
    [self loadDefaultSetting];
}
- (void)loadDefaultSetting{
    self.title = @"购物车";
    self.rightBtn.hidden = NO;
    _btnSettlement.backgroundColor = QLFontShallowColor;
    _lblPriceAll.text = @"￥0.00";
    _tableMain.estimatedRowHeight = 80;
    _selectedNormalAllStatus = NO;
    _selectedEditAllStatus = NO;
    _tableMain.separatorColor = QLDividerColor;
    if (!_dicSelectedNormal) {
        _dicSelectedNormal = [NSMutableDictionary new];
    }
    if (!_dicSelectedEdit) {
        _dicSelectedEdit = [NSMutableDictionary new];
    }
    
    [self addTableViewRefresh];
}
-(void)tableViewHeaderRefreshBegin{
    [_tableMain headerBeginRefreshing];
}
- (void)addTableViewRefresh{
    [_tableMain addHeaderWithTarget:self action:@selector(tableHeadLoad)];
    _tableMain.footerKS = [[KSDefaultFootRefreshView alloc]  initWithDelegate:self];
}
/** 下拉刷新 */
- (void)tableHeadLoad{
    _tableMain.estimatedRowHeight = 100;
    [_tableMain reloadData];
    NSString *strUrl = [NSString stringWithFormat:@"%@",QLBaseUrlString];
    NSDictionary *dicPara = @{@"currentPage":[NSString stringWithFormat:@"%ld",(long)_pageNum],@"pageMaxResult":[NSString stringWithFormat:@"%ld",(long)_pageSize]};
    [QLHttpTool postWithBaseUrl:strUrl Parameters:dicPara whenSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSMutableArray *array = [NSMutableArray new];
        for (NSDictionary *dicData in  [responseObject objectForKey:@"li_order"]) {
            ShoppingCartModel *cartModel = [[ShoppingCartModel alloc] initShoppingCartDataWithDictionary:dicData];
            [array addObject:cartModel];
        }
        self.dataSource = [[NSMutableArray alloc] initWithArray:array];
        [_tableMain reloadData];
        [_tableMain headerEndRefreshing];
        
        if([[responseObject objectForKey:@"li_order"] count]<_pageSize){
            [_tableMain.footerKS setIsLastPage:YES];
        }else{
            [_tableMain.footerKS setIsLastPage:NO];
        }
        
        //处理刷新控件
        [_tableMain.footerKS setState:RefreshViewStateDefault];
        if(self.dataSource&&self.dataSource.count>0){
            [self promptHidden];
        }else{
            [self promptNoContent];
        }
    } whenFailure:^() {
        [_tableMain headerEndRefreshing];
        [_tableMain reloadData];
        if(!(self.dataSource&&self.dataSource.count>0)){
            [self promptNoNetwork];
        }
    }];
}
//上拉加载更多
- (void)refreshViewDidLoading:(id)view
{
    if ([view isEqual:_tableMain.footerKS]) {
        _pageNum++;
        NSString *strBaseUrl = [NSString stringWithFormat:@"%@",QLBaseUrlString];
        NSDictionary *dicPara = @{@"currentPage":[NSString stringWithFormat:@"%ld",(long)_pageNum],@"pageMaxResult":[NSString stringWithFormat:@"%ld",(long)_pageSize]};
        [QLHttpTool postWithBaseUrl:strBaseUrl Parameters:dicPara whenSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
            if(self.dataSource){
                NSMutableArray *array = [NSMutableArray new];
                for (NSDictionary *dicData in [responseObject objectForKey:@"li_order"]) {
                    ShoppingCartModel *cartModel = [[ShoppingCartModel alloc] initShoppingCartDataWithDictionary:dicData];
                    [array addObject:cartModel];
                }
                [self.dataSource addObjectsFromArray:array];
            }else{
                NSMutableArray *array = [NSMutableArray new];
                for (NSDictionary *dicData in [responseObject objectForKey:@"li_order"]) {
                    ShoppingCartModel *cartModel = [[ShoppingCartModel alloc] initShoppingCartDataWithDictionary:dicData];
                    [array addObject:cartModel];
                }
                self.dataSource = [[NSMutableArray alloc] initWithArray:array];
            }
            [_tableMain reloadData];
            if([[responseObject objectForKey:@"li_order"] count]<_pageSize){
                [_tableMain.footerKS setIsLastPage:YES];
            }else{
                [_tableMain.footerKS setIsLastPage:NO];
            }
            //处理刷新控件
            [_tableMain.footerKS setState:RefreshViewStateDefault];
        } whenFailure:^() {
            [_tableMain headerEndRefreshing];
        }];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - table'delegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
    //    return 5;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    StoreCartTableCell *cell = [StoreCartTableCell cellWithShoppingCartTableView:tableView];
    ShoppingCartModel *model = self.dataSource[indexPath.row];
    [cell setCellDataWithModel:model indexPath:indexPath];
    
    if (_dicSelectedNormal[model.strID]){
        [cell setCellSelected:YES];
    }else{
        [cell setCellSelected:NO];
    }
    __weak typeof(self) weakSelf = self;
    [cell setBlockClickMarkButton:^(ShoppingCartModel *model,NSIndexPath *path) {
        [weakSelf cellButtonSelected:model indexPath:path];
    }];
    
    [cell setBlockShoppingSubtraction:^{
         [self calculatePrice];
        [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
    }];
    [cell setBlockShoppingPlus:^{
        [self calculatePrice];
        [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
        
    }];
    [cell setBlockShoppingEditCountNum:^(NSInteger num) {
         [self calculatePrice];
    }];
    
    [cell setBlockDelete:^{
        [weakSelf deleteData:model];
    }];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
//cell 选中
- (void)cellButtonSelected:(ShoppingCartModel *)model indexPath:(NSIndexPath *)path{
    
    StoreCartTableCell *cell = [_tableMain cellForRowAtIndexPath:path];
    
    if(_dicSelectedNormal[model.strID]){
        //取消选中状态
        [_dicSelectedNormal removeObjectForKey:model.strID];
        [cell setCellSelected:NO];
        [self normalCancelSelectedAll];
        
    }else{
        //选中
        [_dicSelectedNormal setObject:model forKey:model.strID];
        [cell setCellSelected:YES];
    }
    #pragma mark - 一旦取消一个则全选UnSelected
    [self calculatePrice];
}
- (void)refreshStatus{
    if (_dicSelected.allValues.count==0) {
        [_btnSettlement setBackgroundColor:QLDividerColor];
    }else{
        [_btnSettlement setBackgroundColor:QLYellowColor];
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    ShoppingCartModel *model = self.dataSource[indexPath.row];
    
    
}
//购物车详情请求
- (void)requestForCartMaterialDetialInfoWithID:(NSString *)strID{
    NSString *strBaseUrl = [NSString stringWithFormat:@"%@",QLBaseUrlString];
    NSDictionary *dicParam = @{};
    [QLHUDTool showLoading];
    [QLHttpTool postWithBaseUrl:strBaseUrl Parameters:dicParam whenSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        [QLHUDTool dissmis];
    } whenFailure:^{
        
    }];
}
#pragma mark - button target
//不可编辑状态下 取消全选
- (void)normalCancelSelectedAll{
    _selectedNormalAllStatus = NO;
    _imgNormalAll.image = [UIImage imageNamed:@"check"];
}
- (void)editCancelSelectedAll{
    _selectedEditAllStatus = NO;
    _imgEditAll.image = [UIImage imageNamed:@"check"];
}
- (IBAction)btnNormalSelectAll:(id)sender {
    if (!_selectedNormalAllStatus) {
        _imgNormalAll.image = [UIImage imageNamed:@"checked"];
        for (ShoppingCartModel *model in self.dataSource) {
            [_dicSelectedNormal setObject:model forKey:model.strID];
        }
        _selectedNormalAllStatus = YES;
    }else{
        _imgNormalAll.image = [UIImage imageNamed:@"check"];
        [_dicSelectedNormal removeAllObjects];
        _selectedNormalAllStatus = NO;
        
    }
    [self calculatePrice];
    [_tableMain reloadData];
}
//编辑状态下全选
- (IBAction)btnEditSelectAll:(id)sender {
    if (!_selectedEditAllStatus) {
        _imgEditAll.image = [UIImage imageNamed:@"checked"];
        for (ShoppingCartModel *model in self.dataSource) {
            [_dicSelectedEdit setObject:model forKey:model.strID];
        }
        _selectedEditAllStatus = YES;
    }else{
        _imgEditAll.image = [UIImage imageNamed:@"check"];
        [_dicSelectedEdit removeAllObjects];
        _selectedEditAllStatus = NO;
    }
    QLLog(@"选中：%zd",_selectedEditAllStatus);
    [_tableMain reloadData];
}
//删除
- (IBAction)btnDelete:(id)sender {
    
    QLLog(@"删除：%@",_dicSelectedEdit);
}
//结算
- (IBAction)btnSettlement:(id)sender {
    
    QLLog(@"结算的数据：%@, 总金额：%@",_dicSelectedNormal,_lblPriceAll.text);
    //只取金额： _lblPriceAll.text
    
}
#pragma mark - 计算总金额
- (void)calculatePrice{
    if ([_dicSelectedNormal allValues].count>0) {
        _btnSettlement.backgroundColor = QLYellowColor;
    }else{
        _btnSettlement.backgroundColor = QLFontShallowColor;
    }

    CGFloat priceAll = 0;
    //选中
    for (ShoppingCartModel *model in _dicSelectedNormal.allValues) {
        priceAll = priceAll + [model.cartPrice floatValue]*[model.cartCount integerValue];
    }
    _lblPriceAll.text = [NSString stringWithFormat:@"%.2f",priceAll];
}
#pragma mark - 删除
- (void)deleteData:(ShoppingCartModel *)model{
    [self.dataSource removeObject:model];
    [_tableMain reloadData];
}
- (void)dealloc {
    // RELEASE OBJECTS TO FREE THE MEMORIES HERE!
    __unsafe_unretained typeof(self) selfUnsafe = self;
    QLLog(@"🌜A instance of type %@ was DESTROYED!🌛", NSStringFromClass([selfUnsafe class]));
}
@end
