//
//  QLAdmissionEditVC.h
//  QLMLD
//
//  Created by 英英 on 2017/7/30.
//  Copyright © 2017年 Shreker. All rights reserved.
//

#import "QLViewController.h"

@interface QLAdmissionEditVC : QLViewController
@property (nonatomic, strong) NSString *strID;
@property (nonatomic,copy) void (^blockSuccess)();

@end
