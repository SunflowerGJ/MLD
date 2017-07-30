//
//  QLPostPic.h
//  SinaNMB
//
//  Created by Shrek on 1/11/14.
//  Copyright (c) 2014 Shrek. All rights reserved.
//  一张图片

#import <UIKit/UIKit.h>

@interface QLPostPic : UIImageView

@property (nonatomic, copy) NSString *strPostPicURL;

/** 是否支持，长按删除 */
@property (nonatomic,assign) BOOL shouldDeleteLongPress;
@property (nonatomic,copy) void (^blockPicDeleteAction)();

-(void)hideDeleteBtn;

@end
