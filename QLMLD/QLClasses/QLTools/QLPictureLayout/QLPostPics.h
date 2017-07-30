//
//  QLPostPics.h
//  SinaNMB
//
//  Created by Shrek on 1/8/14.
//  Copyright (c) 2014 Shrek. All rights reserved.
//  微博配图

#import <UIKit/UIKit.h>

// 配图
#define kWidthPostImage 150
#define kHeightPostImage kWidthPostImage

@interface QLPostPics : UIView


@property (nonatomic, strong) NSArray *arrPostPicsURLs; // 所有的图片链接
@property (nonatomic, strong) NSArray *arrPostPics; // 所有的图片

/** 是否支持长按删除功能，默认NO不支持 */
@property (nonatomic,assign) BOOL ableDelete;

@property (nonatomic, copy) void (^blkDidTapPostPicAtIndex)(NSUInteger index);
//@property (nonatomic,copy) void (^blkDidLongPressPostPicAtIndex)(NSInteger index);
/** 删除图片 */
@property (nonatomic,copy) void (^blkDidDeletePostPicAtIndex)(NSInteger index);


+ (CGSize)postPicsSizeWithPicCount:(NSUInteger)picCount;

/** 开始加载 */
- (void)startLoad;

@end
