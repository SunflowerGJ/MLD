//
//  QLPostPic.m
//  SinaNMB
//
//  Created by Shrek on 1/11/14.
//  Copyright (c) 2014 Shrek. All rights reserved.
//

#import "QLPostPic.h"
#import "UIImage+QLImage.h"
#import "UIImageView+WebCache.h"

#define QLImagePlaceHolderName @""

@implementation QLPostPic
{
    UIButton *_btnDelete;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.clipsToBounds = YES;
        
    }
    return self;
}
-(void)hideDeleteBtn{
    
    if (_btnDelete) {
        _btnDelete.hidden = YES;
    }
}
- (void)setStrPostPicURL:(NSString *)strPostPicURL
{
    _strPostPicURL = [strPostPicURL copy];
    NSString *strImgUrl = strPostPicURL;//kImgUrl(_strPostPicURL);
    __unsafe_unretained typeof(self) weakSelf = self;
    
    [self sd_setImageWithURL:[NSURL URLWithString:strImgUrl] placeholderImage:[UIImage imageWithName:QLImagePlaceHolderName] options:SDWebImageLowPriority | SDWebImageRetryFailed | SDWebImageLowPriority | SDWebImageProgressiveDownload completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if (image) {
            UIImage *imgFinal = [image cutImageMaxWithRatio:1.0];
            [weakSelf setImage:imgFinal];
        }
    }];
}
-(void)setShouldDeleteLongPress:(BOOL)shouldDeleteLongPress{
    _shouldDeleteLongPress = shouldDeleteLongPress;
    
    if (_shouldDeleteLongPress) {
        UILongPressGestureRecognizer *longPressGes =[[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressAction)];
        [self addGestureRecognizer:longPressGes];
    }else{
        
    }
}
-(void)longPressAction{
    if (!_btnDelete) {
        UIButton *btnDelete =[UIButton buttonWithType:UIButtonTypeCustom];
        CGRect rect = self.bounds;
        [btnDelete setFrame:CGRectMake(CGRectGetMaxX(rect)-30, CGRectGetMinY(rect), 30, 30)];
        [btnDelete setImageEdgeInsets:UIEdgeInsetsMake(5, 5, 5, 5)];
        [btnDelete setImage:[UIImage imageNamed:@"ic_btn_delete"] forState:UIControlStateNormal];
        [btnDelete addTarget:self action:@selector(btnDeleteAction) forControlEvents:UIControlEventTouchUpInside];
        _btnDelete = btnDelete;
    }
    _btnDelete.hidden = NO;
    [self addSubview:_btnDelete];
}
-(void)btnDeleteAction{
    if (_blockPicDeleteAction) {
        _blockPicDeleteAction();
    }
}
- (void)layoutSubviews {
    [super layoutSubviews];
    self.contentMode = UIViewContentModeScaleAspectFill;
}

@end
