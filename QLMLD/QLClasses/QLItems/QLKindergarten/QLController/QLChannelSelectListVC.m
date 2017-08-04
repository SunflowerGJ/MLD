//
//  QLChannelListVC.m
//  QLMLD
//
//  Created by syy on 2017/7/27.
//  Copyright © 2017年 Shreker. All rights reserved.
//

#import "QLChannelSelectListVC.h"
#import "MJRefresh.h"
#import "UIScrollView+KS.h"
#import "QLChannelSelectCell.h"
@interface QLChannelSelectListVC ()<UITableViewDataSource,UITableViewDelegate,KSRefreshViewDelegate>{
    
    __weak IBOutlet UITableView *_tableMain;
    NSInteger _pageSize;
    NSInteger _pageNum;
}

@end

@implementation QLChannelSelectListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadDefaultSetting];
}
- (void)loadDefaultSetting {
    self.title = @"频道列表";
    _pageSize = 10;
    _tableMain.estimatedRowHeight = 100;
    _tableMain.tableFooterView = [UIView new];
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
#pragma mark - dataRequest
/** 下拉刷新 */
- (void)tableHeadLoad{
    _pageNum = 0;
    NSString *strBaseUrl = [NSString stringWithFormat:@"%@%@",QLBaseUrlString,addSelectedList_interface];
    NSDictionary *dicParam = @{@"pageNumber":[NSString stringWithFormat:@"%ld",(long)_pageNum],@"pageSize":[NSString stringWithFormat:@"%ld",(long)_pageSize]};
    [QLHttpTool postWithBaseUrl:strBaseUrl Parameters:dicParam whenSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        QLLog(@"订单信息：%@",responseObject);
        NSMutableArray *array = [NSMutableArray new];
        array = [QLChannelListDataModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
        self.dataSource = [[NSMutableArray alloc] initWithArray:array];
        [_tableMain reloadData];
        [_tableMain headerEndRefreshing];
        
        if(self.dataSource&&self.dataSource.count>0){
            self.promptView.hidden = YES;
        }else{
            self.promptView.hidden = NO;
            self.promptL.text =@"这里暂时还没有内容~";
        }
        if([responseObject[@"total"] integerValue]<=_pageSize){
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
        NSString *strBaseUrl = [NSString stringWithFormat:@"%@%@",QLBaseUrlString,addSelectedList_interface];
        NSDictionary *dicParam = @{@"pageNumber":[NSString stringWithFormat:@"%ld",(long)_pageNum*_pageSize],@"pageSize":[NSString stringWithFormat:@"%ld",(long)_pageSize]};
        
        [QLHttpTool postWithBaseUrl:strBaseUrl Parameters:dicParam whenSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
            if(self.dataSource){
                NSMutableArray *array = [QLChannelListDataModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
                [self.dataSource addObjectsFromArray:array];
            }else{
                NSMutableArray *array = [QLChannelListDataModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
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
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    QLChannelSelectCell *cell = [QLChannelSelectCell cellWithChannelSelectTableView:tableView];
//    [cell setCellDataWithModel:self.dataSource[indexPath.row]];
//    __weak typeof (self) weakSelf = self;
//    [cell setBlockCellSelected:^{
//        QLChannelListDataModel *model = self.dataSource[indexPath.row];
//        if (weakSelf.blockSelectedModel) {
//            weakSelf.blockSelectedModel(model);
//        }
//        [[QLHttpTool getCurrentVC].navigationController popViewControllerAnimated:YES];
//    }];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
@end
