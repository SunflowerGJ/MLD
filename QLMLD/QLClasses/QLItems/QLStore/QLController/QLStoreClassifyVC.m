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
@interface QLStoreClassifyVC ()<UITableViewDelegate,UITableViewDataSource>{
    
    __weak IBOutlet UITableView *_tableMain;
}

@end

@implementation QLStoreClassifyVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadDefaultSetting];
}

- (void)loadDefaultSetting {
    self.title = @"商城分类";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    QLStoreCLassTableCell *cell = [QLStoreCLassTableCell cellWithStoreClassTableView:tableView];
    QLStoreClassModel *model = self.dataSource[indexPath.row];
    [cell setCellDataWithStoreClassModel:model];
    return cell;
}


@end
