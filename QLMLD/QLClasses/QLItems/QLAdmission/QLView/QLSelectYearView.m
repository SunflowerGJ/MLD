//
//  QLSelectYearView.m
//  LiChi
//
//  Created by Shrek on 16/4/19.
//  Copyright © 2016年 cn.forp.app. All rights reserved.
//

#import "QLSelectYearView.h"

@implementation QLSelectYearView

- (void)awakeFromNib {
    [super awakeFromNib];
    [self startAnimation];
    self.myAreaPicker.delegate = self;
    self.myAreaPicker.dataSource = self;
    self.dataYear = [NSMutableArray new];
    for (NSInteger i=2017; i<=2037; i++) {
        [self.dataYear addObject:[NSString stringWithFormat:@"%ld",i]];
    }
    [_myAreaPicker reloadAllComponents];
 }

//开始动画
-(void)startAnimation{
    self.backGroundView.alpha = 0 ;
    self.selectView.frame = CGRectMake(0, QLScreenHeight, QLScreenWidth, 260);
    [UIView animateWithDuration:0.35 delay:0 options:UIViewAnimationOptionAllowUserInteraction animations:^{
        self.backGroundView.alpha = 0.2;
        self.selectView.frame = CGRectMake(0, QLScreenHeight-260, QLScreenWidth, 260);
    } completion:^(BOOL finished) {
        [self clearSeparatorWithView:self.myAreaPicker];
    }];
}

//结束动画
-(void)stopAnimation{
    [UIView animateWithDuration:0.35 delay:0 options:UIViewAnimationOptionAllowUserInteraction animations:^{
        self.backGroundView.alpha = 0;
        self.selectView.frame = CGRectMake(0, QLScreenHeight, QLScreenWidth, 260);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

//取消
- (IBAction)clickCancel:(id)sender {
    [self stopAnimation];
}

//保存
- (IBAction)clickSave:(id)sender{
    [_delegate selectYear:_strYear];
    [self stopAnimation];
}

//有多少列
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

//每列有几行
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
   
        return self.dataYear.count;
    
}

//行宽
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    return 150;
}

-(CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{
    return 30;
}

//pick显示字体样式
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    UILabel *myView = nil;
    myView = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 150, 30)] ;
    myView.textAlignment = NSTextAlignmentCenter;
    myView.font = [UIFont systemFontOfSize:16];
    myView.backgroundColor = [UIColor clearColor];
    myView.text = [self.dataYear objectAtIndex:row];
    return myView;
}

//省市联动
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    _strYear = [self.dataYear objectAtIndex:row];
}

//修改分割线颜色
- (void)clearSeparatorWithView:(UIView * )view
{
    if(view.subviews != 0  )
    {
        if(view.bounds.size.height < 5)
        {
            view.backgroundColor = QLYellowColor;
            view.frame = CGRectMake(view.frame.origin.x, view.frame.origin.y, view.frame.size.width, 1);
        }
        [view.subviews enumerateObjectsUsingBlock:^( UIView *  obj, NSUInteger idx, BOOL *  stop) {
            [self clearSeparatorWithView:obj];
        }];
    }
    
}

@end


