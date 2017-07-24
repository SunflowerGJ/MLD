//
//  QLKinderSelectedVC.m
//  QLMLD
//
//  Created by syy on 2017/7/18.
//  Copyright © 2017年 Shreker. All rights reserved.
//

#import "QLKinderSelectedVC.h"
#import "QLClassSelectedVC.h"
#import "MJRefresh.h"
#import "UIScrollView+KS.h"
@interface QLKinderSelectedVC ()<UITableViewDelegate,UITableViewDataSource,KSRefreshViewDelegate>{
    QLClassDataModel *_classModel;
    
    __weak IBOutlet UITableView *_tableMain;
    NSInteger _pageSize;
    NSInteger _pageNum;
}

@end

@implementation QLKinderSelectedVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadDefaultSetting];
}
- (void)loadDefaultSetting {
    self.title = @"选择幼儿园";
    
    _pageSize = 10;
    _tableMain.estimatedRowHeight = 100;
    _tableMain.tableFooterView = [UIView new];
    [_tableMain addSubview: self.promptView];
    _tableMain.separatorColor = QLDividerColor;
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
    NSString *strBaseUrl = [NSString stringWithFormat:@"%@%@",QLBaseUrlString,getKinderData_interface];
    NSDictionary *dicParam = @{@"start":[NSString stringWithFormat:@"%ld",(long)_pageNum],@"limit":[NSString stringWithFormat:@"%ld",(long)_pageSize]};
    [QLHttpTool getWithBaseUrl:strBaseUrl Parameters:dicParam whenSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        QLLog(@"kinder data: %@",responseObject);
        
        NSMutableArray *array = [NSMutableArray new];
        array = [QLKinderDataModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
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
        NSString *strBaseUrl = [NSString stringWithFormat:@"%@%@",QLBaseUrlString,getKinderData_interface];
        NSDictionary *dicParam = @{@"pageNumber":[NSString stringWithFormat:@"%ld",(long)_pageNum],@"pageSize":[NSString stringWithFormat:@"%ld",(long)_pageSize]};
        
        [QLHttpTool postWithBaseUrl:strBaseUrl Parameters:dicParam whenSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
            if(self.dataSource){
                NSMutableArray *array = [QLKinderDataModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
                [self.dataSource addObjectsFromArray:array];
            }else{
                NSMutableArray *array = [QLKinderDataModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
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
    return _dataSource.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIndentity=@"customCell";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellIndentity];
    if (cell==nil) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentity];
    }
    QLKinderDataModel *model = self.dataSource[indexPath.row];
//    cell
    cell.textLabel.text = model.school_name;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_fromClassCircle) {//来自班级圈
        QLKinderDataModel *model = self.dataSource[indexPath.row];
        self.blockSchool(model);
        [[QLHttpTool getCurrentVC].navigationController popViewControllerAnimated:YES];
        return;
    }
    QLClassSelectedVC *classVC = [[QLClassSelectedVC alloc]init];
    QLKinderDataModel *model = self.dataSource[indexPath.row];
    classVC.schoolModel = model;
//    __weak __typeof(self)weakSelf = self;
//    __weak __typeof(QLKinderDataModel *) schoolModel = model;
//    [classVC setBlockSelectedClass:^(QLClassDataModel *model){
//        _classModel = model;
//        weakSelf.blockSelectedSchool(schoolModel, model);
//        [[QLHttpTool getCurrentVC].navigationController popViewControllerAnimated:YES];
//    }];
    [[QLHttpTool getCurrentVC].navigationController pushViewController:classVC animated:YES];
    [self removeFromParentViewController];

}

@end
