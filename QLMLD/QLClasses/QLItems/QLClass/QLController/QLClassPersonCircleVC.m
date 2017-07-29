//
//  QLClassPersonCircleVC.m
//  QLMLD
//
//  Created by syy on 2017/7/25.
//  Copyright © 2017年 Shreker. All rights reserved.
//

#import "QLClassPersonCircleVC.h"
#import "MJRefresh.h"
#import "UIScrollView+KS.h"
#import "QLClassHomeDataModel.h"
#import "QLClassHomeTableCell.h"
@interface QLClassPersonCircleVC ()<UITableViewDelegate,UITableViewDataSource,KSRefreshViewDelegate>{
    __weak IBOutlet UIImageView *_imgHead;
    __weak IBOutlet UILabel *_lblUserName;
    NSInteger _pageSize;
    NSInteger _pageNum;
    NSString *_strImageID;
    __weak IBOutlet UITableView *_tableMain;

    IBOutlet UIView *_viewHeader;
    __weak IBOutlet UIImageView *_imgViewHeadLine;
    __weak IBOutlet UILabel *_lblIsPraised;//被赞
    __weak IBOutlet UILabel *_lblToPraise;//点赞
    __weak IBOutlet UIButton *btnClose;
    __weak IBOutlet UIImageView *_imgBg;
}

@end

@implementation QLClassPersonCircleVC
- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    [self sizeHeaderToFit];
}
- (void)sizeHeaderToFit{
    UIView *headerView = _viewHeader;
    [headerView setNeedsLayout];
    [headerView layoutIfNeeded];
    CGRect frameHeader = _viewHeader.frame;
    frameHeader.size.height = _imgViewHeadLine.frame.origin.y;
    headerView.frame = frameHeader;
    _tableMain.tableHeaderView = headerView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.titleView.hidden = YES;
    [self BlurWithImageView:_imgBg];
    [self loadDefaultSetting];
}
- (void)loadDefaultSetting{
    self.rightBtn.hidden = NO;
    self.rightBtn.frame = CGRectMake(QLScreenWidth-40, 28, 30, 30);
    [self.rightBtn setImage:[UIImage imageNamed:@"camera_icon"] forState:UIControlStateNormal];
    _pageSize = 10;
    _tableMain.estimatedRowHeight = 100;
    _tableMain.tableFooterView = [UIView new];
    [_tableMain addSubview: self.promptView];
    _tableMain.separatorColor = QLDividerColor;
    [self addTableViewRefresh];
    [_tableMain headerBeginRefreshing];
    
    NSString *head = [QLUserTool sharedUserTool].userModel.user_photo;
    NSString *userHeadUrl = [NSString stringWithFormat:@"%@%@",QLBaseUrlString_Image,head];
    [_imgHead sd_setImageWithURL:[NSURL URLWithString:userHeadUrl] placeholderImage:nil];
    [_imgHead setCornerRadius:_imgHead.frame.size.width/2];
    _lblUserName.text = @"应";
    
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
        array = [QLClassHomeDataModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
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
                NSMutableArray *array = [QLClassHomeDataModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
                [self.dataSource addObjectsFromArray:array];
            }else{
                NSMutableArray *array = [QLClassHomeDataModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
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
#pragma mark - btn
- (IBAction)btnClose:(id)sender {
    [[QLHttpTool getCurrentVC].navigationController popViewControllerAnimated:YES];
}

#pragma mark - table'delegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 5;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIndentity=@"customCell";
    QLClassHomeTableCell *cell = [QLClassHomeTableCell cellWithClassHomeTableView:tableView];
    //    QLClassHomeDataModel *model = self.dataSource[indexPath.row];
    //    [cell setCellDataWithDataModel:model];
    return cell;
}

#pragma mark - 毛玻璃
- (void)BlurWithImageView:(UIImageView *)imageview{
    
    if ([UIDevice currentDevice].systemVersion.floatValue>=8.0) {
        /**  毛玻璃特效类型
         *  UIBlurEffectStyleExtraLight,
         *  UIBlurEffectStyleLight,
         *  UIBlurEffectStyleDark
         */
        UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
        
        //  毛玻璃视图
        UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
//        self.effectView = effectView;
        
        //添加到要有毛玻璃特效的控件中
        [imageview addSubview:effectView];
        
        [effectView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(imageview);
        }];
        //设置模糊透明度
        effectView.alpha = 0.74f;
    }
}



@end
