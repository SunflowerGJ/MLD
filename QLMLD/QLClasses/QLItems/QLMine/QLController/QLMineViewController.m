//
//  QLMineViewController.m
//  QLMLD
//
//  Created by 英英 on 2017/7/5.
//  Copyright © 2017年 Shreker. All rights reserved.
//

#import "QLMineViewController.h"
#import "QLMineHomeTableCell.h"
@interface QLMineViewController ()<UITableViewDelegate,UITableViewDataSource>{
    
    __weak IBOutlet NSLayoutConstraint *_heightTableConstraint;
    NSArray *_arrayData;
    
    __weak IBOutlet UITableView *_tableMain;
}

@end

@implementation QLMineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadDefaultSetting];
}
- (void)loadDefaultSetting{
    _arrayData = @[@"收货地址管理",@"绑定考勤卡",@"我的学校（幼儿园信息介绍）",@"客服电话",@"关于美乐多"];
    _heightTableConstraint.constant = _arrayData.count*44;
    [_tableMain reloadData];
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
        return _arrayData.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    QLMineHomeTableCell *cell = [QLMineHomeTableCell cellWithMineHomeTableView:tableView];
    [cell setCellDataWithTitle:_arrayData[indexPath.row]];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}



@end
