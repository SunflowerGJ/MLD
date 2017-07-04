//
//  UIImage+QLImage.h
//  HeartNet
//
//  Created by Shrek on 15/12/16.
//  Copyright © 2015年 Shreker. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, QLCurrentDeviceClass) {
    QLCurrentDeviceClass_iPhone,
    QLCurrentDeviceClass_iPhoneRetina,
    QLCurrentDeviceClass_iPhone5,
    QLCurrentDeviceClass_iPhone6,
    QLCurrentDeviceClass_iPhone6plus,
    
    // we can add new devices when we become aware of them
    
    QLCurrentDeviceClass_iPad,
    QLCurrentDeviceClass_iPadRetina,
    
    QLCurrentDeviceClass_unknown
};

@interface UIImage (QLImage)

+ (instancetype )imageForDeviceWithName:(NSString *)fileName;
+ (UIImage *)imageForOriginalWithImageName:(NSString *)imageName;
- (UIImage *)scaleToSize:(CGSize)size;
- (UIImage *)scaleMinSideToSize:(CGFloat)minSize;

/** 按照指定宽度等比压缩图片 */
- (UIImage *)imageCompressForWidth:(UIImage *)sourceImage targetWidth:(CGFloat)defineWidth;

@end