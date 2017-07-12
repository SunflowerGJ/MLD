
//
//  QLClassHome.m
//  QLMLD
//
//  Created by 英英 on 2017/7/2.
//  Copyright © 2017年 Shreker. All rights reserved.
//

#import "QLClassHome.h"
#import "QLClassHomeTableCell.h"
#import "QLClassHomeDataModel.h"
#import "MJRefresh.h"
#import "UIScrollView+KS.h"

@interface QLClassHome ()<UITableViewDelegate,UITableViewDataSource,KSRefreshViewDelegate>{
    
    __weak IBOutlet UITableView *_tableMain;
    
    __weak IBOutlet UIImageView *_imgMark;
    
    IBOutlet UIView *_viewCustomTitle;
    
    NSInteger _pageSize;
    NSInteger _pageNum;

}

@end

@implementation QLClassHome

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadDefaultSetting];
}
- (void)loadDefaultSetting{
    self.leftBtn.hidden = YES;
//    self.rightBtn.hidden = NO;
//    self.rightBtn.frame= CGRectMake(QLScreenWidth-60, 28, 60, 30);
//    [self.rightBtn setImage:[UIImage imageNamed:@"camera_icon"] forState:UIControlStateNormal];
    
    UIView *viewRight = [[UIView alloc]init];
    self.titleView = _viewCustomTitle;
    
    /*
    UIButton *right = [UIButton buttonWithType:UIButtonTypeCustom];
    [right setImage:[UIImage imageNamed:@"camera_icon"] forState:UIControlStateNormal];
    [viewRight addSubview:right];
    [right mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(viewRight).offset(0);
        make.width.equalTo(@60);
        make.height.equalTo(@30);
    }];
    UIImageView *line = [[UIImageView alloc]init];
    [viewRight addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(right).offset(5);
        make.width.equalTo(@0.5);
        make.topMargin.equalTo(right);
        make.bottomMargin.equalTo(right);
    }];
    line.backgroundColor = [UIColor whiteColor];
    
    UIButton *left = [UIButton buttonWithType:UIButtonTypeCustom];
    [left setImage:[UIImage imageNamed:@"share_icon"] forState:UIControlStateNormal];
    [viewRight addSubview:left];
    [left mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(viewRight).offset(5);
        make.width.equalTo(right);
        make.height.equalTo(right);
        make.centerY.equalTo(right);
    }];

    
    [viewRight mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.titleView).offset(15);
        make.centerY.equalTo(self.titleView).offset(40);
    }];
    
*/
    _pageSize = 10;
    _tableMain.estimatedRowHeight = 100;
    [_tableMain addSubview: self.promptView];
    _tableMain.separatorColor = QLLineColor;
    [self addTableViewRefresh];
    [_tableMain headerBeginRefreshing];
}

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
        QLLog(@"我的工单：%@",responseObject);
        NSMutableArray *array = [NSMutableArray new];
        array = [QLClassHomeDataModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"][@"rows"]];
        self.dataSource = [[NSMutableArray alloc] initWithArray:array];
        [_tableMain reloadData];
        [_tableMain headerEndRefreshing];
        
        if(self.dataSource&&self.dataSource.count>0){
            self.promptView.hidden = YES;
        }else{
            self.promptView.hidden = NO;
            self.promptL.text =@"这里暂时还没有内容~";
        }
        if([responseObject[@"data"][@"total"] integerValue]<=_pageNum*_pageSize){
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
                NSMutableArray *array = [QLClassHomeDataModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"][@"rows"]];
                [self.dataSource addObjectsFromArray:array];
            }else{
                NSMutableArray *array = [QLClassHomeDataModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"][@"rows"]];
                self.dataSource = [[NSMutableArray alloc] initWithArray:array];
            }
            [_tableMain reloadData];
            if([responseObject[@"data"][@"total"] integerValue]<=_pageNum*_pageSize){
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
    return 6;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    QLClassHomeTableCell *cell = [QLClassHomeTableCell cellWithClassHomeTableView:tableView];
    QLClassHomeDataModel *model = self.dataSource[indexPath.row];
    [cell setCellDataWithDataModel:model];
    return cell;
}

@end
