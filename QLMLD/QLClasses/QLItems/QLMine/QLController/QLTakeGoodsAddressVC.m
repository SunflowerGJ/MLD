//
//  QLTakeGoodsAddressVC.m
//  QLMLD
//
//  Created by 英英 on 2017/7/18.
//  Copyright © 2017年 Shreker. All rights reserved.
//  收货地址管理

#import "QLTakeGoodsAddressVC.h"
#import "QLAddressManageCell.h"
#import "QLAddressManageModel.h"
@interface QLTakeGoodsAddressVC ()<UITableViewDelegate,UITableViewDataSource>{
    
    __weak IBOutlet UITableView *_tableMain;
    
    NSInteger _pageSize;
    NSInteger _pageNum;
    

}

@end

@implementation QLTakeGoodsAddressVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadDefaultSetting];
}
- (void)loadDefaultSetting {
    self.title = @"收货地址管理";
    
    self.rightBtn.hidden = NO;
    self.rightBtn.frame = CGRectMake(QLScreenWidth-40, 28, 30, 30);
    [self.rightBtn setTitle:@"编辑" forState:UIControlStateNormal];
    
    _pageSize = 10;
    _tableMain.estimatedRowHeight = 100;
    [_tableMain addSubview: self.promptView];
    _tableMain.separatorColor = QLDividerColor;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - btn
- (void)clickRight {
    
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 6;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    QLAddressManageCell *cell = [QLAddressManageCell cellWithAddressTableView:tableView];
    QLAddressManageModel *model = self.dataSource[indexPath.row];
    [cell setCellDataWithAddressModel:model];
    return cell;
}


@end
