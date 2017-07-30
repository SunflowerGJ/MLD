//
//  QLAdmisiionSlideVC.m
//  QLMLD
//
//  Created by 英英 on 2017/7/23.
//  Copyright © 2017年 Shreker. All rights reserved.
//

#import "QLAdmisiionSlideVC.h"
#import "QLAdmissionHomeTableCell.h"
#import "QLSelectYearView.h"
@interface QLAdmisiionSlideVC ()<UITableViewDelegate,UITableViewDataSource,QLSelectYearDelegate>{
    
    __weak IBOutlet UIVisualEffectView *_viewEffect;
    __weak IBOutlet UITableView *_tableMain;
    NSMutableArray *_yearMonthArray;
    QLSelectYearView *_selectYearView;

}

@end

@implementation QLAdmisiionSlideVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self test];
}
- (void)test{
    if ([[UIDevice currentDevice].systemVersion doubleValue] >= 8.0f) {
        
        UIBlurEffect *blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
        [_viewEffect setEffect:blur];
            _viewEffect.alpha = 0.5;
    }
    // 获取代表公历的NSCalendar对象
    NSCalendar *gregorian = [[NSCalendar alloc]
                             initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    // 获取当前日期
    NSDate* dt = [NSDate date];
    // 定义一个时间字段的旗标，指定将会获取指定年、月、日、时、分、秒的信息
    unsigned unitFlags = NSCalendarUnitYear |
    NSCalendarUnitMonth |  NSCalendarUnitDay |
    NSCalendarUnitHour |  NSCalendarUnitMinute |
    NSCalendarUnitSecond | NSCalendarUnitWeekday;
    // 获取不同时间字段的信息
    NSDateComponents* comp = [gregorian components: unitFlags
                                          fromDate:dt];
    // 获取各时间字段的数值
    NSLog(@"现在是%ld年" , comp.year);
    _yearMonthArray = [NSMutableArray new];
    NSString *currentYear = [NSString stringWithFormat:@"%ld",comp.year];
    for(NSInteger i=1;i<13;i++){
        NSString *str = [NSString stringWithFormat:@"%@年%ld月",currentYear,i];
        [_yearMonthArray addObject:str];
    }
    [_tableMain reloadData];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//点击背景
- (IBAction)clickBackGround:(id)sender {
    [self stopAnimation];
}

//开始动画
-(void)startAnimation{
    self.backGroundView.alpha = 0 ;
    self.mainView.frame = CGRectMake(-QLScreenWidth+60, 0, QLScreenWidth-60, QLScreenHeight);
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationSlide];
    [UIView animateWithDuration:0.35 delay:0 options:UIViewAnimationOptionAllowUserInteraction animations:^{
        self.backGroundView.alpha = 0.3;
        self.mainView.frame = CGRectMake(0, 0, QLScreenWidth-60, QLScreenHeight);
    } completion:^(BOOL finished) {
        
    }];
}
//结束动画
-(void)stopAnimation{
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationSlide];
    [UIView animateWithDuration:0.35 delay:0 options:UIViewAnimationOptionAllowUserInteraction animations:^{
        self.backGroundView.alpha = 0;
        self.mainView.frame = CGRectMake(-QLScreenWidth+60, 0, QLScreenWidth-60, QLScreenHeight);
    } completion:^(BOOL finished) {
        [self.view removeFromSuperview];
    }];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _yearMonthArray.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    QLAdmissionHomeTableCell *cell = [QLAdmissionHomeTableCell cellWithAdmissionHomeTableView:tableView];
    [cell setCellDataWithTitle:_yearMonthArray[indexPath.row]];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *year = _yearMonthArray[indexPath.row];
    self.blockSelectedDate(year);
    [self stopAnimation];
}

//所有年份
- (IBAction)btnAllYears:(id)sender {
    NSArray *nib = [[NSBundle mainBundle]loadNibNamed:@"QLSelectYearView" owner:self options:nil];
    _selectYearView= [nib objectAtIndex:0];
    _selectYearView.delegate=self;
    _selectYearView.frame = CGRectMake(0, 0, QLScreenWidth, QLScreenHeight);
    [self.view addSubview:_selectYearView];
}

- (void)selectYear:(NSString *)year{
   
    [_yearMonthArray removeAllObjects];
    for(NSInteger i=1;i<13;i++){
        NSString *str = [NSString stringWithFormat:@"%@年%ld月",year,i];
        [_yearMonthArray addObject:str];
    }
    [_tableMain reloadData];
}
@end
