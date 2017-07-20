//
//  QLMineViewController.m
//  QLMLD
//
//  Created by 英英 on 2017/7/5.
//  Copyright © 2017年 Shreker. All rights reserved.
//

#import "QLMineViewController.h"
#import "QLMineHomeTableCell.h"
#import "QLGoodsOrderVC.h"
#import "QLUserInfoVC.h"
#import "QLWebViewController.h"
#import "QLTakeGoodsAddressVC.h"
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
    self.leftBtn.hidden = YES;
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

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger row = indexPath.row;
    switch (row) {
        case 0:{
            QLTakeGoodsAddressVC *addressVC = [[QLTakeGoodsAddressVC alloc]init];
            [[QLHttpTool getCurrentVC].navigationController pushViewController:addressVC animated:YES];
        }
            break;
        case 1:{
            
        }
            break;
    }
}
#pragma mark - Touch
//商品订单
- (IBAction)controlGoodsOrder:(id)sender {
    QLGoodsOrderVC *goodsOrder = [[QLGoodsOrderVC alloc]init];
    [[QLHttpTool getCurrentVC].navigationController pushViewController:goodsOrder animated:YES];
}
//待收货
- (IBAction)controlWaitGetGoods:(id)sender {
    QLWebViewController *webVC = [[QLWebViewController alloc]init];
    [[QLHttpTool getCurrentVC].navigationController pushViewController:webVC animated:YES];
}
- (IBAction)controlWaitSendGoods:(id)sender {
}
#pragma mark - button
- (IBAction)btnUserHeadImage:(id)sender {
    QLUserInfoVC *infoVC = [[QLUserInfoVC alloc]init];
    [[QLHttpTool getCurrentVC].navigationController pushViewController:infoVC animated:YES];
}

@end
