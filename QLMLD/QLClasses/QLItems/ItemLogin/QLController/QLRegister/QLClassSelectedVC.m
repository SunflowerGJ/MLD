//
//  QLClassSelectedVC.m
//  QLMLD
//
//  Created by syy on 2017/7/18.
//  Copyright © 2017年 Shreker. All rights reserved.
//

#import "QLClassSelectedVC.h"

@interface QLClassSelectedVC ()

@end

@implementation QLClassSelectedVC

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
    return self.dataSource.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIndentity=@"customCell";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellIndentity];
    if (cell==nil) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentity];
    }
    QLClassDataModel *model = self.dataSource[indexPath.row];
//    cell.textLabel.text = model
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

#pragma mark -
- (void)getKinderData{
    NSString *strUrl = [NSString stringWithFormat:@"%@%@?active=1&&school_id=%@",QLBaseUrlString,getClassInfoFromKinder_interface,_schoolId];
    [QLHttpTool getWithBaseUrl:strUrl Parameters:nil whenSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        QLLog(@"class data: %@",responseObject);
    } whenFailure:^{
        
    }];
}

@end
