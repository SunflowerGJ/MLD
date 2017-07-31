//
//  QLClassUploadImageVC.h
//  QLMLD
//
//  Created by 英英 on 2017/7/22.
//  Copyright © 2017年 Shreker. All rights reserved.
//  班级圈上传照片

#import "QLViewController.h"

@interface QLClassUploadImageVC : QLViewController
@property (nonatomic, strong) NSMutableArray *muArrayImages;
@property (nonatomic, copy) void (^blockPublishSuccess)();

@end
