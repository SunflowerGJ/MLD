//
//  QLMineViewController.m
//  QLMLD
//
//  Created by 英英 on 2017/7/5.
//  Copyright © 2017年 Shreker. All rights reserved.
//

#import "QLMineViewController.h"
#import "QLMineHomeTableCell.h"
#import "QLUserInfoVC.h"
#import "QLWebViewController.h"
#import "QLTakeGoodsAddressVC.h"
#import "QLBindTimecardVC.h"
#import "QLSchoolInfoVC.h"
#import "QLAboutUsVC.h"
#import "QLOrderListVC.h"
@interface QLMineViewController ()<UITableViewDelegate,UITableViewDataSource>{
    
    __weak IBOutlet NSLayoutConstraint *_heightTableConstraint;
    NSArray *_arrayData;
    
    __weak IBOutlet UITableView *_tableMain;
    __weak IBOutlet UILabel *_lblUserName;
    __weak IBOutlet UILabel *_lblTele;
    __weak IBOutlet UIImageView *_imgHead;
}

@end

@implementation QLMineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadDefaultSetting];
}
- (void)loadDefaultSetting{
    self.leftBtn.hidden = YES;
    NSString *tele = [QLUserTool sharedUserTool].userModel.user_tel;
    NSString *name = [QLUserTool sharedUserTool].userModel.user_name;
    NSString *strHeadUrl = [QLUserTool sharedUserTool].userModel.user_photo;
    _lblTele.text = tele;
    _lblUserName.text = name;
    [_imgHead setCornerRadius:_imgHead.frame.size.width/2];
    [_imgHead sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",QLBaseUrlString_Image,strHeadUrl]] placeholderImage:nil];
    
    
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
            QLBindTimecardVC *timecardVC = [[QLBindTimecardVC alloc]init];
            [[QLHttpTool getCurrentVC].navigationController pushViewController:timecardVC animated:YES];
        }
            break;
        case 2:{
            QLSchoolInfoVC *schoolVC = [[QLSchoolInfoVC alloc]init];
            [[QLHttpTool getCurrentVC].navigationController pushViewController:schoolVC animated:YES];
        }
            break;
        case 4:{
            QLAboutUsVC *usVC = [[QLAboutUsVC alloc]init];
            [[QLHttpTool getCurrentVC].navigationController pushViewController:usVC animated:YES];
        }
            break;
            default:
            break;
    }
}
#pragma mark - Touch
//商品订单
- (IBAction)controlGoodsOrder:(id)sender {
    QLOrderListVC *orderListVC = [[QLOrderListVC alloc]init];
    orderListVC.orderType = OrderListTypeAll;
    [[QLHttpTool getCurrentVC].navigationController pushViewController:orderListVC animated:YES];
}
//待收货
- (IBAction)controlWaitGetGoods:(id)sender {
    QLOrderListVC *orderListVC = [[QLOrderListVC alloc]init];
    orderListVC.orderType = OrderListTypeWaitReceive;
    [[QLHttpTool getCurrentVC].navigationController pushViewController:orderListVC animated:YES];
}
//待发货
- (IBAction)controlWaitSendGoods:(id)sender {
    QLOrderListVC *orderListVC = [[QLOrderListVC alloc]init];
    orderListVC.orderType = OrderListTypeWaitSend;
    [[QLHttpTool getCurrentVC].navigationController pushViewController:orderListVC animated:YES];
}
#pragma mark - button
- (IBAction)btnUserHeadImage:(id)sender {
    QLUserInfoVC *infoVC = [[QLUserInfoVC alloc]init];
    [[QLHttpTool getCurrentVC].navigationController pushViewController:infoVC animated:YES];
}

@end
