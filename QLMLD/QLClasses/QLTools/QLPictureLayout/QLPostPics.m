//
//  QLPostPics.m
//  SinaNMB
//
//  Created by Shrek on 1/8/14.
//  Copyright (c) 2014 Shrek. All rights reserved.
//

#import "QLPostPics.h"
#import "QLPostPic.h"

#define kPostPicWidth 80
#define kPostPicHeight 80

#define kPostPicMargin 10

@interface QLPostPics ()

@end

@implementation QLPostPics

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        // 加载一张图片
        for (int i = 0; i < 9; i ++)
        {
            QLPostPic *postPic = [[QLPostPic alloc] init];
            [postPic setContentMode:UIViewContentModeScaleToFill];
            [self addSubview:postPic];
        }
    }
    return self;
}
-(void)startLoad{
    if (_arrPostPics.count>0) {
        NSUInteger numPostPicsCount = _arrPostPics.count;
        
        for (int index = 0; index < 9; index ++) {
            QLPostPic *postPic = self.subviews[index]; // 取出对应位置的显示对象
            [postPic hideDeleteBtn];
            
            if (index < numPostPicsCount) {
                [postPic setHidden:NO];
                
                if (numPostPicsCount == 1) {
                    [postPic setFrame:CGRectMake(0, 0, kWidthPostImage, kHeightPostImage)];
                } else {
                    NSUInteger iDivider = (numPostPicsCount == 4) ? 2 : 3; // 控制当有四张图片的时候显示2行
                    // 设置Frame
                    NSUInteger numRow = index/iDivider;
                    NSUInteger numColumn = index%iDivider;
                    [postPic setFrame:CGRectMake((kPostPicWidth+kPostPicMargin)*numColumn, (kPostPicHeight+kPostPicMargin)*numRow, kPostPicWidth, kPostPicHeight)];
                }
                // 设置图片
                id img = _arrPostPics[index];
                if ([img isKindOfClass:[UIImage class]]) {
                    [postPic setImage:img];
                }
                
                [postPic setTag:index];
                [postPic setUserInteractionEnabled:YES];
                [postPic setShouldDeleteLongPress:YES];
                [postPic addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(postPicTapAction:)]];
                __block id safeSlef = self;
                [postPic setBlockPicDeleteAction:^{
                    [safeSlef postPicDidDeleteAction:index];
                }];
            } else {
                [postPic setHidden:YES];
            }
        }
    }else{
        NSUInteger numPostPicsCount = _arrPostPicsURLs.count;
        
        for (int index = 0; index < 9; index ++) {
            QLPostPic *postPic = self.subviews[index]; // 取出对应位置的显示对象
            [postPic hideDeleteBtn];
            
            if (index < numPostPicsCount) {
                [postPic setHidden:NO];
                if (numPostPicsCount == 1) {
                    [postPic setFrame:CGRectMake(0, 0, kWidthPostImage, kHeightPostImage)];
                } else {
                    NSUInteger iDivider = (numPostPicsCount == 4) ? 2 : 3; // 控制当有四张图片的时候显示2行
                    // 设置Frame
                    NSUInteger numRow = index/iDivider;
                    NSUInteger numColumn = index%iDivider;
                    [postPic setFrame:CGRectMake((kPostPicWidth+kPostPicMargin)*numColumn, (kPostPicHeight+kPostPicMargin)*numRow, kPostPicWidth, kPostPicHeight)];
                }
                // 设置图片
                id img = _arrPostPicsURLs[index];
                if ([img isKindOfClass:[NSDictionary class]]) {
                    [postPic setStrPostPicURL:_arrPostPicsURLs[index][@"thumburl"]];
                } else {
                    [postPic setStrPostPicURL:_arrPostPicsURLs[index]];
                }
                [postPic setTag:index];
                [postPic setUserInteractionEnabled:YES];
                [postPic setShouldDeleteLongPress:YES];
                [postPic addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(postPicTapAction:)]];
                __block id safeSlef = self;
                [postPic setBlockPicDeleteAction:^{
                    [safeSlef postPicDidDeleteAction:index];
                }];
            } else {
                [postPic setHidden:YES];
            }
        }

    }
}
#pragma mark - 重写方法
- (void)setArrPostPicsURLs:(NSArray *)arrPostPicsURLs {
    _arrPostPicsURLs = arrPostPicsURLs;
}

- (void)setArrPostPics:(NSArray *)arrPostPics {
    _arrPostPics = arrPostPics;
}
- (void)setAbleDelete:(BOOL)ableDelete{
    _ableDelete = ableDelete;
}
/**
 *  @brief 调用点击的Block
 */
- (void)postPicTapAction:(UITapGestureRecognizer *)grTap {
    if (_blkDidTapPostPicAtIndex) {
        _blkDidTapPostPicAtIndex(grTap.view.tag);
    }
}
//- (void)postPicLongPressAction:(UILongPressGestureRecognizer *)longGesture{
//    if (_blkDidLongPressPostPicAtIndex) {
//        _blkDidLongPressPostPicAtIndex(longGesture.view.tag);
//    }
//}
- (void)postPicDidDeleteAction:(NSInteger)tag{
    if (_blkDidDeletePostPicAtIndex) {
        _blkDidDeletePostPicAtIndex(tag);
    }
}
+ (CGSize)postPicsSizeWithPicCount:(NSUInteger)picCount
{
    // 当图片的个数是一的时候，直接返回一张大图的size
    if (picCount == 1) return CGSizeMake(kWidthPostImage, kHeightPostImage +kPostPicMargin);
    
    NSUInteger numRow = (picCount + 2)/3;
    CGFloat fPostPicHeight = (kPostPicHeight + kPostPicMargin) * numRow;
    
    NSUInteger numColumn = picCount >= 3 ? 3 : picCount;
    CGFloat fPostPicWidth = (kPostPicWidth + kPostPicMargin) * numColumn;
    
    return CGSizeMake(fPostPicWidth, fPostPicHeight);
}

@end
