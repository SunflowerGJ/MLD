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
    NSMutableDictionary *_dicImgsSave;
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
    uploadIndex = 0;
    [self uploadImage:_imgsArray];
}

- (void)uploadImage:(NSMutableArray *)array{
    NSData *data = UIImageJPEGRepresentation(array[uploadIndex], 1);
    NSString *imageURL = [NSString stringWithFormat:@"%@%@",QLBaseUrlString_Image,fileUpload_interface];
    __weak typeof (self)weakSelf = self;
    [QLHttpTool postPerWithBaseUrl:imageURL Parameters:@{@"basePath":@"user"} FormData:data FileExtension:@".jpg" MimeType:@"image/jpg"  whenSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        QLLog(@"image response : %@", responseObject);
        NSString *imageUrl = [NSString stringWithFormat:@"%@",responseObject[@"msg"]];
        [_dicImgsSave setObject:imageUrl forKey:[NSString stringWithFormat:@"%ld",uploadIndex]];
        if (imageUrl&&imageUrl.length>0&&uploadIndex<array.count-1) {
            uploadIndex++;
            [weakSelf uploadImage:array[uploadIndex]];
        }else{
            [QLHUDTool showAlertMessage:@"图片上传成功！"];
            [weakSelf uploadImageInfoData];
        }
    } whenFailure:^{
    }];
    

}
- (void)uploadImageInfoData{
    NSString *strBaseUrl = [NSString stringWithFormat:@"%@%@",QLBaseUrlString,admissionAddOrUpdate_interface];
//    NSDictionary *dic=@{@"sign_id":[NSString getValidStringWithObject:_signId]};
    NSMutableDictionary *dic = [NSMutableDictionary new];
    for (NSInteger i=0; i<_dicImgsSave.allValues.count; i++) {
        [dic setObject:_dicImgsSave.allValues[i] forKey:[NSString stringWithFormat:@"photo_%ld",i]];
    }
    
    
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
