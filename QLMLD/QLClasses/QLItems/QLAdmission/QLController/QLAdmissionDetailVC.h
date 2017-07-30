//
//  QLAdmissionDetailVC.h
//  QLMLD
//
//  Created by 英英 on 2017/7/23.
//  Copyright © 2017年 Shreker. All rights reserved.
//

#import "QLViewController.h"

@interface QLAdmissionDetailVC : QLViewController
@property (nonatomic, strong) NSString *signId;
@property (nonatomic, strong) NSString *remark;
@property (nonatomic, strong) NSString *photo;
@property (nonatomic, strong) NSMutableArray *imgsArray;
@property (nonatomic, strong) NSMutableArray *dataSource;
@end
