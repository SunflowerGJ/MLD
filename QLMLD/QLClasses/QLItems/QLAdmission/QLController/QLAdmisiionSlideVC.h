//
//  QLAdmisiionSlideVC.h
//  QLMLD
//
//  Created by 英英 on 2017/7/23.
//  Copyright © 2017年 Shreker. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QLAdmisiionSlideVC : UIViewController
@property (weak, nonatomic) IBOutlet UIView *backGroundView;
@property (weak, nonatomic) IBOutlet UIView *mainView;
@property (strong ,nonatomic) NSArray *arrayDatasource;

-(void)startAnimation;
- (IBAction)clickBackGround:(id)sender;

@end
