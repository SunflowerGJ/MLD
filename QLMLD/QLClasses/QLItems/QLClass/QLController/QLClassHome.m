
//
//  QLClassHome.m
//  QLMLD
//
//  Created by 英英 on 2017/7/2.
//  Copyright © 2017年 Shreker. All rights reserved.
//

#import "QLClassHome.h"

@interface QLClassHome ()<UITableViewDelegate,UITableViewDataSource>{
    
    __weak IBOutlet UITableView *_tableMain;
    
    __weak IBOutlet UIImageView *_imgMark;
}

@end

@implementation QLClassHome

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadDefaultSetting];
}
- (void)loadDefaultSetting{
    
    self.rightBtn.hidden = NO;
    self.rightBtn.frame= CGRectMake(QLScreenWidth-60, 28, 60, 30);
    [self.rightBtn setImage:[UIImage imageNamed:@"camera_icon"] forState:UIControlStateNormal];

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
    return 0;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIndentity=@"customCell";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellIndentity];
    if (cell==nil) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentity];
    }
    return cell;
}

@end
