//
//  QLAdmissionDetailVC.m
//  QLMLD
//
//  Created by 英英 on 2017/7/23.
//  Copyright © 2017年 Shreker. All rights reserved.
//

#import "QLAdmissionDetailVC.h"
#import "QLAdmissionDetailCell.h"
#import "QLAdmissionEditVC.h"
@interface QLAdmissionDetailVC ()<UITableViewDelegate,UITableViewDataSource>{
    
    __weak IBOutlet UITableView *_tableMain;
    NSInteger uploadIndex;
}

@end

@implementation QLAdmissionDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self loadDefaultSetting];
}
- (void)loadDefaultSetting {
    self.title = @"成长印记";
    _tableMain.estimatedRowHeight = 100;
    _tableMain.tableFooterView = [UIView new];
    [_tableMain addSubview: self.promptView];
    [self uploadImage:_imgsArray];
}

- (void)uploadImage:(UIImage *)image{
    NSData *data = UIImageJPEGRepresentation(image, 1);
    NSString *imageURL = [NSString stringWithFormat:@"%@%@",QLBaseUrlString_Image,fileUpload_interface];
    [QLHttpTool postPerWithBaseUrl:imageURL Parameters:@{@"basePath":@"user"} FormData:data FileExtension:@".jpg" MimeType:@"image/jpg"  whenSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        QLLog(@"image response : %@", responseObject);
        NSString *imageUrl = [NSString stringWithFormat:@"%@",responseObject[@"msg"]];
    } whenFailure:^{
    }];
    

}
- (void)uploadImageInfoData{
    NSString *strBaseUrl = [NSString stringWithFormat:@"%@%@",QLBaseUrlString,admissionAddOrUpdate_interface];
    NSDictionary *dic=@{@"sign_id":[NSString getValidStringWithObject:_signId]};
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 6;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    QLAdmissionDetailCell *cell = [QLAdmissionDetailCell cellWithAdmissionDetailTableView:tableView];
//    QLClassHomeDataModel *model = self.dataSource[indexPath.row];
//    [cell setCellDataWithDataModel:model];
    [cell setBlockEdit:^{
        QLAdmissionEditVC *editVC = [[QLAdmissionEditVC alloc]init];
        [editVC setBlockSuccess:^{
            //编辑成功刷新数据
        }];
        [[QLHttpTool getCurrentVC].navigationController pushViewController:editVC animated:YES];
    }];
    return cell;
}

@end
