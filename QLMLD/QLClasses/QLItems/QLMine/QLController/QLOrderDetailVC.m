//
//  QLOrderDetailVC.m
//  QLMLD
//
//  Created by 英英 on 2017/7/23.
//  Copyright © 2017年 Shreker. All rights reserved.
//

#import "QLOrderDetailVC.h"
@interface QLOrderDetailVC ()<UITableViewDelegate,UITableViewDataSource>{
    
    __weak IBOutlet UITableView *_tableMain;
    
    IBOutlet UIView *_viewFooter;
    
    __weak IBOutlet UILabel *_lblTotal;
    __weak IBOutlet UILabel *_lblOrderTime;
    __weak IBOutlet UIButton *_btnPay;
    
    IBOutlet UIView *_viewHeader;
    
    __weak IBOutlet UILabel *_lblReceiver;
    __weak IBOutlet UILabel *_lblReceiveAddress;
}

@end

@implementation QLOrderDetailVC
- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    [self sizeHeaderToFit];
    [self sizeFooterToFit];
}
- (void)sizeHeaderToFit{
    UIView *headerView = _viewHeader;
    [headerView setNeedsLayout];
    [headerView layoutIfNeeded];
    CGRect frameHeader = _viewHeader.frame;
    frameHeader.size.height = _lblReceiveAddress.frame.origin.y;
    headerView.frame = frameHeader;
    _tableMain.tableHeaderView = headerView;
}
- (void)sizeFooterToFit{
    UIView *footerView = _viewFooter;
    [footerView setNeedsLayout];
    [footerView layoutIfNeeded];
    CGRect frameHeader = _viewFooter.frame;
    frameHeader.size.height = _btnPay.frame.origin.y;
    footerView.frame = frameHeader;
    _tableMain.tableHeaderView = footerView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadDefaultSetting];
}
- (void)loadDefaultSetting{
    self.title = @"订单详情";
    [_btnPay setCornerRadius:QLCornerRadius];
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
    return 4;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIndentity=@"customCell";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellIndentity];
    if (cell==nil) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentity];
    }
    return cell;
}

@end
