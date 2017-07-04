//
//  UIImage+QLImage.m
//  HeartNet
//
//  Created by Shrek on 15/12/16.
//  Copyright © 2015年 Shreker. All rights reserved.
//

#import "UIImage+QLImage.h"

QLCurrentDeviceClass currentDeviceClass() {
    CGFloat greaterPixelDimension = (CGFloat)fmaxf(((float)[[UIScreen mainScreen]bounds].size.height),
                                                   ((float)[[UIScreen mainScreen]bounds].size.width));
    switch ((NSInteger)greaterPixelDimension) {
        case 480:
            return (( [[UIScreen mainScreen]scale] > 1.0) ? QLCurrentDeviceClass_iPhoneRetina : QLCurrentDeviceClass_iPhone );
            break;
            
        case 568:
            return QLCurrentDeviceClass_iPhone5;
            break;
            
        case 667:
            return QLCurrentDeviceClass_iPhone6;
            break;
            
        case 736:
            return QLCurrentDeviceClass_iPhone6plus;
            break;
            
        case 1024:
            return (( [[UIScreen mainScreen] scale] > 1.0) ? QLCurrentDeviceClass_iPadRetina : QLCurrentDeviceClass_iPad );
            break;
            
        default:
            return QLCurrentDeviceClass_unknown;
            break;
    }
}

@implementation UIImage (QLImage)

+ (UIImage *)imageForOriginalWithImageName:(NSString *)imageName {
    return [[UIImage imageNamed:imageName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
}

- (UIImage*)scaleToSize:(CGSize)size {
    UIGraphicsBeginImageContext(size);
    [self drawInRect:(CGRect){CGPointZero, size}];
    UIImage *imgScaled = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return imgScaled;
}
- (UIImage *)scaleMinSideToSize:(CGFloat)minSize {
    if (self == nil) return nil;    
    CGFloat width = 0;
    CGFloat height = 0;
    CGFloat imageWidth = self.size.width;
    CGFloat imageHeight = self.size.height;
    CGFloat realMinSide = 0;
    if (imageWidth <= imageHeight) {
        width = minSize;
        height = imageHeight * width / imageWidth;
        realMinSide = imageWidth;
    } else {
        height = minSize;
        width = imageWidth * height / imageHeight;
        realMinSide = imageHeight;
    }
    if (realMinSide <= minSize) {
        return self;
    }
    UIImage *imageScaled = [self scaleToSize:CGSizeMake(width, height)];
    return imageScaled;
}
+ (instancetype )imageForDeviceWithName:(NSString *)fileName {
    UIImage *result = nil;
    NSString *strImageName = [fileName stringByAppendingString:[UIImage magicSuffixForDevice]];
    
    result = [UIImage imageNamed:strImageName];
    if (!result) {
        result = [UIImage imageNamed:fileName];
    }
    return result;
}
+ (NSString *)magicSuffixForDevice {
    switch (currentDeviceClass()) {
        case QLCurrentDeviceClass_iPhone:
            return @"";
            break;
            
        case QLCurrentDeviceClass_iPhoneRetina:
            return @"@2x";
            break;
            
        case QLCurrentDeviceClass_iPhone5:
            return @"-568h@2x";
            break;
            
        case QLCurrentDeviceClass_iPhone6:
            return @"-667h@2x"; //or some other arbitrary string..
            break;
            
        case QLCurrentDeviceClass_iPhone6plus:
            return @"-736h@3x";
            break;
            
        case QLCurrentDeviceClass_iPad:
            return @"~ipad";
            break;
            
        case QLCurrentDeviceClass_iPadRetina:
            return @"~ipad@2x";
            break;
            
        case QLCurrentDeviceClass_unknown:
            
        default:
            return @"";
            break;
    }
}

-(UIImage *) imageCompressForSize:(UIImage *)sourceImage targetSize:(CGSize)size{
    UIImage *newImage = nil;
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = size.width;
    CGFloat targetHeight = size.height;
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0, 0.0);
    if(CGSizeEqualToSize(imageSize, size) == NO){
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        if(widthFactor > heightFactor){
            scaleFactor = widthFactor;
        }
        else{
            scaleFactor = heightFactor;
        }
        scaledWidth = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        if(widthFactor > heightFactor){
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
        }else if(widthFactor < heightFactor){
            thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
        }
    }
    
    UIGraphicsBeginImageContext(size);
    
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    [sourceImage drawInRect:thumbnailRect];
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    if(newImage == nil){
        NSLog(@"scale image fail");
    }
    
    UIGraphicsEndImageContext();
    
    return newImage;
    
}
/** 按照指定宽度等比压缩图片 */
-(UIImage *) imageCompressForWidth:(UIImage *)sourceImage targetWidth:(CGFloat)defineWidth{
    UIImage *newImage = nil;
    //原始尺寸
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    //目标宽度
    CGFloat targetWidth = defineWidth;
    //根据目标宽度计算出目标高度
    CGFloat targetHeight = height / (width / targetWidth);
    CGSize size = CGSizeMake(targetWidth, targetHeight);
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    
    CGPoint thumbnailPoint = CGPointMake(0.0, 0.0);
    if(CGSizeEqualToSize(imageSize, size) == NO){
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        if(widthFactor > heightFactor){
            scaleFactor = widthFactor;
        }else{
            scaleFactor = heightFactor;
        }
        scaledWidth = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        if(widthFactor > heightFactor){
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
        }else if(widthFactor < heightFactor){
            thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
        }
    }
    UIGraphicsBeginImageContext(size);
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    
    [sourceImage drawInRect:thumbnailRect];
    
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    if(newImage == nil){
        NSLog(@"scale image fail");
    }
    
    UIGraphicsEndImageContext();
    return newImage;
}
@end