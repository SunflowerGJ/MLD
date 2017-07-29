//
//  QLOrderListVC.m
//  QLMLD
//
//  Created by 英英 on 2017/7/23.
//  Copyright © 2017年 Shreker. All rights reserved.
//

#import "QLOrderListVC.h"
#import "QLOrderTableCell.h"
#import "QLOrderListModel.h"
#import "MJRefresh.h"
#import "UIScrollView+KS.h"
#import "QLOrderDetailVC.h"
@interface QLOrderListVC ()<UITableViewDelegate,UITableViewDataSource,KSRefreshViewDelegate>{

    __weak IBOutlet UIImageView *_imgLine;
    __weak IBOutlet UIView *_viewWaitSend;
    __weak IBOutlet UIView *_viewWaitReceive;
    __weak IBOutlet UITableView *_tableMain;
    
    
    NSInteger _pageSize;
    NSInteger _pageNum;
}

@end

@implementation QLOrderListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadDefaultSetting];
}
- (void)loadDefaultSetting {
    self.title = @"订单管理";
    _pageSize = 10;
    _tableMain.estimatedRowHeight = 100;
    [_tableMain addSubview: self.promptView];
    _tableMain.separatorColor = QLDividerColor;
    [self addTableViewRefresh];
    [_tableMain headerBeginRefreshing];
}
#pragma table
- (void)addTableViewRefresh{
    [_tableMain addHeaderWithTarget:self action:@selector(tableHeadLoad)];
    _tableMain.footerKS = [[KSDefaultFootRefreshView alloc]  initWithDelegate:self];
}
/** 下拉刷新 */
- (void)tableHeadLoad{
    _pageNum = 1;
    NSString *strBaseUrl = [NSString stringWithFormat:@"%@%@",QLBaseUrlString,class_interface];
    NSDictionary *dicParam = @{@"pageNumber":[NSString stringWithFormat:@"%ld",(long)_pageNum],@"pageSize":[NSString stringWithFormat:@"%ld",(long)_pageSize]};
    [QLHttpTool postWithBaseUrl:strBaseUrl Parameters:dicParam whenSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        QLLog(@"订单信息：%@",responseObject);
        NSMutableArray *array = [NSMutableArray new];
        array = [QLOrderListModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
        self.dataSource = [[NSMutableArray alloc] initWithArray:array];
        [_tableMain reloadData];
        [_tableMain headerEndRefreshing];
        
        if(self.dataSource&&self.dataSource.count>0){
            self.promptView.hidden = YES;
        }else{
            self.promptView.hidden = NO;
            self.promptL.text =@"这里暂时还没有内容~";
        }
        if([responseObject[@"total"] integerValue]<=_pageNum*_pageSize){
            [_tableMain.footerKS setIsLastPage:YES];
        }else{
            [_tableMain.footerKS setIsLastPage:NO];
        }
        //处理刷新控件
        [_tableMain.footerKS setState:RefreshViewStateDefault];
        
    } whenFailure:^() {
        [_tableMain headerEndRefreshing];
        [_tableMain reloadData];
        if(!(self.dataSource&&self.dataSource.count>0)){
            [self promptNoNetwork];
        }
    }];
}
//上拉加载更多
- (void)refreshViewDidLoading:(id)view {
    if ([view isEqual:_tableMain.footerKS]) {
        _pageNum++;
        NSString *strBaseUrl = [NSString stringWithFormat:@"%@%@",QLBaseUrlString,class_interface];
        NSDictionary *dicParam = @{@"pageNumber":[NSString stringWithFormat:@"%ld",(long)_pageNum],@"pageSize":[NSString stringWithFormat:@"%ld",(long)_pageSize]};
        
        [QLHttpTool postWithBaseUrl:strBaseUrl Parameters:dicParam whenSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
            if(self.dataSource){
                NSMutableArray *array = [QLOrderListModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
                [self.dataSource addObjectsFromArray:array];
            }else{
                NSMutableArray *array = [QLOrderListModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
                self.dataSource = [[NSMutableArray alloc] initWithArray:array];
            }
            [_tableMain reloadData];
            if([responseObject[@"total"] integerValue]<=_pageNum*_pageSize){
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
- (void)setOrderType:(OrderListType)orderType {
    if (_orderType == OrderListTypeAll) {
        [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionAllowUserInteraction animations:^{
            _imgLine.frame = CGRectMake(0, _imgLine.frame.origin.y, _imgLine.frame.size.width, _imgLine.frame.size.height);
        } completion:^(BOOL finished) {
            
        }];
    }else if (_orderType == OrderListTypeWaitReceive){
        [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionAllowUserInteraction animations:^{
            _imgLine.frame = CGRectMake(_viewWaitSend.frame.origin.x, _imgLine.frame.origin.y, _imgLine.frame.size.width, _imgLine.frame.size.height);
        } completion:^(BOOL finished) {
            
        }];
    }else{
        [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionAllowUserInteraction animations:^{
            _imgLine.frame = CGRectMake(_viewWaitReceive.frame.origin.x, _imgLine.frame.origin.y, _imgLine.frame.size.width, _imgLine.frame.size.height);
        } completion:^(BOOL finished) {
            
        }];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - btn
- (IBAction)btnMenu:(id)sender {
    UIButton *button = (UIButton *)sender;
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionAllowUserInteraction animations:^{
        _imgLine.frame = CGRectMake(button.superview.frame.origin.x, _imgLine.frame.origin.y, _imgLine.frame.size.width, _imgLine.frame.size.height);
    } completion:^(BOOL finished) {
        
    }];
    
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    QLOrderTableCell *cell = [QLOrderTableCell cellWithOrderListTableView:tableView];
//    QLOrderListModel *model = self.dataSource[indexPath.row];
//    [cell setCellDataWithDataModel:model];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    QLOrderListModel *model = self.dataSource[indexPath.row];
    [self detailInfoRequestWithOrderId:nil];
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *vw=[[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 44)];
    vw.backgroundColor=[UIColor whiteColor];
    
    UILabel *tip=[[UILabel alloc] init];
    [vw addSubview:tip];
    [tip mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leftMargin.equalTo(vw).offset(15);
        make.centerY.equalTo(vw);
    }];
    tip.font=QLFontNormal;
    tip.textColor = QLFontDarkColor;
    tip.text = @"订单编号：";
    
    UILabel *status = [[UILabel alloc]init];
    [vw addSubview:status];
    [status mas_makeConstraints:^(MASConstraintMaker *make) {
        make.rightMargin.equalTo(vw).offset(-15);
        make.width.equalTo(@60);
        make.centerY.equalTo(vw);
    }];
    status.textAlignment = NSTextAlignmentRight;
    status.text = @"代付款";
    status.textColor = QLYellowColor;
    status.font = QLFontNormal;
    
    UILabel *orderNum = [[UILabel alloc] init];
    [vw addSubview:orderNum];
    [orderNum mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(tip.mas_right).offset(15);
        make.right.greaterThanOrEqualTo(status).offset(-15);
        make.centerY.equalTo(vw);
    }];
    orderNum.textColor = QLFontShallowColor;
    orderNum.font=QLFontNormal;
    orderNum.text = @"212121212121";
   
    
    UILabel *line = [[UILabel alloc]init];
    [vw addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottomMargin.equalTo(vw).offset(0.5);
        make.width.equalTo(@(tableView.frame.size.width));
        make.height.equalTo(@0.5);
    }];
    line.backgroundColor = QLDividerColor;
    
        return vw;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *vw=[[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 40)];
    vw.backgroundColor=[UIColor whiteColor];
    
//    UILabel *tip = [[UILabel alloc]init];
//    [vw addSubview:tip];
//    [tip mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.leadingMargin.equalTo(vw).offset(15);
//        make.centerY.equalTo(vw);
//    }];
//    tip.text = @"合计：";
//    tip.font = QLFontNormal;
//    
//    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
//    [vw addSubview:button];
//    [button mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.rightMargin.equalTo(vw).offset(-15);
//        make.width.equalTo(@50);
//        make.height.equalTo(@26);
//        make.centerY.equalTo(vw);
//    }];
//    [button setTitle:@"支付" forState:UIControlStateNormal];
//    [button setTitleColor:QLYellowColor forState:UIControlStateNormal];
//    [button setBorder:.5 borderColor:QLYellowColor];
//    [button.titleLabel setFont:QLFontNormal];
//    
//    UILabel *total = [[UILabel alloc]init];
//    [vw addSubview:total];
//    [total mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.leftMargin.equalTo(tip).offset(15);
//        make.centerY.equalTo(vw);
//    }];
//    total.textColor = QLFontDarkColor;
//    total.text = @"￥200";
//    total.font = QLFontNormal;
    return vw;

}
    
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 44;
}
- ( CGFloat )tableView:( UITableView *)tableView heightForFooterInSection:( NSInteger )section{
    return 40 ;
}

- (void)detailInfoRequestWithOrderId:(NSString *)orderID{
    QLOrderDetailVC *detailVC = [[QLOrderDetailVC alloc]init];
    [[QLHttpTool getCurrentVC].navigationController pushViewController:detailVC animated:YES];
    
    NSString *strUrl = [NSString stringWithFormat:@"%@",QLBaseUrlString];
    [QLHttpTool postWithBaseUrl:strUrl Parameters:nil whenSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
    } whenFailure:^{
        
    }];
}
@end
