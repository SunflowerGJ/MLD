//
//  QLSelectAreaView.m
//  LiChi
//
//  Created by Shrek on 16/4/19.
//  Copyright © 2016年 cn.forp.app. All rights reserved.
//

#import "QLSelectAreaView.h"

@implementation QLSelectAreaView

- (void)awakeFromNib {
    [super awakeFromNib];
    [self startAnimation];
    self.myAreaPicker.delegate = self;
    self.myAreaPicker.dataSource = self;
    
    self.dataCity = [[AREA_ARRAY objectAtIndex:0] objectForKey:@"cities"];
    self.dataTower = [[[AREA_ARRAY objectAtIndex:0] objectForKey:@"cities"][0] objectForKey:@"counties"];

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
    [_delegate selectArea:[[AREA_ARRAY objectAtIndex:[self.myAreaPicker selectedRowInComponent: 0]] objectForKey:@"areaName"] city:[[self.dataCity objectAtIndex:[self.myAreaPicker selectedRowInComponent: 1]] objectForKey:@"areaName"] country:[[self.dataTower objectAtIndex:[self.myAreaPicker selectedRowInComponent: 2]] objectForKey:@"areaName"]];
    [self stopAnimation];
}

//有多少列
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 3;
}

//每列有几行
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (component == 0) {
        return AREA_ARRAY.count;
    }else if(component == 1){
        return self.dataCity.count;
    }else
        return self.dataTower.count;
}

//行宽
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    return QLScreenWidth/3;
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
    if (component == 0) {
        myView.text = [[AREA_ARRAY objectAtIndex:row] objectForKey:@"areaName"];
    }else if (component == 1){
        myView.text = [[self.dataCity objectAtIndex:row] objectForKey:@"areaName"];
    }else{
        myView.text = [[self.dataTower objectAtIndex:row] objectForKey:@"areaName"];
    }
    return myView;
}

//省市联动
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    if (component == 0) {
        self.dataCity = [[AREA_ARRAY objectAtIndex:row] objectForKey:@"cities"];
        [self.myAreaPicker reloadComponent: 1];
        [self.myAreaPicker selectRow: 0 inComponent:1 animated: YES];
        
        self.dataTower = [[[AREA_ARRAY objectAtIndex:row] objectForKey:@"cities"][0] objectForKey:@"counties"];
        [self.myAreaPicker reloadComponent: 2];
        [self.myAreaPicker selectRow: 0 inComponent:2 animated: YES];

        
    }else if (component == 1){
        self.dataTower = [[[AREA_ARRAY objectAtIndex:row] objectForKey:@"cities"][0] objectForKey:@"counties"];
        [self.myAreaPicker reloadComponent: 2];
        [self.myAreaPicker selectRow: 0 inComponent:2 animated: YES];
    }
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


