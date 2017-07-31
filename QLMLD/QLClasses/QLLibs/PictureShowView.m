//
//  PictureShowView.m
//  LiChi
//
//  Created by syy on 16/4/21.
//  Copyright © 2016年 cn.forp.app. All rights reserved.
//

#import "PictureShowView.h"
@interface PictureShowView(){
    
}
@end
@implementation PictureShowView
+ (PictureShowView*)showImageView{
    NSBundle *bundle=[NSBundle mainBundle];
    NSArray *objs=[bundle loadNibNamed:@"PictureShowView" owner:self options:nil];
    PictureShowView *view=[objs lastObject];
    return view;
}
- (void)awakeFromNib{
    [super awakeFromNib];
    self.frame=[UIApplication sharedApplication].keyWindow.bounds;
    self.center=[UIApplication sharedApplication].keyWindow.center;
    UITapGestureRecognizer *hidden = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hiddenView)];
    hidden.numberOfTapsRequired = 1;
    [_imvShow addGestureRecognizer:hidden];
}
- (void)setImvShow:(UIImageView *)imvShow{
    _imvShow = imvShow;
}
- (void)setLookOfImage:(UIImage *)image {
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    _imvShow.image = image;
}
- (IBAction)btnDelete:(id)sender {
   
}
- (void)hiddenView{
    [self removeFromSuperview];
}
@end
