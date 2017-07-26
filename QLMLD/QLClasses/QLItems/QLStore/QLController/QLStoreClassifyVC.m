//
//  QLStoreClassifyVC.m
//  QLMLD
//
//  Created by 英英 on 2017/7/22.
//  Copyright © 2017年 Shreker. All rights reserved.
//

#import "QLStoreClassifyVC.h"
#import "QLStoreCLassTableCell.h"
#import "QLStoreClassModel.h"
#import "MJRefresh.h"
#import "UIScrollView+KS.h"

@interface QLStoreClassifyVC ()<KSRefreshViewDelegate,UITableViewDelegate,UITableViewDataSource>{
    
    __weak IBOutlet UITableView *_tableMain;
    NSInteger _pageSize;
    NSInteger _pageNum;
    NSString *_strSearch;
}

@end

@implementation QLStoreClassifyVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadDefaultSetting];
}

- (void)loadDefaultSetting {
    self.title = @"商城分类";
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
/** 下拉刷新 */
- (void)tableHeadLoad{
    _pageNum = 1;
    NSString *strBaseUrl = [NSString stringWithFormat:@"%@%@",QLBaseUrlString,class_interface];
    NSDictionary *dicParam = @{@"start":[NSString stringWithFormat:@"%ld",(long)_pageNum],@"limit":[NSString stringWithFormat:@"%ld",(long)_pageSize]};
    [QLHttpTool postWithBaseUrl:strBaseUrl Parameters:dicParam whenSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        QLLog(@"班级圈信息：%@",responseObject);
        NSMutableArray *array = [NSMutableArray new];
        array = [QLStoreClassModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
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
                NSMutableArray *array = [QLStoreClassModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
                [self.dataSource addObjectsFromArray:array];
            }else{
                NSMutableArray *array = [QLStoreClassModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
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

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
//    return self.dataSource.count;
    return 5;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    QLStoreCLassTableCell *cell = [QLStoreCLassTableCell cellWithStoreClassTableView:tableView];
//    QLStoreClassModel *model = self.dataSource[indexPath.row];
//    [cell setCellDataWithStoreClassModel:model];
    return cell;
}


@end
