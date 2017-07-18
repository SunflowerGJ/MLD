//
//  QLKinderSelectedVC.m
//  QLMLD
//
//  Created by syy on 2017/7/18.
//  Copyright © 2017年 Shreker. All rights reserved.
//

#import "QLKinderSelectedVC.h"
#import "QLClassSelectedVC.h"
@interface QLKinderSelectedVC ()<UITableViewDelegate,UITableViewDataSource>{
    QLClassDataModel *_classModel;
}

@end

@implementation QLKinderSelectedVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadDefaultSetting];
}
- (void)loadDefaultSetting {
    self.title = @"选择幼儿园";
    [self getKinderData];
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
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    QLClassSelectedVC *classVC = [[QLClassSelectedVC alloc]init];
    QLKinderDataModel *model = self.dataSource[indexPath.row];
//    classVC.schoolId = model.id;
    [classVC setBlockSelectedClass:^(QLClassDataModel *model){
        _classModel = model;
    }];
    [[QLHttpTool getCurrentVC].navigationController pushViewController:classVC animated:YES];
}

#pragma mark -
- (void)getKinderData{
    NSString *strUrl = [NSString stringWithFormat:@"%@%@?active=1",QLBaseUrlString,getKinderData_interface];
    [QLHttpTool getWithBaseUrl:strUrl Parameters:nil whenSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        QLLog(@"kinder data: %@",responseObject);
    } whenFailure:^{
       
    }];
}
@end
