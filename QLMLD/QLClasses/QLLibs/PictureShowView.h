//
//  PictureShowView.h
//  LiChi
//
//  Created by syy on 16/4/21.
//  Copyright © 2016年 cn.forp.app. All rights reserved.
//  图片查看

#import <UIKit/UIKit.h>
@class PictureShowView;

@interface PictureShowView : UIView
@property (weak, nonatomic) IBOutlet UIImageView *imvShow;

- (void)setLookOfImage:(UIImage *)image;
+ (PictureShowView*)showImageView;
@end
