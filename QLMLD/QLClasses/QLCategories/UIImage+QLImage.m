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

- (NSData *)resetSizeOfImageData:(UIImage *)source_image maxSize:(NSInteger)maxSize
{
    //先调整分辨率
    CGSize newSize = CGSizeMake(source_image.size.width, source_image.size.height);
    
    CGFloat tempHeight = newSize.height / 1024;
    CGFloat tempWidth = newSize.width / 1024;
    
    if (tempWidth > 1.0 && tempWidth > tempHeight) {
        newSize = CGSizeMake(source_image.size.width / tempWidth, source_image.size.height / tempWidth);
    }
    else if (tempHeight > 1.0 && tempWidth < tempHeight){
        newSize = CGSizeMake(source_image.size.width / tempHeight, source_image.size.height / tempHeight);
    }
    
    UIGraphicsBeginImageContext(newSize);
    [source_image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    //调整大小
    NSData *imageData = UIImageJPEGRepresentation(newImage,1.0);
    NSUInteger sizeOrigin = [imageData length];
    NSUInteger sizeOriginKB = sizeOrigin / 1024;
    if (sizeOriginKB > maxSize) {
        NSData *finallImageData = UIImageJPEGRepresentation(newImage,0.50);
        return finallImageData;
    }
    
    return imageData;
}
+ (UIImage *)imageWithName:(NSString *)strImgName {
    NSString *strElemment = @"@2x";
    NSString *strSuffix = @".png";
    if ([strImgName rangeOfString:strElemment].length != 0) {
        if ([strImgName hasSuffix:strSuffix]) {
            strImgName = [strImgName stringByReplacingOccurrencesOfString:strSuffix withString:@""];
        }
        strImgName = [NSString stringWithFormat:@"%@%@", strImgName, strElemment];
    }
    if (![strImgName hasSuffix:strSuffix]) {
        strImgName = [NSString stringWithFormat:@"%@%@", strImgName, strSuffix];
    }
    NSString *strImgPath = [[NSBundle mainBundle] pathForResource:strImgName ofType:nil];
    if (strImgPath == nil) {
        strImgName = [strImgName stringByReplacingOccurrencesOfString:@"@2x" withString:@""];
    }
    strImgPath = [[NSBundle mainBundle] pathForResource:strImgName ofType:nil];
    
    return [UIImage imageWithContentsOfFile:strImgPath];
}
/**
 *  @brief 根据self,返回一个按照最大比例切割出来的图片
 *
 *  @param ratio 想要的比例(像素的宽/像素的高)
 *
 *  @return 返回一个按照最大比例切割出来的图片
 */
- (UIImage *)cutImageMaxWithRatio:(CGFloat)ratio {
    CGSize sizeImage = self.size;
    CGFloat fWidthRes;
    CGFloat fHeightRes;
    UIImage *image = [[UIImage alloc] init];
    
    if (sizeImage.width > sizeImage.height) {
        fWidthRes = sizeImage.height / ratio;
        CGFloat fXRes = (sizeImage.width - fWidthRes) / 2;
        CGRect rectRes = CGRectMake(fXRes, 0, fWidthRes, sizeImage.height);
        image = [UIImage imageWithCGImage:CGImageCreateWithImageInRect(self.CGImage, rectRes)];
        return image;
    } else if (sizeImage.width < sizeImage.height) {
        fHeightRes = sizeImage.width * ratio;
        CGFloat fYRes = (sizeImage.height - fHeightRes) / 2;
        CGRect rectRes = CGRectMake(0, fYRes, sizeImage.width, fHeightRes);
        image = [UIImage imageWithCGImage:CGImageCreateWithImageInRect(self.CGImage, rectRes)];
        return image;
    } else {
        return self;
    }
    return nil;
}

@end
