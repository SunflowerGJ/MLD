//
//  QLSelectYearView.h
//  LiChi
//
//  Created by Shrek on 16/4/19.
//  Copyright © 2016年 cn.forp.app. All rights reserved.
//

#import <UIKit/UIKit.h>

//选择时间代理
@protocol QLSelectYearDelegate <NSObject>

- (void)selectYear:(NSString *)year;

@end

@interface QLSelectYearView : UIView<UIPickerViewDelegate,UIPickerViewDataSource>

@property (nonatomic, assign) id <QLSelectYearDelegate> delegate;

@property (weak, nonatomic) IBOutlet UIView *backGroundView;
@property (weak, nonatomic) IBOutlet UIView *selectView;
@property (weak, nonatomic) IBOutlet UIPickerView *myAreaPicker;

@property (nonatomic, strong) NSMutableArray * dataYear;
@property (nonatomic, strong) NSString *strYear;
- (IBAction)clickCancel:(id)sender;
- (IBAction)clickSave:(id)sender;

@end
